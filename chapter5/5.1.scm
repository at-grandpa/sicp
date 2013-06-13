(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))

;Data-path-diagram
;                                                                          ---
;                                           /---------------------------->( > )
;                                           |                              ---
;           ---------                   -----------                         ^
;           |Product|                   | Counter |<-(x)--------            |
;           ---------                   -----------  counter<-y \          -----
;               ^   |                     |          ^          |          | N |
;               |   \                    / \        / \         |          -----
;      prod<-X (x)   -------\  /---------   ----\  / 1 \        |
;               ^           |  |                |  -----        |
;               |           |  |                |   |           |
;               |           v  v                v   v           |
;               |          -------             -------          |
;               |          \ mul /             \ inc /          |
;               |           -----               -----           |
;               |             |                   |             |
;               |             v                   v             |
;               |            (x) x<-mul          (x) y<-inc     |
;               |             |                   |             |
;               |             v                   v             |
;               |            -----              -----           |
;               \------------| X |              | Y |------------
;                            -----              -----

;Controller Diagram
;
;       start
;         |
;         ^
;        / \
;    /->/ > \----yes--> done
;    |  \   /
;    |   \ /
;    |    v
;    |    |
;    |    no
;    |    |
;    |    v
;    |  ----------
;    |  | x<-mul |
;    |  ----------
;    |    |
;    |    v
;    |  ----------
;    |  | y<-inc |
;    |  ----------
;    |    |
;    |    v
;    |  --------------
;    |  | product<-x |
;    |  --------------
;    |    |
;    |    v
;    |  --------------
;    \--| counter<-y |
;       --------------
