;;;break line
;;THANH TRI
(defun c:r1()
(while
  (null(setq o1(entsel"\nChon doi tuong")))
  (princ "\nYou missed."))
  (setq p1(getpoint "\nChon diem cat"))  
  (command "break" o1 "F" p1 p1));;END FUNTION
;;;========== LISP VE DUONG TRON CO DUONG TAM==========;;;
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

;;;========== LISP THAY DOI LAYER==========;;;
(defun c:mc6(/ p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11)
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
 ; (setq a (* dk 2))
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
 ; (if ( = n 2)
  (HH1 p15 dk); bolt 1
  (HH1 p16 dk); bolt 2
  (if ( = n 3)
  (HH1 p17 dk)); bolt 3
  (if ( = n 4)
  (and(HH1 p17 dk)(HH1 p18 dk))); bolt 4
  (if ( = n 5)
  (and (HH1 p17 dk)(HH1 p18 dk)(HH1 p19 dk))); bolt 5
  (setvar "osmode" occho);;
;;cat lay net khuat
(setq p6a (polar p3 (/ pi 2) (- (/ w 2) 17.5)))
(setq o1(nentselp p3))
  (command "break" o1 "F" p6 p6); diem cat
  (setq o3(nentselp p3))
       (command "break" o3 "F" p6a p6a); diem cat
  (setq o2(nentselp p3))
  (command "_.change" o2 "" "P" "LA" "HIDDEN" "");thay doi layer
        (princ));;;;
;lisp layon gan layer hien hanh la net 31
;THANH TRI AUTOCAD REVIT
(defun c:T5()
  (command "layon")
  (command "clayer" "31 Drawing");SET LAYER 31
  (princ)
);END FUNTION
;;;;;;;;========== LISP SET LAYER 31==========;;;
(defun c:31 ()
  (setvar "CLAYER" "31 Drawing"))
;;;;;;;;========== LISP TAG LIEN KET==========;;;
(defun c:TAG()
  (setq occho1(getvar "dimscale"))
  (setvar "MLEADERSCALE" occho1)
  (setq p1(getpoint "First point"))
  (setvar "ORTHOMODE" 0)
  (setq p2(getpoint p1"Second point"))
  (setvar "ORTHOMODE" 1)
  (command "mleader" p2 p1));;;;;

;;lisp chon text leader dimension;;;
(defun c:fdlt () (sssetfirst nil (ssget (list (cons 0 "text,mtext,dimension,leader")))))
;;;========== LISP VE DUONG TRON CO DUONG TAM==========;;;
(defun c:HH (/ dk kw p p1 p2 p3 p4 )
	(setvar "CMDECHO" 0)
        (setq osm (getvar "osmode"))
	(if (null dko) (setq dko 20))
        (setq dk (getreal (strcat "\nDiameter <" (rtos dko 2 0) ">: ")))
        (if (null dk) (setq dk dko) (setq dko dk))
	     	(setq p (getpoint " Chon diem : " ))
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

;;;========== LISP THAY DOI LAYER==========;;;
(defun C:e1(/ x x1 x2 x3 sset)  
(setq x       '((11 "11 Text-content")
		(12"12 Text-title") 
		(13"13 Text-name & frame drawing") 
		(14"14 Text in notation") 
		(21 "21 Dim")          
		(22 "22 Hatch")        
		(23 "23 Tole Hatch")   
		(24 "24 Skylight Hatch") 
		(25 "25TEXT")           
		(31 "31 Drawing")       
		(32 "32 Gridline")      
		(33 "33 Flange steel")  
		(34 "34 Border (bold wide)_Bracing_Flashing") 
		(35 "35 Border (light wide)") 
		(36 "36 Tole")          
		(37 "37 Purlin")
		(38 "38 Solid rod")
		(39 "39 Light wide") 
		(1 "HIDDEN")
		(41 "41 Steel section")
		(42 "42 Steel plate")
		(43 "43 Bolt")))     
(setq x1 (getreal "\nNhap layer"))
(setq x2(assoc x1 x))
(setq x3(car (cdr x2)))
(setq sset (ssget))
(if (null sset)
(progn
(princ "\nERROR: Nothing selected.")
(exit)))
(command "_.change" sset "" "P" "LA" x3"")
(command "setbylayer" sset "" "y" "")
(princ))

;;;========== LISP CLOSE BLOCK NHANH==========;;;
(defun c:bc1()
  (command "bsave")
  (command "bclose"))

;;;========== LISP VE DAM MAY==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:REV (/ b p1 p2 a f1)
  (setvar "CMDECHO" 0)
  (command "layer" "m" "TT-REV" "C" "T" "200,4,4" "" "")
  (command "layer" "m" "31 Drawing" "C" "7" "" "")
  (setq b (getvar "dimscale"))
  (setvar "orthomode" 0)
  (setq p1 (getpoint "FIRST CORNER")
	p2 (getcorner p1"SECOND CORNER"))
  (command "rectang" p1 p2)
  (setq a (entlast))
  (command "clayer" "TT-REV")
  (command ".revcloud" "a" ( * b 3)  ( * b 3) "s" "c" "o" a "" )
  (setq f1 (entlast))
  (setvar "orthomode" 1)
  (command "clayer" "31 Drawing")
  (princ))

;;;========== LISP TAG ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:TG (/ occho ocho1 htext p1 p2 string string1 o2 a1 t1 t10 t11 t12 t13 d10 a2 a3 a4 a5 o4 b1 t2 t20 t21 t22 t23 d20 b2 b3 b4 b5 goc23 p5 p51 p6 p61)
  (setq occho (getvar "osmode"))
  (setq occho1(getvar "dimscale"))
  (setq htext (* occho1 2.2))
  (setq p1 (getpoint "First point"))
  (setvar "ORTHOMODE" 0)
  (setq p2 (getpoint p1 "Second point"))
  (setvar "ORTHOMODE" 1)
  (setq string (getstring "Above Text" T));text phia tren leader
  (setq string1 (getstring "Bottom Text" T));text phia duoi leader
  (command "-text" p2 htext 0 string)
  (setq o2 (entlast))
  (setq a1 (entget o2))
  (setq t1 (textbox a1));do dai textbox tren
  (setq t10 (car t1))
  (setq t11 (nth 0 t10));lay toa do x 1
  (setq t12 (cadr t1))
  (setq t13 (nth 0 t12));lay toa do x cua diem 2
  (setq d10 (abs(- t13 t11))); do dai text tren	
  (setq a2 (assoc 10 a1))
  (setq a3 (cdr a2));toa do text
  (setq a4 (assoc 40 a1))
  (setq a5 (cdr a4));co chu text
  (command "-text"  "J" "TL" p2 htext 0 string1)
  (setq o4 (entlast))
  (setq b1 (entget o4))
  (setq t2 (textbox b1));do dai textbox duoi
  (setq t20 (car t2))
  (setq t21 (nth 0 t20));lay toa do x 1
  (setq t22 (cadr t2))
  (setq t23 (nth 0 t22));lay toa do x cua diem 2
  (setq d20 (abs(- t23 t21))); do dai text duoi  
  (setq b2 (assoc 10 b1))
  (setq b3 (cdr b2));toa do text
  (setq b4 (assoc 40 b1))
  (setq b5 (cdr b4));co chu text
  (if (> d20 d10) (setq L1 d20)(setq L1 d10))
  (setq i1 (car p1))
  (setq i2 (car p2))
  (if (> i2 i1) (setq p3 (polar p2 0 L1))(setq p3 (polar p2 pi L1)))
  (setvar "osmode" 16384)
  (command "clayer" "21 Dim")
  (command "leader" p1 p2 p3"" "" "N")
  (command "clayer" "31 Drawing")
  (setq goc23 (angle p2 p3))  
  (setq p5 (polar p2 (/ pi 2) (* 0.25 a5)))  
  (setq p51 (polar p3 (/ pi 2) (* 0.25 a5)))  
  (if (< goc23 (/ pi 2))(command "move" o2 "" a3 p5)(command "move" o2 "" a3 p51))
  (if (equal string1 "")(progn(setvar "osmode" occho)(exit)));khong co text duoi
  (setq p6 (polar p2 (/ pi -2) (* 1.25 a5)))
  (setq p61 (polar p3 (/ pi -2) (* 1.25 a5)))
  (if (< goc23 (/ pi 2))(command "move" o4 "" b3 p6)(command "move" o4 "" b3 p61))  
  (setvar "osmode" occho)
  (princ))

;;;========== LISP ALIGN TEXT ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:ALT (/ ocho e0 e e1 e2 e5 e6 e7 e3 b a1 a11 a2 a22 g)
(setq occho (getvar "osmode"))
(setq e0 (entsel "Select Text")
      e (car e0)
      e1 (entget e)
      e2 (assoc 10 e1)
      e5 (assoc 40 e1)
      e6 (cdr e5)
      e7 (* e6 0.25)
      e3 (cdr e2)
      b (vlax-ename->vla-object e))
(setq a1 (getpoint "First point")      
      a11 (cadr a1)
      a2 (getpoint "Second point")
      a22 (cadr a2))
(if (< a11 a22)(setq a3 (angle a1 a2)) (setq a3(angle a2 a1)))
(if (> a3 (/ pi 2)) (setq a3 (+ a3 pi)))
(vlax-put-property b 'Rotation a3)
(setq g  (polar a1 (+ (/ pi 2) a3) e7))
(setvar "osmode" 16384)
;(Initget "M C")
;(setq kw (getkword "\n (Move/Copy) : "))
;(COND
	   (command "move" e0 "" e3 g)
            ;((= kw "C")(command "copy" e0 "" e3 g)))
(setvar "osmode" occho)
(princ))

;;;========== LISP EDIT BLOCK NHANH ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:bee()
(command ".bedit" )
(princ))

;;;========== LISP VE BULONG ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:tri (/ occho p1 p2 x1 x2 a b c p5 p6 p7 p8 p3 p4 d)
  (setvar "cmdecho" 0)
  (setq occho (getvar "osmode"))
  (setq p1 (getpoint "\nFirst point:"))
  (setq p2 (getpoint p1"\nSecond point:"))
  (setq x1 (distance p1 p2))
  (setq x2 (* 0.25 x1))
  (setq a (angle p1 p2))
  (initget 1)
  (setq b(getreal "\nDiameter:"))
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

;;;========== LISP MA TEXT ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:d1 (/ o1 o11 o111 ct1 typ ss1 ssl1 a o2 o222 ct2 newo1 a)
  (while
    (null(setq o1(car(entsel"\nSelect Text 1:"))))
    (alert "\nChon text chua duoc. Vui long chon lai text.")); vong lap neu chon doi tuong khong trung
  (setq o11(redraw o1 3))
  (setq o111 (entget o1))
  (setq ct1 (assoc 1 o111))
  (Setq typ (cons 0 "DIMENSION,TEXT,MTEXT"))
  (setq ss1 (ssget (list typ)))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (WHILE (< a ssl1)
  (setq o2 (ssname ss1 a))
  (setq o222 (entget o2))
  (setq ct2 (assoc 1 o222))
  (setq newo1(subst ct1 ct2 o222))
  (entmod newo1)
  (setq a (+ 1 a)))
  ;(command "regen")
  (princ))

;;;========== LISP SECTION TONG HOP ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:Q (/ p1 p2 a b a1 p3 c p4 p5 f p6 p7 p8 occho pt1 pt2 a g pt8 pt9 x pt3 pt6 b x1 x2 pt4 pt5)  
  (Initget 1 "1 2")
  (setq kw (getkword "Choose number: <1. Breakline/ 2. Pipe> "))
  (COND 
	    ((= kw "2")
  (setq occho (getvar "osmode"))
  (setq p1 (getpoint "\nFirst point:"))
  (setq p2 (getpoint p1"\nSecond point:"))
  (setvar "osmode" 16384)
  (setq a (distance p1 p2))
  (setq b (angle p1 p2))
  (setq a1 (/ a 2))
  (setq p3 (polar p1  b a1))
  (setq c ( / a 4))
  (setq p4 (polar p1  b c))
  (setq p5 (polar p3  b c))
  (setq f (/ c 1.4))
  (setq p6 (polar p4 (+ (/ pi -2) b) f))
  (setq p7 (polar p5 (+ (/ pi 2) b) f))
  (setq p8 (polar p4 (+ (/ pi 2) b) f))
  (command "clayer" "21 Dim")
  (command "spline" p2 p7 p3 p6 p1 p8 p3  "" "" "")
  (setvar "osmode" occho)
  (command "clayer" "31 Drawing"))
  ((= KW "1")
  (setq occho (getvar "osmode"))
  (setq pt1(getpoint"First point"))
  (setq pt2(getpoint pt1"Second point"))
  (setq a(distance pt1 pt2))
  (setq g(angle pt1 pt2))
  (setq pt8(polar pt1 ( + g pi) ( / a 10)))
  (setq pt9(polar pt2  g ( / a 10)))
  (setq x(polar pt1 g ( / a 2)))
  (setq pt3(polar x ( + g pi) ( / a 20)))
  (setq pt6(polar x g ( / a 20)))
  (setq b(distance x pt3))
  (setq x1 (polar x ( + pi g) ( / b 2)))
  (setq x2 (polar x g ( / b 2)))
  (setq pt4 (polar x1 ( + g ( / pi -2 )) ( / a 12 )))
  (setq pt5 (polar x2 ( + g ( / pi 2 )) ( / a 12 )))
  (setvar "osmode" 16384)
  (command "clayer" "21 Dim")
  (command "pline" pt8 pt3 pt4 pt5 pt6 pt9"")
  (command "clayer" "31 Drawing")
  (setvar "osmode" occho)
  (princ))))


;;;========== LISP DIM CURENT ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:AS()
  (command "-dimstyle" "" "" pause )
  (princ)
  )

;;;========== LISP SHOW ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:SHOW()
(setq blk (car(entsel)))
(dumpallproperties blk))

;;;========== LISP VE SECTION I ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:VI (/ l1 l2 t1 t2 pp1 pp2 pp3 pp4 pp5 pp6 pp7 pp8 pp9 pp10 pp11 pp12)
 (prompt "\nWELCOME TO ATAD")
 (setq osm (getvar "osmode"))
 (setq l1 (getint "\nChieu cao bung: ")
       l2 (getint "\nChieu rong canh: ")
       t1 (getint "\nChieu day bung: ")
       t2 (getint "\nChieu day canh: "))
(setq pp1 (getpoint "\nChon diem dat: ")
      pp2 (polar pp1 0 l2)
      pp3 (polar pp2 (/ pi 2) t2)
      pp4 (polar pp3 pi (* (- l2 t1) 0.5))
      pp5 (polar pp4 (/ pi 2) l1)
      pp6 (polar pp5 0 (- (* l2 0.5) (* t1 0.5)))
      pp7 (polar pp6 (/ pi 2) t2)
      pp8 (polar pp7 pi l2)
      pp9 (polar pp8 (/ pi -2) t2)
      pp10 (polar pp5 pi t1)
      pp11 (polar pp4 pi t1)
      pp12 (polar pp1 (/ pi 2) t2)
 )
 (setvar "osmode" 0)    
 (command "pline" pp1 pp2 pp3 pp4 pp5 pp6 pp7 pp8 pp9 pp10 pp11 pp12 "c")
 (setvar "osmode" osm)  
 (princ))

;;;========== LISP TAG BLOCK FIELD ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:TG2 (/ occho occho1 htext p1 p2 src oSrc string o2 a1 t1 t10 t11 t12 t13 d10 a2 a3 a4 a5 L1 i1 i2 goc23 p5 p51)
  (setq occho (getvar "osmode"))
  (setq occho1(getvar "dimscale"))
  (setq htext (* occho1 2.2))
  (setq p1 (getpoint "First point"))
  (setvar "ORTHOMODE" 0)
  (setq p2 (getpoint p1 "Second point"))
  (setvar "ORTHOMODE" 1);;;;;;
  (vl-load-com)
  (setq src (nentsel "Source Attribute: "))
  (setq oSrc (vlax-ename->vla-object (car src)))
  (setq string (strcat "%<\\AcObjProp Object(%<\\_ObjId "(itoa (vla-get-ObjectId oSrc))">%,1).TextString>%"))
  (command "-text" p2 htext 0 string)
  (setq o2 (entlast))
  (setq a1 (entget o2))
  (setq t1 (textbox a1));do dai textbox tren
  (setq t10 (car t1))
  (setq t11 (nth 0 t10));lay toa do x 1
  (setq t12 (cadr t1))
  (setq t13 (nth 0 t12));lay toa do x cua diem 2
  (setq d10 (abs(- t13 t11))); do dai text tren	
  (setq a2 (assoc 10 a1))
  (setq a3 (cdr a2));toa do text
  (setq a4 (assoc 40 a1))
  (setq a5 (cdr a4));co chu text
  (setq L1 d10)
  (setq i1 (car p1))
  (setq i2 (car p2))
  (if (> i2 i1) (setq p3 (polar p2 0 L1))(setq p3 (polar p2 pi L1)))
  (setvar "osmode" 16384)
  (command "clayer" "21 Dim")
  (command "leader" p1 p2 p3"" "" "N")
  (command "clayer" "31 Drawing")
  (setq goc23 (angle p2 p3))  
  (setq p5 (polar p2 (/ pi 2) (* 0.25 a5)))  
  (setq p51 (polar p3 (/ pi 2) (* 0.25 a5)))  
  (if (< goc23 (/ pi 2))(command "move" o2 "" a3 p5)(command "move" o2 "" a3 p51))
  (setvar "osmode" occho)
  (princ))

;;;========== LISP TAG BLOCK symbol and section ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:TG1 (/ occho occho1 htext p1 p2 blk string o2 a1 t1 t10 t11 t12 t13 d10 a2 a3 a4 a5 L1 i1 i2 goc23 p5 p51)
  (setq occho (getvar "osmode"))
  (setq occho1(getvar "dimscale"))
  (setq htext (* occho1 2.2))
  (setq p1 (getpoint "First point"))
  (setvar "ORTHOMODE" 0)
  (setq p2 (getpoint p1 "Second point"))
  (setvar "ORTHOMODE" 1);;;;;;
  (setq blk (car(entsel)))
  (setq string (getpropertyvalue blk "SYMBOL"))
  (command "-text" p2 htext 0 string)
  (setq o2 (entlast))
  (setq a1 (entget o2))
  (setq t1 (textbox a1));do dai textbox tren
  (setq t10 (car t1))
  (setq t11 (nth 0 t10));lay toa do x 1
  (setq t12 (cadr t1))
  (setq t13 (nth 0 t12));lay toa do x cua diem 2
  (setq d10 (abs(- t13 t11))); do dai text tren	
  (setq a2 (assoc 10 a1))
  (setq a3 (cdr a2));toa do text
  (setq a4 (assoc 40 a1))
  (setq a5 (cdr a4));co chu text
  (setq L1 d10 )
  (setq i1 (car p1))
  (setq i2 (car p2))
  (if (> i2 i1) (setq p3 (polar p2 0 L1))(setq p3 (polar p2 pi L1)))
  (setvar "osmode" 16384)
  (command "clayer" "21 Dim")
  (command "leader" p1 p2 p3"" "" "N")
  (command "clayer" "31 Drawing")
  (setq goc23 (angle p2 p3))  
  (setq p5 (polar p2 (/ pi 2) (* 0.25 a5)))  
  (setq p51 (polar p3 (/ pi 2) (* 0.25 a5)))  
  (if (< goc23 (/ pi 2))(command "move" o2 "" a3 p5)(command "move" o2 "" a3 p51))
  (setvar "osmode" occho)
  (princ))

;;;========== LISP Q TRUC ==========;;;
;;; AUTHOR: THANH TRI;;;



;;;========== LISP VE V KEO ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:VKN (/ occho pt11 pt5 x1 x2 y1 y2)
  (setvar "cmdecho" 0)
  (setq occho (getvar "osmode"))
  (setq pt11 (getpoint "First point:"))
  (setvar "ORTHOMODE" 0)
  (setq pt5 (getpoint pt11 "Second point:"))
  (setvar "ORTHOMODE" 1)
  (setq x1 (car pt11))
  (setq x2 (car pt5))
  (setq y1 (cadr pt11))
  (setq y2 (cadr pt5))
  (if (and (< x1 x2)(< y1 y2))(progn
  		(setq pt4 (polar pt5 (/ pi -2) 40))
  		(setq pt1 (polar pt11 (/ pi 2) 40))
  		(setq pt2 (polar pt1 0 150))
  		(setq pt3 (polar pt4 pi 150))))
  (if (and (> x1 x2)(> y1 y2))(progn
  		(setq pt4 (polar pt5 (/ pi 2) 40))
  		(setq pt1 (polar pt11 (/ pi -2) 40))
  		(setq pt2 (polar pt1 pi 150))
  		(setq pt3 (polar pt4 0 150))))
  (if (and (< x1 x2)(> y1 y2))(progn
  		(setq pt4 (polar pt5 (/ pi 2) 40))
  		(setq pt1 (polar pt11 (/ pi -2) 40))
  		(setq pt2 (polar pt1 0 150))
  		(setq pt3 (polar pt4 pi 150))))
  (if (and (> x1 x2)(< y1 y2))(progn
  		(setq pt4 (polar pt5 (/ pi -2) 40))
  		(setq pt1 (polar pt11 (/ pi 2) 40))
  		(setq pt2 (polar pt1 pi 150))
  		(setq pt3 (polar pt4 0 150))))    
  (setvar "osmode" 16384)
  (command "clayer" "36 Tole")
  (command "pline" pt1 pt2 pt3 pt4 "")
  (command "clayer" "31 Drawing")
  (setvar "osmode" occho)
  (princ))
;;;;;;=============================================;;;;
(defun c:VKD (/ occho pt11 pt5 x1 x2 y1 y2)
  (setvar "cmdecho" 0)
  (setq occho (getvar "osmode"))
  (setq pt11 (getpoint "First point:"))
  (setvar "ORTHOMODE" 0)
  (setq pt5 (getpoint pt11 "Second point:"))
  (setvar "ORTHOMODE" 1)
  (setq x1 (car pt11))
  (setq x2 (car pt5))
  (setq y1 (cadr pt11))
  (setq y2 (cadr pt5))
  (if (and (< x1 x2)(< y1 y2))(progn
  		(setq pt4 (polar pt5 pi 40))
  		(setq pt1 (polar pt11 0 40))
  		(setq pt2 (polar pt1 (/ pi 2) 150))
  		(setq pt3 (polar pt4 (/ pi -2) 150))))
  (if (and (> x1 x2)(> y1 y2))(progn
  		(setq pt4 (polar pt5 0 40))
  		(setq pt1 (polar pt11 pi 40))
  		(setq pt2 (polar pt1 (/ pi -2) 150))
  		(setq pt3 (polar pt4 (/ pi 2) 150))))
  (if (and (< x1 x2)(> y1 y2))(progn
  		(setq pt4 (polar pt5 pi 40))
  		(setq pt1 (polar pt11 0 40))
  		(setq pt2 (polar pt1 (/ pi -2) 150))
  		(setq pt3 (polar pt4 (/ pi 2) 150))))
  (if (and (> x1 x2)(< y1 y2))(progn
  		(setq pt4 (polar pt5 0 40))
  		(setq pt1 (polar pt11 pi 40))
  		(setq pt2 (polar pt1 (/ pi 2) 150))
  		(setq pt3 (polar pt4 (/ pi -2) 150))))    
  (setvar "osmode" 16384)
  (command "clayer" "36 Tole")
  (command "pline" pt1 pt2 pt3 pt4 "")
  (command "clayer" "31 Drawing")
  (setvar "osmode" occho)
  (princ))


;;;========== LISP VE BAN MA ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:BM (/ occho p1 p2 a b kw b1 p3 p4 p5 p6 d f)
  (setq occho (getvar "osmode"))
  (setq p1 (getpoint "\nFirst point:"))
  (setq p2 (getpoint p1"\nSecond point:"))  
  (setq a (angle p1 p2))
  (setq b(getreal "\nThickness:"))
  ;(Initget "16 20 24 30 36")
  ;(setq kw (getkword "DIAMETER BOLT <16, 20, 24, 30, 36>: "))
  ;(setq b1 (distof kw))
 ; (cond
   ; ((= b1 16)(setq b2 70))
   ; ((= b1 20)(setq b2 80))
   ; ((= b1 24)(setq b2 100))
   ; ((= b1 30)(setq b2 120))
   ; ((= b1 36)(setq b2 120)))
  (setq b2 100)
  (setq p3 (polar p1 (+ pi a) b2))
  (setq p4 (polar p2 (+ pi a) (* -1 b2)))
  (setq p5 (polar p4 (+ (/ pi 2) a) b))
  (setq p6 (polar p3 (+ (/ pi 2) a) b))
  (setvar "osmode" 16384)
  (command "clayer" "41 Steel section")
  (command ".pline" p3 p4 p5 p6 "c""")
  (setq d(entlast))
  (command "wipeout" "p" d "y")
  (setq f(entlast))
  (command "mirror" f "" p1 p2 "n")
  (setvar "osmode" occho)
  (command "clayer" "31 Drawing")
  (princ))
;;;================================================
(defun c:BMK (/ occho p1 p2 a b p3 p4 p5 p6 d f)
  (setq occho (getvar "osmode"))
  (setq p1 (getpoint "First point:"))
  (setq p2 (getpoint p1"Second point:"))  
  (setq a (angle p1 p2))
  (setq b(getreal "Thickness:"))
  (setq p3 (polar p1 (+ pi a) 10))
  (setq p4 (polar p2 (+ pi a) (* -1 10)))
  (setq p5 (polar p4 (+ (/ pi 2) a) b))
  (setq p6 (polar p3 (+ (/ pi 2) a) b))
  (setvar "osmode" 16384)
  (command "clayer" "42 Steel plate")
  (command ".pline" p3 p4 p5 p6 "c""")
  (setq d(entlast))
  ;(command "wipeout" "p" d "n")
  ;(setq f(entlast))
  (command "mirror"  d"" p1 p2 "n")
  (setvar "osmode" occho)
  (command "clayer" "31 Drawing")
  (princ))

;;;========== LISP TAO DIM ATAD ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun c:DS ()
(setq tlc (cond (tlc) ("1")))
	(initget 1)
	(setq tlc (cond ((getstring (strcat "Drawing Scale: <"tlc">"))) (tlc)))
(setvar "textstyle" "VNI")
(setvar "textsize" 1.46)
(setq sc (strcat "ATAD1-" tlc))
(setq tls (distof tlc))
(command "-dimstyle" "" "ATAD1-1")
(setvar "dimscale" tls)
(if	(tblsearch "dimstyle" sc)
	(command "-dimstyle" "s" sc "y") 	;=;
	;(command "-dimstyle" "" SC)  		;=;
	(command "-dimstyle" "s" sc))
(setq a (getvar "dimtxt"))
(setq b (getvar "dimtxsty"))
(setq c (getvar "dimscale")) 
(setvar "textsize" (* a c))
(setvar "textstyle" b)
;(setvar "ltscale" (* 5 c ))
(princ))

;;;========== LISP CHINH DIM BANG NHAU ==========;;;
;;; AUTHOR: THANH TRI;;;
;;;----------------------------------------------------------------------------
(defun myerror (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
  (cond
    ((= s "quit / exit abort") (princ))
    ((/= s "Function cancelled") (princ (strcat "\nError: " s)))
  )
  (setvar "cmdecho" CMD)             ; Restore saved modes
  (setvar "osmode" OSM)
  (setq *error* OLDERR)               ; Restore old *error* handler
  (princ))
;;;----
(DEFUN C:CD (/ CMD SS LTH DEM PT DS KDL N70 GOCX GOCY PT13 PT14 PTI PT13I PT14I
                PT13N PT14N O13 O14 N13 N14 OSM OLDERR PT10 PT11)
(SETQ CMD (GETVAR "CMDECHO"))
(SETQ OSM (GETVAR "OSMODE"))
(SETQ OLDERR *error*
      *error* myerror)
(PRINC "Please select dimension object!")
(SETQ SS (SSGET))
(SETVAR "CMDECHO" 0)
(SETQ PT (GETPOINT "Point to trim or extend:"))
(SETQ PT (TRANS PT 1 0))
(COMMAND "UCS" "W")
(SETQ LTH (SSLENGTH SS))
(SETQ DEM 0)
(WHILE (< DEM LTH)
    (PROGN
	(SETQ DS (ENTGET (SSNAME SS DEM)))
	(SETQ KDL (CDR (ASSOC 0 DS)))
	(IF (= "DIMENSION" KDL)
	   (PROGN
		(SETQ PT10 (CDR (ASSOC 10 DS)))
		(SETQ PT11 (CDR (ASSOC 11 DS)))
		(SETQ PT13 (CDR (ASSOC 13 DS)))
		(SETQ PT14 (CDR (ASSOC 14 DS)))
		(SETQ N70 (CDR (ASSOC 70 DS)))
		(IF (OR (= N70 0) (= N70 32) (= N70 33) (= N70 160) (= N70 161))
		   (PROGN
			(SETQ GOCY (ANGLE PT10 PT14))
			(SETQ GOCX (+ GOCY (/ PI 2)))
		   )
		)
		(SETVAR "OSMODE" 0)
		(SETQ PTI (POLAR PT GOCX 2))
		(SETQ PT13I (POLAR PT13 GOCY 2))
		(SETQ PT14I (POLAR PT14 GOCY 2))
		(SETQ PT13N (INTERS PT PTI PT13 PT13I NIL))
		(SETQ PT14N (INTERS PT PTI PT14 PT14I NIL))
		(SETQ O13 (ASSOC 13 DS))
		(SETQ O14 (ASSOC 14 DS))
		(SETQ N13 (CONS 13 PT13N))
		(SETQ N14 (CONS 14 PT14N))
		(SETQ DS (SUBST N13 O13 DS))
		(SETQ DS (SUBST N14 O14 DS))
		(ENTMOD DS)
	   )
	)
	(SETQ DEM (+ DEM 1))
    )
)
(COMMAND "UCS" "P")
(SETVAR "CMDECHO" CMD)
(SETVAR "OSMODE" OSM)
(setq *error* OLDERR)               ; Restore old *error* handler
(PRINC))
;;;----
(DEFUN C:BD (/ CMD SS LTH DEM PT DS KDL N70 GOCX GOCY PT13 PT14 PTI
                PT10 PT10I PT10N O10 N10 PT11 PT11N O11 N11 KC OSM OLDERR)
(SETQ CMD (GETVAR "CMDECHO"))
(SETQ OSM (GETVAR "OSMODE"))
(SETQ OLDERR *error*
      *error* myerror)
(PRINC "Please select dimension object!")
(SETQ SS (SSGET))
(SETVAR "CMDECHO" 0)
(SETQ PT (GETPOINT "Point to trim or extend:"))
(SETQ PT (TRANS PT 1 0))
(COMMAND "UCS" "W")
(SETQ LTH (SSLENGTH SS))
(SETQ DEM 0)
(WHILE (< DEM LTH)
    (PROGN
	(SETQ DS (ENTGET (SSNAME SS DEM)))
	(SETQ KDL (CDR (ASSOC 0 DS)))
	(IF (= "DIMENSION" KDL)
	   (PROGN
		(SETQ PT13 (CDR (ASSOC 13 DS)))
		(SETQ PT14 (CDR (ASSOC 14 DS)))
		(SETQ PT10 (CDR (ASSOC 10 DS)))
		(SETQ PT11 (CDR (ASSOC 11 DS)))
		(SETQ N70 (CDR (ASSOC 70 DS)))
		(IF (OR (= N70 0) (= N70 32) (= N70 33) (= N70 160) (= N70 161))
		   (PROGN
			(SETQ GOCY (ANGLE PT10 PT14))
			(SETQ GOCX (+ GOCY (/ PI 2)))
		   )
		)
		(SETVAR "OSMODE" 0)
		(SETQ PTI (POLAR PT GOCX 2))
		(SETQ PT10I (POLAR PT10 GOCY 2))
		(SETQ PT10N (INTERS PT PTI PT10 PT10I NIL))
		(SETQ KC (DISTANCE PT10 PT10N))
		(SETQ O10 (ASSOC 10 DS))
		(SETQ N10 (CONS 10 PT10N))
		(SETQ DS (SUBST N10 O10 DS))
		(SETQ PT11N (POLAR PT11 (ANGLE PT10 PT10N) KC))
		(SETQ O11 (ASSOC 11 DS))
		(SETQ N11 (CONS 11 PT11N))
		(SETQ DS (SUBST N11 O11 DS))
		(ENTMOD DS)
	   )
	)
	(SETQ DEM (+ DEM 1))
    )
)
(COMMAND "UCS" "P")
(SETVAR "CMDECHO" CMD)
(SETVAR "OSMODE" OSM)
(setq *error* OLDERR)
(PRINC))

 ;;;========== LISP DANH SO ATT ==========;;;
;;; AUTHOR: THANH TRI;;;
;;;----------------------------------------------------------------------------
 
(defun c:NH (/ ans ins lst blkName tagName ent)
  ;Block Order
  ;;  By : Gia_Bach, www.CadViet.com      ;;
  (vl-load-com)
  (while (not (and
		(setq ent (car (nentsel "\n SELECT ATT TO COUNT: ")))
		(if ent (eq (cdr (assoc 0 (entget ent))) "ATTRIB") ) ) )
    (princ "\n Ban chon nham roi! ")    )
  (setq blkName (cdr (assoc 2 (entget (cdr (assoc 330 (entget ent))))))
	tagName (cdr (assoc 2 (entget ent)))	)
  
  (initget 1 "Yes No")
  (setq x (getkword "\nBan co muon nhap Tien to ? (Yes or No) "))
  (if (= x "Yes")
    (progn
      (or prefix (setq  prefix "S-"))
      (setq ans (getstring t (strcat "\n Nhap tien to <<"prefix ">> :")))
      (if (/= ans "")(setq prefix ans)) )
    (setq prefix ""))

  (or stt (setq stt 1))
  (initget 6)
  (setq ans (getint (strcat "\n Nhap so bat dau <<"(itoa stt) ">> :")))
  (if ans (setq stt ans))
  ;(if (> stt 9)
    (setq str (strcat prefix (itoa stt)))
   ; (setq str (strcat prefix  "0" (itoa stt))) )    
	
  (princ "\nChon Khung ten can danh so thu tu :")
  (if (ssget(list (cons 0 "INSERT")(cons 66 1)(cons 2 blkName)))
    (progn
      (vlax-for e (vla-get-ActiveSelectionSet (vla-get-ActiveDocument (vlax-get-Acad-Object)))
	(setq ins (vlax-safearray->list (variant-value (vla-get-InsertionPoint e)))
	      lst (cons (list e ins)lst))	)
      (setq lst (vl-sort lst '(lambda (x y) ;(or	(> (cadr (cadr x)) (cadr (cadr y)))
						;(and 
						  (< (car (cadr x)) (car (cadr y))))))
						     ;(= (cadr (cadr x)) (cadr (cadr y))) ) ) ) ))
      (foreach e (append (mapcar 'car lst) )
	(foreach Att (vlax-invoke e 'GetAttributes)
	  (if (= (vla-get-TagString att) tagName)
	    (vla-put-TextString att str) ))
	(setq stt (+ 1 stt))
	;(if (> stt 9)
	  (setq str (strcat prefix (itoa stt))))))
	  ;(setq str (strcat prefix  "0" (itoa stt))) )	)  ) )
  (princ))
;===============================================================
(defun c:NH1 (/ ans ins lst blkName tagName ent)
  ;Block Order
  ;;  By : Gia_Bach, www.CadViet.com      ;;
  (vl-load-com)
  (while (not (and
		(setq ent (car (nentsel "\n SELECT ATT TO COUNT: ")))
		(if ent (eq (cdr (assoc 0 (entget ent))) "ATTRIB") ) ) )
    (princ "\n Ban chon nham roi! ")    )
  (setq blkName (cdr (assoc 2 (entget (cdr (assoc 330 (entget ent))))))
	tagName (cdr (assoc 2 (entget ent)))	)
  
  (initget 1 "Yes No")
  (setq x (getkword "\nBan co muon nhap Tien to ? (Yes or No) "))
  (if (= x "Yes")
    (progn
      (or prefix (setq  prefix "S-"))
      (setq ans (getstring t (strcat "\n Nhap tien to <<"prefix ">> :")))
      (if (/= ans "")(setq prefix ans)) )
    (setq prefix ""))

  (or stt (setq stt 1))
  (initget 6)
  (setq ans (getint (strcat "\n Nhap so bat dau <<"(itoa stt) ">> :")))
  (if ans (setq stt ans))
  (if (> stt 9)
    (setq str (strcat prefix (itoa stt)))
   (setq str (strcat prefix  "0" (itoa stt))) )    
	
  (princ "\nChon Khung ten can danh so thu tu :")
  (if (ssget(list (cons 0 "INSERT")(cons 66 1)(cons 2 blkName)))
    (progn
      (vlax-for e (vla-get-ActiveSelectionSet (vla-get-ActiveDocument (vlax-get-Acad-Object)))
	(setq ins (vlax-safearray->list (variant-value (vla-get-InsertionPoint e)))
	      lst (cons (list e ins)lst))	)
      (setq lst (vl-sort lst '(lambda (x y) ;(or	(> (cadr (cadr x)) (cadr (cadr y)))
						;(and 
						  (< (car (cadr x)) (car (cadr y))))))
						     ;(= (cadr (cadr x)) (cadr (cadr y))) ) ) ) ))
      (foreach e (append (mapcar 'car lst) )
	(foreach Att (vlax-invoke e 'GetAttributes)
	  (if (= (vla-get-TagString att) tagName)
	    (vla-put-TextString att str) ))
	(setq stt (+ 1 stt))
	(if (> stt 9)
	  (setq str (strcat prefix (itoa stt)))
	  (setq str (strcat prefix  "0" (itoa stt))) )	)  ) )
  (princ))



;;;========== LISP VE BAN MA NGAM ==========;;;
;;; AUTHOR: THANH TRI;;;
;;;----------------------------------------------------------------------------
;; Get Dynamic Block Property Value  -  Lee Mac
;; Returns the value of a Dynamic Block property (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)

(defun LM:getdynpropvalue ( blk prp )
    (setq prp (strcase prp))
    (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'value)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;;;-------------------------------------------------------------
;; Set Dynamic Block Property Value  -  Lee Mac
;; Modifies the value of a Dynamic Block property (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)
;; val - [any] New value for property
;; Returns: [any] New value if successful, else nil

(defun LM:setdynpropvalue ( blk prp val )
    (setq prp (strcase prp))
    (vl-some
       '(lambda ( x )
            (if (= prp (strcase (vla-get-propertyname x)))
                (progn
                    (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
                    (cond (val) (t))
                )
            )
        )
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Get Dynamic Block Properties  -  Lee Mac
;; Returns an association list of Dynamic Block properties & values.
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [lst] Association list of ((<prop> . <value>) ... )

(defun LM:getdynprops ( blk )
    (mapcar '(lambda ( x ) (cons (vla-get-propertyname x) (vlax-get x 'value)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Set Dynamic Block Properties  -  Lee Mac
;; Modifies values of Dynamic Block properties using a supplied association list.
;; blk - [vla] VLA Dynamic Block Reference object
;; lst - [lst] Association list of ((<Property> . <Value>) ... )
;; Returns: nil

(defun LM:setdynprops ( blk lst / itm )
    (setq lst (mapcar '(lambda ( x ) (cons (strcase (car x)) (cdr x))) lst))
    (foreach x (vlax-invoke blk 'getdynamicblockproperties)
        (if (setq itm (assoc (strcase (vla-get-propertyname x)) lst))
            (vla-put-value x (vlax-make-variant (cdr itm) (vlax-variant-type (vla-get-value x))))
        )
    )
)
;; Get Dynamic Block Property Allowed Values  -  Lee Mac
;; Returns the allowed values for a specific Dynamic Block property.
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)
;; Returns: [lst] List of allowed values for property, else nil if no restrictions

(defun LM:getdynpropallowedvalues ( blk prp )
    (setq prp (strcase prp))
    (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'allowedvalues)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Toggle Dynamic Block Flip State  -  Lee Mac
;; Toggles the Flip parameter if present in a supplied Dynamic Block.
;; blk - [vla] VLA Dynamic Block Reference object
;; Return: [int] New Flip Parameter value

(defun LM:toggleflipstate ( blk )
    (vl-some
       '(lambda ( prp / rtn )
            (if (equal '(0 1) (vlax-get prp 'allowedvalues))
                (progn
                    (vla-put-value prp (vlax-make-variant (setq rtn (- 1 (vlax-get prp 'value))) vlax-vbinteger))
                    rtn
                )
            )
        )
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Get Visibility Parameter Name  -  Lee Mac
;; Returns the name of the Visibility Parameter of a Dynamic Block (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [str] Name of Visibility Parameter, else nil

(defun LM:getvisibilityparametername ( blk / vis )  
    (if
        (and
            (vlax-property-available-p blk 'effectivename)
            (setq blk
                (vla-item
                    (vla-get-blocks (vla-get-document blk))
                    (vla-get-effectivename blk)
                )
            )
            (= :vlax-true (vla-get-isdynamicblock blk))
            (= :vlax-true (vla-get-hasextensiondictionary blk))
            (setq vis
                (vl-some
                   '(lambda ( pair )
                        (if
                            (and
                                (= 360 (car pair))
                                (= "BLOCKVISIBILITYPARAMETER" (cdr (assoc 0 (entget (cdr pair)))))
                            )
                            (cdr pair)
                        )
                    )
                    (dictsearch
                        (vlax-vla-object->ename (vla-getextensiondictionary blk))
                        "ACAD_ENHANCEDBLOCK"
                    )
                )
            )
        )
        (cdr (assoc 301 (entget vis)))
    )
)
;; Get Dynamic Block Visibility State  -  Lee Mac
;; Returns the value of the Visibility Parameter of a Dynamic Block (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [str] Value of Visibility Parameter, else nil

(defun LM:getvisibilitystate ( blk / vis )
    (if (setq vis (LM:getvisibilityparametername blk))
        (LM:getdynpropvalue blk vis)
    )
)
;; Set Dynamic Block Visibility State  -  Lee Mac
;; Sets the Visibility Parameter of a Dynamic Block (if present) to a specific value (if allowed)
;; blk - [vla] VLA Dynamic Block Reference object
;; val - [str] Visibility State Parameter value
;; Returns: [str] New value of Visibility Parameter, else nil

(defun LM:SetVisibilityState ( blk val / vis )
    (if
        (and
            (setq vis (LM:getvisibilityparametername blk))
            (member (strcase val) (mapcar 'strcase (LM:getdynpropallowedvalues blk vis)))
        )
        (LM:setdynpropvalue blk vis val)
    )
)
;;;;;-------------------------------------
(defun c:VI1()
  (setq osm (getvar "osmode"))
 (setq l1 (getint "\nChieu cao bung: ")
       l2 (getint "\nChieu rong canh: ")
       t1 (getint "\nChieu day bung: ")
       t2 (getint "\nChieu day canh: "))
(setq pp1 (getpoint "\nChon diem dat: ")
      pp2 (polar pp1 0 l2)
      pp3 (polar pp2 (/ pi 2) t2)
      pp4 (polar pp3 pi (* (- l2 t1) 0.5))
      pp5 (polar pp4 (/ pi 2) l1)
      pp6 (polar pp5 0 (- (* l2 0.5) (* t1 0.5)))
      pp7 (polar pp6 (/ pi 2) t2)
      pp8 (polar pp7 pi l2)
      pp9 (polar pp8 (/ pi -2) t2)
      pp10 (polar pp5 pi t1)
      pp11 (polar pp4 pi t1)
      pp12 (polar pp1 (/ pi 2) t2)
      dd1 (/ (distance pp1 pp7) 2)
      goc1 (angle pp1 pp7)
      x1(polar pp1 goc1 dd1))
  ;(initget 1 "M16 M20 M24 M30")
  ;(setq n1 (getkword "DIAMETER BOLT <M16, M20, M24, M30, M36>: "))
   (setq n1(getstring "Nhap Bolt <M16, M20, M24, M30>:"))
  (setq ht (+ l1 (* t2 2)))  
   (cond
    ((= n1 "M16")
  (setq H (+ ht 200))
  (setq P 120)
  (setq G 100)
  (setq E 50))
    ((= n1 "M20")
  (setq H (+ ht 200))
  (setq P 120)
  (setq G 100)
  (setq E 50))
   ((= n1 "M24")
  (setq H (+ ht 200))
  (setq P 120)
  (setq G 120)
  (setq E 50))
      ((= n1 "M30")
  (setq H (+ ht 240))
  (setq P 130)
  (setq G 120)
  (setq E 60)))
  (setq bolt1 (atoi (substr n1 2)));;bu long so nguyen
  (setq listw (list 165 185 215 250 300 350 400))
  (setq w 165)
  (setq number 1)

  (while (< (/ (- W G) 2) (* 2 bolt1))
    (setq W (nth number listw))
    (setq number (1+ number)))
  (if (< w l2)(set 'w l2))
 
 (setvar "osmode" 0)    
 (command "pline" pp1 pp2 pp3 pp4 pp5 pp6 pp7 pp8 pp9 pp10 pp11 pp12 pp1 "")

 
  (command "-insert" "PLATE NGAM_THANH TRI" x1 1 1 0)  
  (setq blk (vlax-ename->vla-object (entlast))) 	    
  (LM:SetVisibilityState blk n1)
  (LM:setdynpropvalue  blk "W" W )
  (LM:setdynpropvalue  blk "H" H )
  (LM:setdynpropvalue  blk "E" E)
  (LM:setdynpropvalue  blk "P" P )
  (LM:setdynpropvalue  blk "G" G)
  (setvar "osmode" osm)  
  (princ))

;;;========== LISP CHINH HEIGHT TITLE TEXT ==========;;;
;;; AUTHOR: THANH TRI;;;
;;;----------------------------------------------------------------------------
(defun c:TT()
(setq b (getvar "dimscale"))
(setq blk (car(entsel)))
(setpropertyvalue blk "height" (* 3.5 b)))

;;;========== LISP CHINH HEIGHT TITLE TEXT ==========;;;
;;; AUTHOR: THANH TRI;;;
;;;----------------------------------------------------------------------------
(defun c:ExDWG ()(startapp "Explorer" (strcat "/N,/E," (getvar "DWGPREFIX"))))
(defun c:udt ()  (setvar "cmdecho" 0)  (command "_DATALINKUPDATE" "u" "k")  (setvar "cmdecho" 1)  (princ)       )


;;;========== LISP EXPLODE DIM GET TEXT ==========;;;
;;; AUTHOR: THANH TRI;;;
;;;----------------------------------------------------------------------------
(defun c:XD (/ ss sst)
(if (setq ss (ssget '((0 . "DIMENSION"))) i -1)
  (Repeat (sslength ss)
	 (if (vl-cmdf "explode" ss)
	   (Repeat (sslength (setq sst (ssget "P" (list(cons 0 "~*TEXT")))))
		   (vl-cmdf "erase" (ssname sst (setq i (1+ i))) "")
	   )
	 )
         (setq i -1)
    )
)
)
;; LISP VE MAT DUNG KEO COT;;
(defun c:f1()
  (setvar "cmdecho" 0)
  (setq occho (getvar "osmode"))
  (setq Tf (getreal "Tf"))
  (setq W (getreal "Hw"))  
  (setq p1 (getpoint "First point"))
  (setq p2 ( getpoint p1 "Second point"))
  (setq a (angle p1 p2))
  (setq p3( polar p2 (+ a (/ pi 2)) 5000))
  (setq p4 (polar p1 (+ a (/ pi 2)) (+ w (* 2 Tf))))
  (setvar "osmode" 16384)
  (command "line" p1 p2"")
  (setq o1 (entlast))
  (command "offset" Tf o1 p3 "")
  (setq o2 (entlast))
  (command "offset" W o2 p3 "")
  (setq o3 (entlast))
  (command "offset" Tf o3 p3 "")
  (command "line" p1 p4"")
  (setq o4 (entlast))
  (command "copy" o4"" p1 p2)
  (setvar "osmode" occho)
  (princ))