(define (make-account balance password)
    (make-acc balance (list password)))

(define (make-acc balance passwords)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (add-access password)
    (begin (set! passwords (append passwords (list password))) dispatch))
  (define (dispatch pass m)
    (if (elem-in-set? pass passwords)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              ((eq? m 'add-access) add-access)
              ((eq? m 'passes) passes)
              (else (error "Unknown request -- MAKE-ACCOUNT"
                           m)))
        (error "Incorrect Password")))
  dispatch)

(define (make-joint account old-password new-password)
    ((account old-password 'add-access) new-password))

(define (elem-in-set? elem set)
    (cond ((null? set) #f)
          ((eq? elem (car set)) true)
          (else (elem-in-set? elem (cdr set)))))
