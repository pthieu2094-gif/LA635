;;;========== HAM VE DUONG TRON CO DUONG TAM==========;;;
(defun HH1 ( p dk / kw p p1 p2 p3 p4 )
  	(setvar "CMDECHO" 0)
        (setq osm (getvar "osmode"))
		(setq p1 (polar p pi (* 0.8 dk)))
		(setq p2 (polar p 0(* 0.8 dk)))
		(setq p3 (polar p (/ pi 2) (* 0.8 dk)))
		(setq p4 (polar p (/ pi -2) (* 0.8 dk)))
		(command "osnap" "off")
   		(command "clayer" "43 Bolt")
		(command ".circle" p "d" dk )
  		(command "clayer" "32 Gridline")
		(command ".line" p1 p2  "")
		(command ".line" p3 p4  "")
  		(command "clayer" "31 Drawing")
	        (setvar "osmode" osm))

;;;LISP VE COT DAM THAY CANH
;;;THANH TRI AUTOCAD REVIT
(defun c:fc(/ GOC PT1 PT2 PT3 PT4 PT5 PT6 PT7 PT8 PT9 PT10 f w)
  (setvar "CMDECHO" 0)
  (setq osm (getvar "osmode"))
  (setq f(getreal "\nNhap chieu rong canh.")
	w(getreal "\nNhap chieu day bung.")
        PT1(getpoint "\nFisrt point.")
	PT2(getpoint PT1"\nSecond point.")
	GOC(angle PT1 PT2)
	PT3(polar PT1 (+ GOC (/ pi 2)) (/ w 2))
	PT5(polar PT1 (+ GOC (/ pi -2)) (/ w 2))
	PT4(polar PT2 (+ GOC (/ pi 2)) (/ w 2))
 	PT6(polar PT2 (+ GOC (/ pi -2)) (/ w 2))
	PT7(polar PT1 (+ GOC (/ pi 2)) (/ f 2))
	PT8(polar PT2 (+ GOC (/ pi -2)) (/ f 2))
	PT9(polar PT2 (+ GOC (/ pi 2)) (/ f 2))
	PT10(polar PT1 (+ GOC (/ pi -2)) (/ f 2)))
  (setvar "osmode" 16384)
  (command "PLINE" PT7 PT9 PT8 PT10 "C")
  (command "clayer" "HIDDEN")
  (command "LINE" PT3 PT4"")
  (command "LINE" PT5 PT6"")
  (command "clayer" "31 Drawing")
  (setvar "osmode" osm)
  (princ)
  );THE END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;LISP VE COT DAM THAY BUNG
;;;THANH TRI AUTOCAD REVIT
(defun c:wc(/ GOC PT1 PT2 PT3 PT4 PT5 PT6 PT7 PT8 PT9 PT10 tf tw h)
  (setvar "CMDECHO" 0)
  (setq osm (getvar "osmode"))
  (setq tf(getreal "\nNhap chieu day canh.")
	tw(getreal "\nNhap chieu cao bung.")
	h(+ tw (* 2 tf))	
        PT1(getpoint "\nFisrt point.")
	PT2(getpoint PT1"\nSecond point.")
	GOC(angle PT1 PT2)
	PT3(polar PT1 (+ GOC (/ pi 2)) (/ tw 2))
	PT5(polar PT1 (+ GOC (/ pi -2)) (/ tw 2))
	PT4(polar PT2 (+ GOC (/ pi 2)) (/ tw 2))
 	PT6(polar PT2 (+ GOC (/ pi -2)) (/ tw 2))
	PT7(polar PT1 (+ GOC (/ pi 2)) (/ h 2))
	PT8(polar PT2 (+ GOC (/ pi -2)) (/ h 2))
	PT9(polar PT2 (+ GOC (/ pi 2)) (/ h 2))
	PT10(polar PT1 (+ GOC (/ pi -2)) (/ h 2)))
  (setvar "osmode" 16384)
  (command "PLINE" PT7 PT9 PT8 PT10 "C")
  (command "clayer" "33 Flange steel")
  (command "LINE" PT3 PT4"")
  (command "LINE" PT5 PT6"")
  (command "clayer" "31 Drawing")
  (setvar "osmode" osm)
  (princ)
  );THE END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;LISP VE LIEN KET MC6 MAT BANG
(defun tri ( p1 p2 b / occho x1 x2 a b c p5 p6 p7 p8 p3 p4 d)
  (setvar "cmdecho" 0) 
  (setq occho (getvar "osmode"))
  ;(setq p1 (getpoint "\nFirst point:"))
  ;(setq p2 (getpoint p1"\nSecond point:"))
  (setq x1 (distance p1 p2))
  (setq x2 (* 0.25 x1))
  (setq a (angle p1 p2))
  (initget 1)
  ;(setq b(getreal "\nDiameter:"))
  (setq c(/ b 2))
  (setq p5 (polar p1 (+ a  (/ pi -2)) c))
  (setq p6 (polar p1 (+ a (/ pi 2)) c))
  (setq p7 (polar p2 (+ a (/ pi -2)) c))
  (setq p8 (polar p2 (+ a (/ pi 2)) c))
  (setvar "osmode" 16384)
  (command "clayer" "43 Bolt")
  (command ".line" p1 p2 "")
  (setq p3(nentselp "chon doi tuong" p1))
  (setq p4(nentselp "chon doi tuong" p2))
  (command "lengthen" "de" x2 p3 p4"")  
  (command ".pline" p5 p6 p8 p7 p5"")
  (setq d(entlast))
  (setvar "HPNAME" "solid")
  (command "-hatch" "a" "a" "y" "" "la" "43 bolt" "s" d"" "")
  (command "clayer" "31 Drawing")
  (setvar "osmode" occho)
  (princ))
;;;;;;;;;;
(defun c:BMC6(/ PT1 PT2 PT3 PT4 PT5 PT6 PT7 PT8);
	(setvar "cmdecho" 0) 
	(setq 	occho (getvar "osmode"))
	(setq   tb(getreal"\nNhap chieu day ban ma."))
	(setq	b(getreal "\nDiameter:"))
	(setq	PT1(getpoint "\nFisrt point."))
	(setq	PT2(getpoint PT1"\nSecond point."))
        (setq	PT1A(getpoint PT1"\nThird point."))
        (setq   dis(distance PT1 PT1A))
	(setq	GOC(angle PT2 PT1))
	(setq	PT3(polar PT2 (+ GOC (/ pi 2)) tb))
	(setq	PT5(polar PT1 (+ GOC pi) 10))
	(setq	PT4(polar PT5 (+ GOC (/ pi 2)) tb))
	(setq	PT6(polar PT1 (+ GOC (/ pi 2)) tb))
	(setq	PT9(polar PT1 GOC 100))
	(setq	PT8(polar PT9 (+ GOC (/ pi 2)) tb))
        (setq	PT7(polar PT6  GOC 50))
       	(setq   PT10(polar PT1A GOC 50))
  (setvar "osmode" 16384)
  (command "clayer" "HIDDEN")
  (command "PLINE" PT5 PT2 PT3 PT4"")
  (command "PLINE" PT6 PT8 PT9 PT1"")
  (command "clayer" "31 Drawing")
  (command "line" PT4 PT6"")
  (command "line" PT5 PT1"")
  (tri PT7 PT10 b)
  (setvar "osmode" occho)
  (princ))

;;;;;;;;;
;;;LISP VE LIEN KET MC6 MAT DUNG
(defun c:DMC6(/ p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11)
  (setq occho (getvar "osmode"))
  (setq w(getreal "Height web"))
  (setq n (getreal "Number Bolt"))
  (setq dk (getreal "Diameter Bolt"))
  (setq p1 (getpoint "First point"))
  (setq p1a (polar p1 0 15)); chamfer
  (setq p1b (polar p1 (/ pi -2) 15)); chamfer
  (setq p2 (getpoint "Second point"))
  (setq p3 (getpoint "Third point"))
  (setq p4 (polar p3 (/ pi 2) (- (/ w 2) 17.5)))
  (if (= dk 16)(setq a 35))
    (if (= dk 20)(setq a 40))
      (if (= dk 24)(setq a 50))
	(if (= dk 30)(setq a 60))
	  (if (= dk 36)(setq a 60))
  (setq p5 (polar p4 0 (* 2 a))); goc phai tren
  (setq p6 (polar p3 (/ pi -2) (- (/ w 2) 17.5)))
  (setq p7 (polar p6 0 (* 2 a))); goc phai duoi
  (setq p8 (polar p7 pi (+ (* a 2) 10))); goc trai duoi
  (setq p9 (polar p5 pi (+ (* a 2) 10))); goc trai tren
  (setq td1 (car p1))
  (setq td2 (car p2))
  (setq x (abs(- td2 td1)))
  (setq p10 (polar p1 0 x)); mep duoi canh dam tren
  (setq p11 (polar p2 pi x)); mep tren canh dam duoi
  (setq p11a (polar p11 0 15))
  (setq p11b (polar p11 (/ pi 2) 15))
  (setq p (polar p3 0 a))
  (setq p13 (polar p5 pi a)); diem giua ban ma tren
  (setq p15 (polar p13 ( / pi -2) a)); ; diem dat bolt tu tren xuong
  (setq p14 (polar p6 0 a));; diem giua ban ma duoi
  (setq p16 (polar p14 ( / pi 2) a)); ; diem dat bolt tu duoi len
  (setq disb (distance p15 p16));; khoang cach 2 bu long tu mep vao
  (setq disb1 (/ disb (- n 1))); khoang cach giua 2 bu long
  (setq p17 (polar p16 (/ pi 2) disb1)); diem dat bolt thu 3
  (setq p18 (polar p17 (/ pi 2) disb1)); diem dat bolt thu 4
  (setq p19 (polar p18 (/ pi 2) disb1)); diem dat bolt thu 5
  (setvar "osmode" 16384)
  (command "clayer" "42 Steel plate")
  (command "pline" p9 p5 p7 p8 p2 p11a p11b p1b p1a p10 "c"); ban ma
  (command "clayer" "31 Drawing")
  (HH1 p15 dk); bolt 1
  (HH1 p16 dk); bolt 2
  (if ( = n 3)
  (HH1 p17 dk)); bolt 3
  (if ( = n 4)
  (and(HH1 p17 dk)(HH1 p18 dk))); bolt 4
  (if ( = n 5)
  (and (HH1 p17 dk)(HH1 p18 dk)(HH1 p19 dk))); bolt 5
  (setvar "osmode" occho);;
  (setq p6a (polar p3 (/ pi 2) (- (/ w 2) 17.5)))
  (setq o1(nentselp p3))
  (command "break" o1 "F" p6 p6); diem cat
  (setq o3(nentselp p3))
  (command "break" o3 "F" p6a p6a); diem cat
  (setq o2(nentselp p3))
  (command "_.change" o2 "" "P" "LA" "HIDDEN" "");thay doi layer
  (princ));;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;LISP VE COT DAM THAY BUNG
;;;THANH TRI AUTOCAD REVIT
(defun c:ST(/ GOC PT1 PT2 PT3 PT4 PT5 PT6 PT7 PT8 PT9 PT10 tf tw h)
  (setvar "CMDECHO" 0)
  (setq osm (getvar "osmode"))
  (if (null ST) (setq ST 150))
        (setq h (getreal (strcat "\nKich Thuoc ST. <" (rtos ST 2 0) ">: ")))
        (if (null h) (setq h ST) (setq ST h))
  (setq tf 4
	PT1(getpoint "\nFisrt point.")
	PT2(getpoint PT1"\nSecond point.")
	GOC(angle PT1 PT2)
	PT3(polar PT1 (+ GOC (/ pi 2)) (/(- h 8) 2))
	PT5(polar PT1 (+ GOC (/ pi -2)) (/(- h 8) 2))
	PT4(polar PT2 (+ GOC (/ pi 2)) (/(- h 8) 2))
	PT6(polar PT2 (+ GOC (/ pi -2)) (/(- h 8) 2))
	PT7(polar PT1 (+ GOC (/ pi 2)) (/ h 2))
	PT8(polar PT2 (+ GOC (/ pi -2)) (/ h 2))
	PT9(polar PT2 (+ GOC (/ pi 2)) (/ h 2))
	PT10(polar PT1 (+ GOC (/ pi -2)) (/ h 2)))
  (setvar "osmode" 16384)
  (command "clayer" "33 Flange steel")
  (command "PLINE" PT7 PT9 PT8 PT10 "C")
  (command "clayer" "HIDDEN")
  (command "LINE" PT3 PT4"")
  (command "LINE" PT5 PT6"")
  (command "clayer" "31 Drawing")
  (setvar "osmode" osm)
  (princ)
  );THE END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;