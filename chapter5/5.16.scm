(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (inst-count 0)
        (tracing #f))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                (if tracing
                    (begin (display (instruction-text (car insts)))
                           (display "\n")))
                ((instruction-execution-proc (car insts)))
                (set! inst-count (+ inst-count 1))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
              ((eq? message 'inst-count-print-reset) 
               (lambda () (display inst-count) (set! inst-count 0)))
              ((eq? message 'set-tracing-status!) 
               (lambda (status) (if status (set! tracing true) (set! tracing #f))))
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (set-tracing! machine status)
    ((machine 'set-tracing-status!) status))

;Test:
(define exp-machine
  (make-machine
   '(n b val continue)
   (list (list '- -) (list '= =) (list '* *))
   '((assign continue (label exp-end))
     exp-start
     (test (op =) (reg n) (const 0))
     (branch (label base-case))
     (save continue)
     (save n)
     (save b)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label exp-mul))
     (goto (label exp-start))
     exp-mul
     (restore b)
     (restore n)
     (restore continue)
     (assign val (op *) (reg b) (reg val))
     (goto (reg continue))
     base-case
     (assign val (const 1))
     (goto (reg continue))
     exp-end)))

;Result
;1 ]=> (set-register-contents! exp-machine 'n 3)

;Value: done

;1 ]=> (set-register-contents! exp-machine 'b 2)

;Value: done

;1 ]=> (set-tracing! exp-machine true)

;1 ]=> (start exp-machine)
;(assign continue (label exp-end))
;(test (op =) (reg n) (const 0))
;(branch (label base-case))
;(save continue)
;(save n)
;(save b)
;(assign n (op -) (reg n) (const 1))
;(assign continue (label exp-mul))
;(goto (label exp-start))
;(test (op =) (reg n) (const 0))
;(branch (label base-case))
;(save continue)
;(save n)
;(save b)
;(assign n (op -) (reg n) (const 1))
;(assign continue (label exp-mul))
;(goto (label exp-start))
;(test (op =) (reg n) (const 0))
;(branch (label base-case))
;(save continue)
;(save n)
;(save b)
;(assign n (op -) (reg n) (const 1))
;(assign continue (label exp-mul))
;(goto (label exp-start))
;(test (op =) (reg n) (const 0))
;(branch (label base-case))
;(assign val (const 1))
;(goto (reg continue))
;(restore b)
;(restore n)
;(restore continue)
;(assign val (op *) (reg b) (reg val))
;(goto (reg continue))
;(restore b)
;(restore n)
;(restore continue)
;(assign val (op *) (reg b) (reg val))
;(goto (reg continue))
;(restore b)
;(restore n)
;(restore continue)
;(assign val (op *) (reg b) (reg val))
;(goto (reg continue))
