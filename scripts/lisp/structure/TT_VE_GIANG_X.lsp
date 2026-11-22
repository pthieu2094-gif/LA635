;VE GIANG X THEO PHUONG Y
;THANH TRI AUTOCAD
;LENH TAT: X1
(defun c:x1(/ pt1 pt2 pt1a pt2a ang dis centerpoint1 centerpoint2 obj)
  (setvar "CMDECHO" 0)
  (setq occho (getvar "osmode"))
  (setq pt1 (getpoint "\nFirst Point."))
  (setq pt2 (getpoint pt1"\nSecond Point."))
  (setq a (cadr pt1))
  (setq b (cadr pt2))
  (if (< a b)
    	(progn
	  (setq pt1a (polar pt1 (/ pi 2) 150))
	  (setq pt2a (polar pt2 (/ pi -2) 150)))
    	(progn
	  (setq pt1a (polar pt1 (/ pi -2) 150))
	  (setq pt2a (polar pt2 (/ pi 2) 150)))
    )
  (setq ang (angle pt1a pt2a))
  (setq dis (distance pt1a pt2a))
  (setq centerpoint1 (polar pt1a ang (/ (float dis) (float 2))))
  (setq centerpoint2 (polar centerpoint1 (/ pi 2) 10))
  (setvar "osmode" 16384); tat che do bat diem
  (command "clayer" "34 Border (bold wide)_Bracing_Flashing")
  (command "line" pt1a pt2a "")
  (setq obj (entlast))
  (command "mirror" obj "" centerpoint1 centerpoint2 "n")
  (command "clayer" "31 Drawing")
  (setvar "osmode" occho); bat lai che do bat diem
  (princ))
    	
;VE GIANG X THEO PHUONG X
;THANH TRI AUTOCAD
;LENH TAT: X2
(defun c:x2(/ pt1 pt2 pt1a pt2a ang dis centerpoint1 centerpoint2 obj)
  (setvar "CMDECHO" 0)
  (setq occho (getvar "osmode"))
  (setq pt1 (getpoint "\nFirst Point."))
  (setq pt2 (getpoint pt1"\nSecond Point."))
  (setq a (cadr pt1))
  (setq b (cadr pt2))
  (if (< a b)
    	(progn
	  (setq pt1a (polar pt1 0 150))
	  (setq pt2a (polar pt2 pi 150)))
    	(progn
	  (setq pt1a (polar pt1 pi 150))
	  (setq pt2a (polar pt2 0 150)))
    )
  (setq ang (angle pt1a pt2a))
  (setq dis (distance pt1a pt2a))
  (setq centerpoint1 (polar pt1a ang (/ (float dis) (float 2))))
  (setq centerpoint2 (polar centerpoint1 (/ pi 2) 10))
  (setvar "osmode" 16384); tat che do bat diem
  (command "clayer" "34 Border (bold wide)_Bracing_Flashing")
  (command "line" pt1a pt2a "")
  (setq obj (entlast))
  (command "mirror" obj "" centerpoint1 centerpoint2 "n")
  (command "clayer" "31 Drawing")
  (setvar "osmode" occho); bat lai che do bat diem
  (princ))
    	
  