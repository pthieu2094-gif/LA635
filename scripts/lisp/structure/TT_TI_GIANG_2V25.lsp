;;LISP VE HANG TI 2V25
;;LENH TAT TI
;;THANH TRI AUTOCAD REVIT
(defun C:TI ( / p1 p1a goc dis a p3 p3a p4 p4a p5 p5a p6 p6a)
  	(setvar "CMDECHO" 0)
        (setq osm (getvar "osmode"))
  (setq num (getreal "\nNhap so hang ti giang"))
  (setq p1 (getpoint "\nChon duong luoi truc 1."))
  (setq p1a (getpoint p1"\nChon duong luoi truc 2."))
  (setq goc (angle p1 p1a))
  (setq dis(distance p1 p1a))
  (setq a (/ dis (+ num 1)))
  (setq p3 (polar p1 goc a));ti thu nhat
  (setq p3a (polar p3 (+ goc (/ pi 2)) 5));ti thu nhat
  (setq p4 (polar p1 goc (* 2 a)));ti thu 2
  (setq p4a (polar p4 (+ goc (/ pi 2)) 5));ti thu 2
  (setq p5 (polar p1 goc (* 3 a)));ti thu 3
  (setq p5a (polar p5 (+ goc (/ pi 2)) 5));ti thu 3
  (setq p6 (polar p1 goc (* 4 a)));ti thu 4
  (setq p6a (polar p6 (+ goc (/ pi 2)) 5));ti thu 4
  (setvar "osmode" 16384)
  (command "clayer" "38 Solid rod")
  (COND 
	    ((= num 1)
	     (command "xline" p3 p3a""))
	    ((= num 2)
	     (command "xline" p3 p3a"")
	     (command "xline" p4 p4a""))
   	    ((= num 3)
	     (command "xline" p3 p3a"")
	     (command "xline" p4 p4a"")
	     (command "xline" p5 p5a""))
	    ((= num 4)
	     (command "xline" p3 p3a"")
	     (command "xline" p4 p4a"")
	     (command "xline" p5 p5a"")
	     (command "xline" p6 p6a"")))
  (command "clayer" "31 Drawing")
  (setvar "osmode" osm)
  (princ))
