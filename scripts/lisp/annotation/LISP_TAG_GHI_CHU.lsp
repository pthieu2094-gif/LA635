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
