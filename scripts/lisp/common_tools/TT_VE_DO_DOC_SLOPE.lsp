;HAM CHEN BLOCK ATTT
(defun MakeInsert (Blkname inspoint scale ang layer color att1 / lst obj i en x )
	(setq i -1
	      en (cdr (last (tblsearch "block" Blkname)))
	      obj (entget en))
	  
	(if (= (cdr(assoc 0 obj)) "ATTDEF")
	(setq lst (list (list
 			(cdr(assoc 10 obj))
			(cdr(assoc 11 obj))
			(cdr(assoc 50 obj))
			(cdr(assoc 8 obj))
			(cdr(assoc 70 obj))
			(cdr(assoc 62 obj))
 			(cdr(assoc 40 obj))
			(assoc 7 obj)
			(assoc 71 obj)
			(cons 72 4)
			(assoc 2 obj)))))
	(while  (setq en (entnext en))
		(if (= (cdr(assoc 0 (setq obj(entget en)))) "ATTDEF")
 	(setq lst (cons (list
 			(cdr(assoc 10 obj))
			(cdr(assoc 11 obj))
			(cdr(assoc 50 obj))
			(cdr(assoc 8 obj))
			(cdr(assoc 70 obj))
			(cdr(assoc 62 obj))
 			(cdr(assoc 40 obj))
			(assoc 7 obj)
			(assoc 71 obj)
			(cons 72 4)
			(assoc 2 obj))lst))))
  
	(entmakex(list
 			'(0 . "INSERT")'
			(100 . "AcDbEntity")
 			(cons 8 (if Layer Layer (getvar "Clayer")))
 			(cons 62 (if Color Color 256))
 			'(100 . "AcDbBlockReference")'(66 . 1)
 			(cons 2 Blkname)
 			(cons 10 (trans inspoint 1 0))
 			(cons 41 scale)
			(cons 42 scale)
			(cons 43 scale)
 			(cons 50 Ang)))
	(if lst
		(foreach LL (reverse lst)
		  (entmake(list
 				'(0 . "ATTRIB")
				'(100 . "AcDbEntity")
				(cons 8 (cadddr LL))
				(cons 60 (nth 4 LL))
				(if (nth 5 LL) (cons 62 (nth 5 LL)) '(62 . 256))'(100 . "AcDbText")
 				(cons 10(mapcar'+(trans inspoint 1 0)(mapcar'(lambda(x)(* scale x))(polar'(0 0 0)(+(angle'(0 0 0)(car LL))ang)(distance'(0 0 0)(car LL))))))
 				(cons 40 (* scale (nth 6 LL)))
 				(cons 1 att1)
 				(cons 50 (+ ang (caddr LL)))
 				'(41 . 0.8)(nth 7 LL)(nth 8 LL)(nth 9 LL)
 				(if (= 0(cdr (nth 8 LL))(cdr(nth 9 LL)))(cons 11(list 0 0 0))
 				(cons 11(mapcar'+(trans inspoint 1 0)(mapcar'(lambda(x)(* scale x))(polar'(0 0 0)(+(angle'(0 0 0)(cadr LL))ang)(distance'(0 0 0)(cadr LL)))))))
 				'(100 . "AcDbAttribute")'(280 . 0)(last LL)'(70 . 0)'(280 . 1)))))
	(cdr (assoc 330 (entget (entmakex (list '(0 . "SEQEND") (cons 8 (if Layer Layer (getvar "Clayer")))))))))
;HAM TAO BLOCK SLOPE 1
(defun TT:MAKEBLOCKSLOPE1()
     (if (not (tblsearch "BLOCK" "ATAD-TT-Slope"))
       (progn  
  ;BLOCK Header definition:  
  (entmake '((0 . "BLOCK")(2 . "ATAD-TT-Slope")(70 . 2)(10 0.0 0.0 0.0)))  
  ;POINT marker definition:
  
(entmake (list '(0 . "LWPOLYLINE")'(100 . "AcDbEntity") '(67 . 0)'(8 . "22 Hatch") '(100 . "AcDbPolyline") '(90 . 3) '(70 . 0) '(38 . 0.0) '(39 . 0.0)
	       '(10 17.5 0) '(40 . 0.22) '(41 . 0.22) '(42 . 0.0) '(91 . 0)
	       '(10 2.5 0) '(40 . 1.5) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
	       '(10 0 0) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0)))
  ;Text ATTRIBUTE definition:
(entmake (list  '(0 . "ATTDEF")'(100 . "AcDbEntity") '(67 . 0)'(8 . "12 Text-title") '(100 . "AcDbText")
		'(10 5.2381 0.75 0.0) '(40 . 2.5) '(1 . "i=10%") '(50 . 0.0) '(41 . 0.8) '(51 . 0.0) '(7 . "VNI")
		'(71 . 0) '(72 . 1) '(11 10.0 2.0 0.0) '(210 0.0 0.0 1.0) '(100 . "AcDbAttributeDefinition") '(280 . 0) '(3 . "") '(2 . "SLOPE") '(70 . 0) '(73 . 0) '(74 . 2) '(280 . 1)))
  ;BLOCK's ending definition:  
   (entmake     (list
                   (cons 0 "ENDBLK")
                   (cons 8 "0")     )      )
           (
               (lambda ( lst )
                   (regapp "ACAD")
                   (entmod
                       (append (subst (cons 70 4) (assoc 70 lst) lst)
                           (list
                              (list -3
                                  (list "ACAD"
                                      (cons 1000 "DesignCenter Data")
                                      (cons 1002 "{")
                                      (cons 1070 1)
                                      (cons 1070 1)
                                      (cons 1002 "}")
                                  )
                              )
                          )
                       )
                   )
               )
               (entget (cdr (assoc 330 (entget (tblobjname "BLOCK" "ATAD-TT-Slope")))))
           )))
       
   
   (princ))
;HAM TAO BLOCK SLOPE 2
(defun TT:MAKEBLOCKSLOPE2()
     (if (not (tblsearch "BLOCK" "ATAD-TT-Slope1"))
       (progn  
  ;BLOCK START
  (entmake '((0 . "BLOCK")(2 . "ATAD-TT-Slope1")(70 . 2)(10 0.0 0.0 0.0)))
  ;DOI TUONG TRONG BLOCK
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(67 . 0)'(8 . "22 Hatch") '(100 . "AcDbPolyline") '(90 . 3) '(70 . 0) '(38 . 0.0) '(39 . 0.0)
		 '(10 -17.5 0.0) '(40 . 0.22) '(41 . 0.22) '(42 . 0.0) '(91 . 0)
		 '(10 -2.5 0.0) '(40 . 1.5) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 '(10 0.0 0.0) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0) '(210 0.0 0.0 1.0)))

  ;ATT
 (entmake (list '(0 . "ATTDEF")'(100 . "AcDbEntity") '(67 . 0) '(8 . "12 Text-title") '(100 . "AcDbText")
		'(10 -14.5714 0.75 0.0) '(40 . 2.5) '(1 . "i=10%") '(50 . 0.0) '(41 . 0.8) '(51 . 0.0) '(7 . "VNI") '(71 . 0) '(72 . 1)
		'(11 -10 2.0 0.0) '(210 0.0 0.0 1.0) '(100 . "AcDbAttributeDefinition") '(280 . 0)' (3 . "") '(2 . "SLOPE") '(70 . 0) '(73 . 0)' (74 . 2) '(280 . 1)))
;BLOCK's ending definition:  
 (entmake     (list
                   (cons 0 "ENDBLK")
                   (cons 8 "0")     )      )
           (
               (lambda ( lst )
                   (regapp "ACAD")
                   (entmod
                       (append (subst (cons 70 4) (assoc 70 lst) lst)
                           (list
                              (list -3
                                  (list "ACAD"
                                      (cons 1000 "DesignCenter Data")
                                      (cons 1002 "{")
                                      (cons 1070 1)
                                      (cons 1070 1)
                                      (cons 1002 "}")
                                  )
                              )
                          )
                       )
                   )
               )
               (entget (cdr (assoc 330 (entget (tblobjname "BLOCK" "ATAD-TT-Slope1")))))
           )))
       
   
   (princ))




(defun c:S1()
   (entmake (list  '(0 . "STYLE")'(100 . "AcDbSymbolTableRecord") '(100 . "AcDbTextStyleTableRecord") '(2 . "VNI")
		   '(70 . 0) '(40 . 0.0) '(41 . 0.8) '(50 . 0.0) '(71 . 0) '(42 . 1.46)'(3 . "vn_vni.shx") '(4 . "")))
   (ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "12 Text-title") 	 '(70 . 0) '(62 . 10) 	'(6 . "Continuous")))
   (ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "22 Hatch") 	 '(70 . 0) '(62 . 8) '(6 . "Continuous")))
  (TT:MAKEBLOCKSLOPE1)
  (TT:MAKEBLOCKSLOPE2)
(setq slope (cond (slope)("P")))
(initget "P D")
(setq slope (cond ((getkword (strcat "\Slope Unit [Percent/Degree]<" slope ">")))(slope)))
  (setq varscale (GETVAR "DIMSCALE"))
  (setvar "LUPREC" 0)
  (setq p1 (getpoint"\nFirst point get angle"))
  (setq p2 (getpoint "\nSecond point get angle"))
  (setq p3 (getpoint "\nLocation of SLOPE symbol"))
  (setq ang (angle p1 p2))
(IF (or   (and (> ang 0) (< ang (/ pi 2)))   (and (> ang pi) (< ang (/ (* 3 pi) 2))))
	(progn
	(COND ((eq slope "D")
 	 (if (> ang pi) (setq ang (- ang pi)))
  	 (setq ang1 (rtos(* ang (/ 180 pi))))  
  	 (MakeInsert "ATAD-TT-Slope" p3 varscale ang "31 Drawing" 1 (strcat "i=" ang1 "%%d")))
              ((eq slope "P")

  	(if (> ang pi) (setq ang (- ang pi)))
  		(setq ang2 (* (/ (sin ang) (cos ang)) 100))
  		(setq ang1 (rtos ang2) ) 
  		(MakeInsert "ATAD-TT-Slope" p3 varscale ang "31 Drawing" 1 (strcat "i=" ang1 "%"))))
  		(PRINC))


	(progn
  	(COND ((eq slope "D")
  		(setq ang1 (rtos(- 360 (* ang (/ 180 pi)))))
  		(if (< ang pi) (PROGN (setq ang (- ang pi))
  		(setq ang1 (rtos(* ang (/ -180 pi))))))
  		(MakeInsert "ATAD-TT-Slope1" p3 varscale ang "31 Drawing" 1 (strcat "i=" ang1 "%%d")))
	((eq slope "P")	  
  		(if (< ang pi)(setq ang (- ang pi)))
  		(setq ang2 (ABS(* (/ (sin ang) (cos ang)) 100)))
  		(setq ang1 (rtos ang2))
  		(MakeInsert "ATAD-TT-Slope1" p3 varscale ang "31 Drawing" 1 (strcat "i=" ang1 "%"))))))
  	(PRINC))

