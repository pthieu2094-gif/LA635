;;Pick Left to Right
(defun C:1E (/ PL p01 p02 p1 p2 p3 p4 p5 p6 ob1 ob2)
  (setvar "CMDECHO" 0)
  (IF (null PL1) (setq PL1 12))
        (setq PL (getreal (strcat "\nEnd Plate Thickness <" (rtos PL1 2 0) ">: ")))
        (if (null PL) (setq PL PL1) (setq PL1 PL))
  (setq p01 (getpoint "First Point"))
  (setq p02 (getpoint p01 "Second Point"))
  (IF (< (CAR P01) (CAR P02))
    (PROGN
  (setq p1 (list (- (car p01) 10) (cadr p01)))
  (setq p2 (list (+ (car p02) 10) (cadr p02))))
    (PROGN
  (setq p1 (list (- (car p02) 10) (cadr p02)))
  (setq p2 (list (+ (car p01) 10) (cadr p01)))))
  
  (setq p3 (list (car p2) (+ (cadr p2) 50)))
  (setq p4 (list (car p1) (+ (cadr p1) 50)))  
  (setq p5 (list (car p3) (+ (cadr p3) PL)))
  (setq p6 (list (car p4) (+ (cadr p4) PL)))

  (setq p7 (list (car p01) (+ (cadr p01) 25 )))
  (setq p8 (list (car p02) (+ (cadr p02) 25 )))
  (setq p9 (list (car p01) (+ (cadr p01) 55 )))
  (setq p10 (list (car p02) (+ (cadr p02) 55 )))
  ;SIKAGROUT
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "31 Drawing") '(100 . "AcDbPolyline")
		 '(90 . 4) '(70 . 1) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
		 (cons 10 p1) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 (cons 10 p2) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 (cons 10 p3) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 (cons 10 p4) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)' (210 0.0 0.0 1.0)))

   ;HATCK
  (setq ob1 (entlast))
  (command "TRIM" ob1 "" "F" p7 p8 "" "")
  (command "-HATCH" "S" ob1 "" "P" "ANSI37" "5" "0" "LA" "22 Hatch" "")


  ;END PLATE
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(67 . 0) '(8 . "42 Steel plate") '(100 . "AcDbPolyline")
		 '(90 . 4) '(70 . 1) '(43 . 0.0) '(38 . 0.0) '(39 . 0.0)
		 (cons 10 p4) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 (cons 10 p3) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 (cons 10 p5) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)
		 (cons 10 p6) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0)' (210 0.0 0.0 1.0)))
  (setq ob2 (entlast))
  (command "TRIM" ob2 "" "F" p9 p10 "" "")
  (princ))

  