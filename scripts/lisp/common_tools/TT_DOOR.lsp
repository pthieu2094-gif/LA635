(defun c:door(/ p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20 p20a p20b d1 d2 a )
  (setq p1 (getpoint "Pick First Point"))
  (setq p1a (getpoint p1"Pick Second Point"))
  (setq w(getreal "Door Width:"))
  (setq h(getreal "Door Height:"))
  (setq d1 (distance p1 p1a))
  (while (> h d1)
     (alert "ERROR: Door height < Door frame")
     (setq h(getreal "Door Height:")))
;toa do diem do dung cua
  (setq p2 (list (- (car p1) (* w 0.5)) (cadr p1)))
  (setq p3 (list (- (car p2) 65) (cadr p2)))
  (setq p4 (list (car p3) (cadr p1a)))
  (setq p5 (list (car p2) (cadr p1a)))

  (setq p6 (list (+ (car p1) (* w 0.5)) (cadr p1)))
  (setq p7 (list (+ (car p6) 65) (cadr p6)))
  (setq p8 (list (car p7) (cadr p1a)))
  (setq p9 (list (car p6) (cadr p1a)))
;toa do diem do ngang cua
  (setq p10 (list (car p2) (+(cadr p2) h)))
  (setq p11 (list (car p2) (+(cadr p2) h 65)))
  (setq p13 (list (car p6) (+(cadr p6) h)))
  (setq p12 (list (car p6) (+(cadr p6) h 65)))
; do cua cuon
  (setq p14 (list (car p10) (+(cadr p10) 600)))
  (setq p15 (list (car p10) (+(cadr p10) 665)))
  (setq p17 (list (car p13) (+(cadr p13) 600)))
  (setq p16 (list (car p13) (+(cadr p13) 665)))
;VE KHUNG CUA

(entmake
  (list'(0 . "LWPOLYLINE")'(100 . "AcDbEntity") '(67 . 0)'(8 . "37 Purlin")'(62 . 2) '(100 . "AcDbPolyline")
	'(90 . 5) '(70 . 0) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
	(cons 10 p2) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p3) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p4) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p5) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p2) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0)))
(entmake
  (list'(0 . "LWPOLYLINE")'(100 . "AcDbEntity") '(67 . 0)'(8 . "37 Purlin")'(62 . 2) '(100 . "AcDbPolyline")
	'(90 . 5) '(70 . 0) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
	(cons 10 p6) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p7) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p8) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p9) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p6) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0)))
(entmake
  (list'(0 . "LWPOLYLINE")'(100 . "AcDbEntity") '(67 . 0)'(8 . "37 Purlin")'(62 . 2) '(100 . "AcDbPolyline")
	'(90 . 5) '(70 . 0) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
	(cons 10 p10) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p11) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p12) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p13) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p10) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0)))
(entmake
  (list'(0 . "LWPOLYLINE")'(100 . "AcDbEntity") '(67 . 0)'(8 . "37 Purlin")'(62 . 2) '(100 . "AcDbPolyline")
	'(90 . 5) '(70 . 0) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
	(cons 10 p14) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p15) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p16) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p17) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p14) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0)))
(entmake
  (list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "32 Gridline") '(100 . "AcDbLine")
  (cons 10 p2) (cons 11 p13) '(210 0.0 0.0 1.0)))
(entmake
  (list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "32 Gridline") '(100 . "AcDbLine")
  (cons 10 p6) (cons 11 p10) '(210 0.0 0.0 1.0)))
(if (> (/ w 1000) 4.5) (setq a 6)
  (if (> (/ w 1000) 2.9) (setq a 4) (setq a 2)))
(setq d2 (/ w a))

  
;VE V 40 KEO
(cond ((= a 2)
       (setq p20a (polar p11 0 (- d2 32.5)))
       (setq p20b (polar p12 pi (- d2 32.5)))
       (setq p21a (polar p15 0 (- d2 32.5)))
       (setq p21b (polar p16 pi (- d2 32.5)))
       (setq p21a (polar p15 0 (- d2 32.5)))
       (setq p21a1 (polar p21a 0 d2))
       (setq p21b (polar p16 pi (- d2 32.5)))
       (setq p21a1 (polar p21b pi d2))

       (setq p23a (polar p5 0 (+ d2 32.5)))
       ;(setq p22a1 (polar p22a 0 d2))
       (setq p23b (polar p9 pi (+ d2 32.5)))
       ;(setq p22b1 (polar p22b pi d2))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p14) (cons 11 p20a) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p17) (cons 11 p20b) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p5) (cons 11 p21a) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p9) (cons 11 p21b) '(210 0.0 0.0 1.0))))

      ((= a 4)
       (setq p20a (polar p11 0 (- d2 32.5)))
       (setq p20a1 (polar p20a 0 d2))
       (setq p20b (polar p12 pi (- d2 32.5)))
       (setq p20b1 (polar p20b pi d2))
       
       (setq p22a (polar p14 0 (+ d2 32.5)))
       ;(setq p22a1 (polar p22a 0 d2))
       (setq p22b (polar p17 pi (+ d2 32.5)))
       ;(setq p22b1 (polar p22b pi d2))
       
       (setq p21a (polar p15 0 (- d2 32.5)))
       (setq p21a1 (polar p21a 0 d2))
       (setq p21b (polar p16 pi (- d2 32.5)))
       (setq p21b1 (polar p21b pi d2))

       (setq p23a (polar p5 0 (+ d2 32.5)))
       ;(setq p22a1 (polar p22a 0 d2))
       (setq p23b (polar p9 pi (+ d2 32.5)))
       ;(setq p22b1 (polar p22b pi d2))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p5) (cons 11 p21a) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p9) (cons 11 p21b) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p23a) (cons 11 p21a1) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p23b) (cons 11 p21b1) '(210 0.0 0.0 1.0)))


       
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p14) (cons 11 p20a) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p17) (cons 11 p20b) '(210 0.0 0.0 1.0)))       
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p22a) (cons 11 p20a1) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p22b) (cons 11 p20b1) '(210 0.0 0.0 1.0))))

  ((= a 6)
       (setq p20a (polar p11 0 (- d2 32.5)))
       (setq p20a1 (polar p20a 0 d2))
       (setq p20a2 (polar p20a1 0 d2))
       (setq p20b (polar p12 pi (- d2 32.5)))
       (setq p20b1 (polar p20b pi d2))
       (setq p20b2 (polar p20b1 pi d2))
       
       (setq p22a (polar p14 0 (+ d2 32.5)))
       (setq p22a1 (polar p22a 0 d2))
       (setq p22b (polar p17 pi (+ d2 32.5)))
       (setq p22b1 (polar p22b pi d2))
       
       (setq p21a (polar p15 0 (- d2 32.5)))
       (setq p21a1 (polar p21a 0 d2))
       (setq p21a2 (polar p21a1 0 d2))
       (setq p21b (polar p16 pi (- d2 32.5)))
       (setq p21b1 (polar p21b pi d2))
       (setq p21b2 (polar p21b1 pi d2))

       (setq p23a (polar p5 0 (+ d2 32.5)))
       (setq p23a1 (polar p23a 0 d2))
       (setq p23b (polar p9 pi (+ d2 32.5)))
       (setq p23b1 (polar p23b pi d2))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p5) (cons 11 p21a) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p9) (cons 11 p21b) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p23a) (cons 11 p21a1) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p23b) (cons 11 p21b1) '(210 0.0 0.0 1.0)))
   ;loi~
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p23a1) (cons 11 p21a2) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p23b1) (cons 11 p21b2) '(210 0.0 0.0 1.0)))

       
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p14) (cons 11 p20a) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p17) (cons 11 p20b) '(210 0.0 0.0 1.0)))       
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p22a) (cons 11 p20a1) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p22b) (cons 11 p20b1) '(210 0.0 0.0 1.0)))
    (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
  	(cons 10 p22a1) (cons 11 p20a2) '(210 0.0 0.0 1.0)))
   (entmake
  	(list'(0 . "LINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "36 Tole") '(100 . "AcDbLine")
	(cons 10 p22b1) (cons 11 p20b2) '(210 0.0 0.0 1.0)))   ))

;(setq d2 (/ w a))
(setq d3 (distance p15 p5))
(REPEAT (- a 1)
  (setq p18 (polar p11 0 (* (- a 1) d2)))
  (setq p19 (polar p15 0 (* (- a 1) d2)))
  (C-GIRT p18 535)
  (C-GIRT p19 d3)
  (setq a (- a 1))))


  
;;;ham con ve c
(defun C-GIRT ( p0 x / p1 p2 p3 p4)
  (setq p1 (list (- (car p0) 32.5) (cadr p0)))
  (setq p2 (list (car p1) (+ (cadr p1) x)))
  (setq p4 (list (+ (car p0) 32.5) (cadr p0)))
  (setq p3 (list (car p4) (+ (cadr p4) x)))
  (entmake
  (list'(0 . "LWPOLYLINE")'(100 . "AcDbEntity") '(67 . 0)'(8 . "37 Purlin")'(62 . 2) '(100 . "AcDbPolyline")
	'(90 . 5) '(70 . 0) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
	(cons 10 p1) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p2) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p3) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p4) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	(cons 10 p1) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0))))


  ;(entget(car(entsel)))