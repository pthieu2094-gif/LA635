;LISP VE LO OVAN
;THANH TRI AUTOCAD REVISED
;LENH TAT OV
(defun c:OV (/ x2 x3 x1 pt1 pt2 pt3 pt4 pt5 pt6 pt7 pt8 pt9)
    (setq osm (getvar "osmode")
  	x2 (getint "\nLeng: ")
	x3 (getint "\nDiameter: ")
        x1 (getpoint "\nPick Center: ")
	pt1 (polar x1 (* 0.5 pi) (/ x3 2))
        pt2 (polar pt1 pi (- (/ x2 2) (/ x3 2)))
	pt3 (polar pt2 (* 1.5 pi) x3)
	pt4 (polar pt3 0 (- x2 x3))
	pt5 (polar pt4 (* 0.5 pi) x3)
	pt6 (polar pt1 (* 0.5 pi) (* 0.25 x3))
	pt7 (polar pt1 (* 1.5 pi) (* 1.25 x3))
	pt8 (polar x1 pi (+ (/ x2 2) (* 0.25 x3)))
	pt9 (polar pt8 0 (+ x2 (* 0.5 x3)))
	)
    (command "osmode" 0)
  (command "clayer" "43 Bolt")
  (command "pline" pt5 pt2 "a" pt3 "l" pt4 "a" pt5 "")		; SLOT HOLE
  (command "clayer" "32 Gridline")
  (command "line" pt6 pt7 "")					; CENTER
  (command "line" pt8 pt9 "")					; CENTER
  (command "clayer" "31 Drawing")
  (command "osmode" 1)
  (setvar "osmode" osm)
  (princ)							; THE END
  )
