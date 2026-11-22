(defun etype (e)
(cdr (assoc 0 (entget e))))
;;;=============================================================================================
;;;=============================================================================================
(defun wtxt (txt p / sty d h);;;Write txt on graphic screen, defaul setting
(setq
	sty (getvar "textstyle")
	d (tblsearch "style" sty)
	h (cdr (assoc 40 d)))
(if (= h 0) (setq h (cdr (assoc 42 d))))
(entmake
	(list (cons 0 "TEXT") (cons 7 sty) (cons 1 txt) (cons 10 p) (cons 40 h) (assoc 41 d))))
;;;=============================================================================================
;;;=============================================================================================
(defun incN (n dn / n2 i n1);;;Increase number n
(setq
	n2 (itoa (+ dn (atoi n)))
	i (- (strlen n) (strlen n2)))
(if (> i 0) (setq n1 (substr n 1 i)) (setq n1 ""))
(strcat n1 n2))
;;;=============================================================================================
;;;=============================================================================================
(defun incC (c / i c1 c2);;;Increase character c
(setq
	i (strlen c)
	c1 (substr c 1 (- i 1))
	c2 (chr (1+ (ascii (substr c i 1)))))
(if (or (= c2 "{") (= c2 "["))
	(progn (command "erase" (entlast) "") (alert "Over character!") (exit))
	(strcat c1 c2)))
;;;=============================================================================================
;;;=============================================================================================
(defun f1 ( l ) 
   (car (vl-sort l (function (lambda ( a b ) (< (car a) (car b)))))))
;;;=============================================================================================
;;;=============================================================================================
(defun f2 ( l ) 
   (car (vl-sort l (function (lambda ( a b ) (< (cadr a) (cadr b)))))))
;;;=============================================================================================
;;;=============================================================================================
(defun f3 ( l ) 
   (car (vl-sort l (function (lambda ( a b ) (> (cadr a) (cadr b)))))))
;;;=============================================================================================
;;;=============================================================================================
(defun f4 ( l ) 
   (car (vl-sort l (function (lambda ( a b ) (> (car a) (car b)))))))
;;;=============================================================================================
;;;=============================================================================================
(defun C:R1( / occho int1 list1 ss1 ssl1 e e0 dn a1 cn c n a2 dat);;;Make Ordinal number. Copy from Atttribute block
  (setq occho (getvar "osmode"))
  (setq int1(getvar "dimscale"))
  (setq list1 (list))
  (setq ss1 (ssget (list(cons 0 "LINE"))))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1
  (setq o2 (ssname ss1 a))
  (setq o222 (entget o2))
  (setq ct02 (assoc 11 o222))
  (setq ct0002 (cdr ct02))
  (setq ct002 (cadr(cdr ct02)))
  (setq ct03 (assoc 10 o222))
  (setq ct0003 (cdr ct03))
  (setq ct003 (cadr(cdr ct03)))
  (if (< ct003 ct002)
  (setq ct3 ct0003)(setq ct3 ct0002))
  (setq ct4 (list ct3))
  (setq list1 (append ct4 list1 ))
  (setq a (+ 1 a)))   ; KET THUC VONG LAP
  (setq a2 (f1 list1)); DIEM DAU TIEN
  (setq a3 ( polar a2 (/ pi -2) (* 5 int1)))
  (setvar "osmode" 16384)
  (command "-insert" "ATAD_GRIDLINE_TAG" a3 int1 0 )
  (setq e0 (entlast)
	 e (entnext e0))
  (if (/= (etype e) "ATTRIB") (progn (alert "Object is not a Attribute Block!") (exit)))
  (setq dn (getint "\nIncrement <1>: ")
	 cn (cdr (assoc 1 (entget e))))
  (if (not dn) (setq dn 1))
  (if (= cn "") (setq cn "1"))
  (setq
	c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn)
	n (vl-string-subst "" c cn))  
  (setq list1(vl-remove a2 list1));;lay GTNN
  (repeat (- ssl1 1) (setq a1 (f1 list1))
  (setq list1(vl-remove a1 list1))
  (command "copy" e0 "" a2 a1)
	(if (= n "") 
		(setq cn (incC cn))
		(setq cn (strcat c (incN (vl-string-subst "" c cn) dn))))
	(setq
		dat (entget (entnext (entlast)))
		dat (subst (cons 1 cn) (assoc 1 dat) dat))
	(entmod dat)
	(command "regen"))
        (setvar "osmode" occho)
               (princ))
;;;=============================================================================================
;;;=============================================================================================
(defun C:R2( / occho int1 list1 ss1 ssl1 e e0 dn a1 cn c n a2 dat);;;Make Ordinal number. Copy from Atttribute block
  (setq occho (getvar "osmode"))
  (setq int1(getvar "dimscale"))
  (setq list1 (list))
  (setq ss1 (ssget (list(cons 0 "LINE"))))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1
  (setq o2 (ssname ss1 a))
  (setq o222 (entget o2))
  (setq ct02 (assoc 11 o222))
  (setq ct0002 (cdr ct02))
  (setq ct002 (cadr(cdr ct02)))
  (setq ct03 (assoc 10 o222))
  (setq ct0003 (cdr ct03))
  (setq ct003 (cadr(cdr ct03)))
  (if (< ct003 ct002)
  (setq ct3 ct0003)(setq ct3 ct0002))
  (setq ct4 (list ct3))
  (setq list1 (append ct4 list1 ))
  (setq a (+ 1 a)))   ; KET THUC VONG LAP
  (setq a2 (f4 list1)); DIEM DAU TIEN
  (setq a3 ( polar a2 (/ pi -2) (* 5 int1)))
  (setvar "osmode" 16384)
  (command "-insert" "ATAD_GRIDLINE_TAG" a3 int1 0 )
  (setq e0 (entlast)
	 e (entnext e0))
  (if (/= (etype e) "ATTRIB") (progn (alert "Object is not a Attribute Block!") (exit)))
  (setq dn (getint "\nIncrement <1>: ")
	 cn (cdr (assoc 1 (entget e))))
  (if (not dn) (setq dn 1))
  (if (= cn "") (setq cn "1"))
  (setq
	c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn)
	n (vl-string-subst "" c cn))  
  (setq list1(vl-remove a2 list1));;lay GTNN
  (repeat (- ssl1 1) (setq a1 (f4 list1))
  (setq list1(vl-remove a1 list1))
  (command "copy" e0 "" a2 a1)
  (if (= n "") 
  (setq cn (incC cn))
  (setq cn (strcat c (incN (vl-string-subst "" c cn) dn))))
  (setq
		dat (entget (entnext (entlast)))
		dat (subst (cons 1 cn) (assoc 1 dat) dat))
  (entmod dat)
  (command "regen"))
  (setvar "osmode" occho)
  (princ))
;;;=============================================================================================
;;;=============================================================================================
(defun C:R3( / occho int1 list1 ss1 ssl1 e e0 dn a1 cn c n a2 dat);;;Make Ordinal number. Copy from Atttribute block
  (setq occho (getvar "osmode"))
  (setq int1(getvar "dimscale"))  
  (setq list1 (list))
  (setq ss1 (ssget (list(cons 0 "LINE"))))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1
  (setq o2 (ssname ss1 a))
  (setq o222 (entget o2))
  (setq ct02 (assoc 11 o222))
  (setq ct0002 (cdr ct02))
  (setq ct002 (car(cdr ct02)))
  (setq ct03 (assoc 10 o222))
  (setq ct0003 (cdr ct03))
  (setq ct003 (car(cdr ct03)))
  (if (< ct003 ct002)
  (setq ct3 ct0003)(setq ct3 ct0002))
  (setq ct4 (list ct3))
  (setq list1 (append ct4 list1 ))
  (setq a (+ 1 a)))    ; KET THUC VONG LAP
  (setq a2 (f2 list1)) ; DIEM DAU TIEN
  (setq a3 ( polar a2 pi (* 5 int1)))
  (setvar "osmode" 16384)
  (command "-insert" "ATAD_GRIDLINE_TAG" a3 int1 0 )
  (setq e0 (entlast)
	 e (entnext e0))
  (if (/= (etype e) "ATTRIB") (progn (alert "Object is not a Attribute Block!") (exit)))
  (setq dn (getint "\nIncrement <1>: ")
	 cn (cdr (assoc 1 (entget e))))
  (if (not dn) (setq dn 1))
  (if (= cn "") (setq cn "1"))
  (setq
	c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn)
	n (vl-string-subst "" c cn))  
  (setq list1(vl-remove a2 list1));;lay GTNN
  (repeat (- ssl1 1) (setq a1 (f2 list1))
  (setq list1(vl-remove a1 list1))
  (command "copy" e0 "" a2 a1)
  (if (= n "") 
  (setq cn (incC cn))
  (setq cn (strcat c (incN (vl-string-subst "" c cn) dn))))
  (setq
		dat (entget (entnext (entlast)))
		dat (subst (cons 1 cn) (assoc 1 dat) dat))
  (entmod dat)
  (command "regen"))
  (setvar "osmode" occho)
  (princ))

;;;=============================================================================================
;;;=============================================================================================
(defun C:R4( / occho int1 list1 ss1 ssl1 e e0 dn a1 cn c n a2 dat);;;Make Ordinal number. Copy from Atttribute block
  (setq occho (getvar "osmode"))
  (setq int1(getvar "dimscale"))  
  (setq list1 (list))
  (setq ss1 (ssget (list(cons 0 "LINE"))))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1
  (setq o2 (ssname ss1 a))
  (setq o222 (entget o2))
  (setq ct02 (assoc 11 o222))
  (setq ct0002 (cdr ct02))
  (setq ct002 (car(cdr ct02)))
  (setq ct03 (assoc 10 o222))
  (setq ct0003 (cdr ct03))
  (setq ct003 (car(cdr ct03)))
  (if (< ct003 ct002)
  (setq ct3 ct0003)(setq ct3 ct0002))
  (setq ct4 (list ct3))
  (setq list1 (append ct4 list1 ))
  (setq a (+ 1 a)))   ; KET THUC VONG LAP
  (setq a2 (f3 list1)); DIEM DAU TIEN
  (setq a3 ( polar a2 pi (* 5 int1)))
  (setvar "osmode" 16384)
  (command "-insert" "ATAD_GRIDLINE_TAG" a3 int1 0 )
  (setq e0 (entlast)
	 e (entnext e0))
  (if (/= (etype e) "ATTRIB") (progn (alert "Object is not a Attribute Block!") (exit)))
  (setq dn (getint "\nIncrement <1>: ")
	 cn (cdr (assoc 1 (entget e))))
  (if (not dn) (setq dn 1))
  (if (= cn "") (setq cn "1"))
  (setq
	c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn)
	n (vl-string-subst "" c cn))  
  (setq list1(vl-remove a2 list1));;lay GTNN
  (repeat (- ssl1 1) (setq a1 (f3 list1))
  (setq list1(vl-remove a1 list1))
  (command "copy" e0 "" a2 a1)
  (if (= n "") 
  (setq cn (incC cn))
  (setq cn (strcat c (incN (vl-string-subst "" c cn) dn))))
  (setq
		dat (entget (entnext (entlast)))
		dat (subst (cons 1 cn) (assoc 1 dat) dat))
  (entmod dat)
  (command "regen"))
  (setvar "osmode" occho)
  (princ))


