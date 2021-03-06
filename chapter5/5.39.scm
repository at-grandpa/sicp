(define (lexical-address-lookup env lex-addr)
    (define (scan values v-index)
        (cond ((null? values) (error "Out of bounds"))
              ((= v-index 0) (let ((val (car values)))
                                (if (eq? val '*unassigned*)
                                    (error "Accessing uninitialized variable")
                                    val)))
              (else (scan (cdr values) (- v-index 1)))))
    (define (env-loop e e-index)
        (cond ((eq? e the-empty-environment) (error "Out of bounds"))
              ((= e-index 0) (scan (frame-values (first-frame e)) (cdr lex-addr)))
              (else (env-loop (enclosing-environment e) (- e-index 0)))))
    (env-loop env (car lex-addr)))

(define (lexical-address-set! env lex-addr val)
    (define (scan values v-index)
        (cond ((null? values) (error "Out of bounds"))
              ((= v-index 0) (set-car! values val))
              (else (scan (cdr values) (- v-index 1)))))
    (define (env-loop e e-index)
        (cond ((eq? e the-empty-environment) (error "Out of bounds"))
              ((= e-index 0) (scan (frame-values (first-frame e)) (cdr lex-addr)))
              (else (env-loop (enclosing-environment e) (- e-index 0)))))
    (env-loop env (car lex-addr)))
