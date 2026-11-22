
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(DeFun c:KL ()
(setvar "CMDECHO" 0)
(setq txs (getvar "textstyle"))
(setvar "textstyle" "romand")
;Goi goi file.dvb
(command "-vbarun" "D:/Lam.page/KhoiLuong/KL.dvb!Module1.MDKhoiLuong")
(setvar "textstyle" txs)
(princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;Chuyen sang Model

(defun c:WW ()
  (command "tilemode" 1)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Chuyen Sang Layout

(defun c:SS ()
  (command "tilemode" 0)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:CX ()
(command "chspace")
(princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:g ()
  (setq a (ssget))
  (setq color (getint "\nChon Mau: "))
  (command "change" a "" "p" "c" color "")
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;An Doi Tuong

(defun c:InVis (/ SSet Count Elem)
  
  (defun Dxf (Id Obj)
    (cdr (assoc Id (entget Obj)))
  );end Dxf
  
  (prompt "\nSelect object(s) to hide: ")
  (cond
    ((setq SSet (ssget))
     (repeat (setq Count (sslength SSet))
       (setq Count (1- COunt)
	     Elem (ssname SSet Count))
       (if (/= 4 (logand 4 (Dxf 70 (tblobjname "layer" (Dxf 8 Elem)))))
	 (if (Dxf 60 Elem)
	   (entmod (subst '(60 . 1) (assoc 60 (entget Elem)) (entget Elem)))
	   (entmod (append (entget Elem) (list '(60 . 1))))
	 )
	 (prompt "\nEntity on a locked layer. Cannot hide this entity. ")
       );end if
     );end repeat
    )	 	
  );end cond
  (princ)
);end c:InVis

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Hien Doi Tuong

(defun c:Vis (/ WhatNextSSet Count Elem)

  (defun Dxf (Id Obj)
    (cdr (assoc Id (entget Obj)))
  );end Dxf

 (cond
  ((setq SSet (ssget "_X" '((60 . 1))))
   (initget "Yes No")
   (setq WhatNext (cond
		   ((getkword "\nAll hidden entities will be visible. Continue? No, <Yes>: "))
		   (T "Yes")))
   (cond
   ((= WhatNext "Yes")
    (prompt "\nPlease wait...")
     (repeat (setq Count (sslength SSet))
       (setq Count (1- COunt)
	     Elem (ssname SSet Count))
       (if (/= 4 (logand 4 (Dxf 70 (tblobjname "layer" (Dxf 8 Elem)))))
	 (entmod (subst '(60 . 0) '(60 . 1) (entget Elem)))
	 (prompt "\nEntity on a locked layer. Cannot make visible this entity. ")
       );end if
     );end repeat
    (prompt "\nDone...")
    )
   );end cond
  )
  (T (prompt "\nNo objects was hidden. "))
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:uu ()
  (command "ucs" "ob" )
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:ui ()
  (command "ucs" "")
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:EE ()
  (command "._purge" "_a" "" "_n" "")
  (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(defun c:mii ()
  (command "mirror" (ssget) "" Pause pause "Y" )
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c: (/ a b pointt1 select new1 c)
  (prompt "\nWELCOME TO ATAD")
  (setvar "cmdecho" 0)
  (setq osn (getvar "osmode"))
  (setq select (ssget '((0 . "dimension"))))
  (setq n (sslength select))
 (cond 
   ((= 2 n)
  (if (= (cdr (assoc 1 (entget (ssname  select 0)))) "")
  (setq a (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname  select 0))))))))
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  )
  (if (= (cdr (assoc 1 (entget (ssname  select 1)))) "")
  (setq b (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname  select 1))))))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  )

  (if (null newo) (setq newo 5))

  (setq new1 (getreal (strcat "\nNhap Chieu Day BM <" (rtos newo 2 0) ">: ")))

  (if (null new1) (setq new1 newo) (setq newo new1))
  (setq new1 (rtos new1 2 0))
  (setq pointt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
  (setq c (strcat "PL" a "*" new1 "*" b)) 
  (command "text" pointt1 50 0 c "")
  (setvar "osmode" osn)
  )

 ((= 3 n)

(if (= (cdr (assoc 1 (entget (ssname  select 0)))) "")
  (setq a (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname  select 0))))))))
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  )
  (if (= (cdr (assoc 1 (entget (ssname  select 1)))) "")
  (setq b (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname  select 1))))))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  )
  (if (= (cdr (assoc 1 (entget (ssname  select 2)))) "")
  (setq c (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname  select 2))))))))
  (setq c (cdr (assoc 1 (entget (ssname select 2)))))
  )
  (if (null newo) (setq newo 5))

  (setq new1 (getreal (strcat "\nNhap Chieu Day BM <" (rtos newo 2 0) ">: ")))

  (if (null new1) (setq new1 newo) (setq newo new1))
  (setq new1 (rtos new1 2 0))
  (setq pointt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
  (setq d (strcat "TP" a "*" b "*" new1 "*" c)) 
  (command "text" pointt1 50 0 d "")
  (setvar "osmode" osn)
)
)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:SF (/ a b pointt1 select new1 c)
  (prompt "\nWELCOME TO ATAD")
  (setvar "cmdecho" 0)
  (setq osn (getvar "osmode"))
  (setq select (ssget '((0 . "dimension"))))
(if (null bo) (setq bo 100))

  (setq b (getreal (strcat "\nNhap Chieu rong BM <" (rtos bo 2 0) ">: ")))

  (if (null b) (setq b bo) (setq bo b))
  (setq b (rtos b 2 0))
  
  (if (null newo) (setq newo 5))

  (setq new1 (getreal (strcat "\nNhap Chieu Day BM <" (rtos newo 2 0) ">: ")))

  (if (null new1) (setq new1 newo) (setq newo new1))
  (setq new1 (rtos new1 2 0))
  (setq n (sslength select))
  (setq index 0)
  (while (< index n)
(if (= (cdr (assoc 1 (entget (ssname select index)))) "")
(setq a (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname select index))))))))
(setq a (cdr (assoc 1 (entget (ssname select index)))))
)
  (setq index (+ 1 index))
  (setq pointt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
  (setq c (strcat "PL" b "x" new1 "x" a)) 
  (command "text" pointt1 50 0 c "")
  (setvar "osmode" osn)
  )
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:RD (/ a b pointt1 select s c)
  (prompt "\nWELCOME TO ATAD")
  (setvar "cmdecho" 0)
  (setq osn (getvar "osmode"))
  (setq select (ssget '((0 . "dimension"))))
  (setq s (getstring "\nNhap duong kinh Rod: "))
  (setq n (sslength select))
  (setq index 0)
  (while (< index n)
  (if (= (cdr (assoc 1 (entget (ssname  select index)))) "")
  (setq a (itoa (fix (+ 250.5 (cdr (assoc 42 (entget (ssname  select index))))))))
  (setq a (cdr (assoc 1 (entget (ssname  select index)))))
  )
  (setq index (+ 1 index))
  (setq pointt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
  (setq c (strcat "ROD" " " s "x" a)) 
  (command "text" pointt1 50 0 c "")
  (setvar "osmode" osn)
  )
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:SR (/ a b pointt1 select s c)
  (prompt "\nWELCOME TO ATAD")
  (setvar "cmdecho" 0)
  (setq osn (getvar "osmode"))
  (setq select (ssget '((0 . "dimension"))))
  (setq s (getstring "\nNhap duong kinh Rod: "))
  (setq n (sslength select))
  (setq index 0)
  (while (< index n)
  (if (= (cdr (assoc 1 (entget (ssname  select index)))) "")
  (setq a (itoa (fix (+ 50.5 (cdr (assoc 42 (entget (ssname  select index))))))))
  (setq a (cdr (assoc 1 (entget (ssname  select index)))))
  )
  (setq index (+ 1 index))
  (setq pointt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
  (setq c (strcat "ROD" " " s "x" a)) 
  (command "text" pointt1 50 0 c "")
  (setvar "osmode" osn)
  )
  (princ)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:fd ()
(progn
(command "filedia" "1")
(command "sdi" "0")
)
(princ)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:ff (/ f1 f2 w1 w2 i n nn d d1 a b s pointtt pointt1 chieudai pointxt pointxt1 pointyt pointyt1)
(prompt "\nWELCOME TO ATAD")
(setvar "cmdecho" 0)
(setq osn (getvar "osmode"))
(setq noidung (cdr (assoc 1 (entget (ssname (ssget '((0 . "TEXT,MTEXT"))) 0)))))
(setq kitu (strlen noidung))
(cond
  ((= 12 kitu)
(prompt "\nChieu dai ban canh: ")
(setq ent (ssget '((0 . "dimension"))))
(setq f1 (substr noidung 6 3)
      f2 (substr noidung 12 1))
(setq w1 (itoa (- (atoi (substr noidung 2 3)) (* (atoi (substr noidung 12)) 2)))
      w2 (substr noidung 10 1))
(setq i 0 n (sslength ent))
(cond
  ((= 1 n)
  (progn
(if (= (cdr (assoc 1 (entget (ssname ent i)))) "")
(setq chieudai (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname ent 0))))))))
(setq chieudai (cdr (assoc 1 (entget (ssname ent 0)))))
)
(setq pointt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
(setq d (strcat "PL" f1 "x" f2 "x" chieudai))
(command "text" pointt1 50 0 d "")
(setvar "osmode" osn)
  )
  (progn
(setq pointtt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointtt1 (list (+ (car pointtt) 30) (+ (cadr pointtt) 25) 0 ))
(setq d1 (strcat "PL" w1 "x" w2 "x" chieudai))
(command "text" pointtt1 50 0 d1 "")  
(setvar "osmode" osn)
)
)
  ((/= 1 n)
    (progn
      (while (< i n)
(if (= (cdr (assoc 1 (entget (ssname ent i)))) "")
(setq chieudai1 (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname ent i))))))))
(setq chieudai1 (cdr (assoc 1 (entget (ssname ent i)))))
)
(setq pointt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
(setq d (strcat "PL" f1 "x" f2 "x" chieudai1)) 
(command "text" pointt1 50 0 d "")
(setvar "osmode" osn)
(setq i (+ 1 i))
      )
    )
    (progn
  (setq select (ssget))
  (setq nn (sslength select))
  (if (= 3 nn)
    (progn
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  (setq c (cdr (assoc 1 (entget (ssname select 2)))))
  (setq s w2)
  (setq pointxt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointxt1 (list (+ (car pointxt) 30) (+ (cadr pointxt) 25) 0 ))
  (setq d (strcat "TP" a "x" b "x" s "x" c)) 
  (command "text" pointxt1 50 0 d "")
  (setvar "osmode" osn)
    )
    (progn
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  (setq s w2)
  (setq pointyt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointyt1 (list (+ (car pointyt) 30) (+ (cadr pointyt) 25) 0 ))
  (setq d (strcat "PL" a "x" s "x" b )) 
  (command "text" pointyt1 50 0 d "")
  (setvar "osmode" osn)
    )
    )
    )
    )
    ))
     ((= 13 kitu)
(prompt "\nChieu dai ban canh: ")
(setq ent (ssget '((0 . "dimension"))))
(setq f1 (substr noidung 7 3)
      f2 (substr noidung 13 1))
(setq w1 (itoa (- (atoi (substr noidung 2 4)) (* (atoi (substr noidung 13)) 2)))
      w2 (substr noidung 11 1))
(setq i 0 n (sslength ent))
(cond
  ((= 1 n)
  (progn
(if (= (cdr (assoc 1 (entget (ssname ent 0)))) "")
(setq chieudai (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname ent 0))))))))
(setq chieudai (cdr (assoc 1 (entget (ssname ent 0)))))
)
(setq pointt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
(setq d (strcat "PL" f1 "x" f2 "x" chieudai))
(command "text" pointt1 50 0 d "")
(setvar "osmode" osn)
  )
  (progn
(setq pointtt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointtt1 (list (+ (car pointtt) 30) (+ (cadr pointtt) 25) 0 ))
(setq d1 (strcat "PL" w1 "x" w2 "x" chieudai))
(command "text" pointtt1 50 0 d1 "")
(setvar "osmode" osn)  
)
)
  ((/= 1 n)
    (progn
      (while (< i n)
(setq chieudai (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname ent i))))))))
(setq pointt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
(setq d (strcat "PL" f1 "x" f2 "x" chieudai)) 
(command "text" pointt1 50 0 d "")
(setvar "osmode" osn)
(setq i (+ 1 i))
      )
    )
    (progn
  (setq select (ssget))
  (setq nn (sslength select))
  (if (= 3 nn)
    (progn
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  (setq c (cdr (assoc 1 (entget (ssname select 2)))))
  (setq s w2)
  (setq pointxt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointxt1 (list (+ (car pointxt) 30) (+ (cadr pointxt) 25) 0 ))
  (setq d (strcat "TP" a "x" b "x" s "x" c)) 
  (command "text" pointxt1 50 0 d "")
  (setvar "osmode" osn)
    )
    (progn
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  (setq s w2)
  (setq pointyt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointyt1 (list (+ (car pointyt) 30) (+ (cadr pointyt) 25) 0 ))
  (setq d (strcat "PL" a "x" s "x" b )) 
  (command "text" pointyt1 50 0 d "")
  (setvar "osmode" osn)
    )
    )
    )
    )
    ))
  )
(princ)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:fw (/ f1 f2 w w1 w2 i n nn d d1 a b s pointtt pointt1 chieudai pointxt pointxt1 pointyt pointyt1)
(prompt "\nWELCOME TO ATAD")
(setq osn (getvar "osmode"))
(setvar "cmdecho" 0)
(setq w (getstring "\nChieu cao bung: "))
(setq f1 (getstring "\nChieu rong canh: "))
(setq w2 (getstring "\nChieu day bung: "))
(setq f2 (getstring "\nChieu day canh: ")) 
(prompt "\nChieu dai ban canh: ")
(setq ent (ssget '((0 . "dimension"))))
(setq w1 (itoa (- (atoi w) (* (atoi f2) 2))))
(setq i 0 n (sslength ent))
(cond
  ((= 1 n)
  (progn
(if (= (cdr (assoc 1 (entget (ssname ent 0)))) "")
(setq chieudai (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname ent 0))))))))
(setq chieudai (cdr (assoc 1 (entget (ssname ent 0)))))
)
(setq pointt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
(setq d (strcat "PL" f1 "x" f2 "x" chieudai))
(command "text" pointt1 50 0 d "")
(setvar "osmode" osn)
  )
  (progn
(setq pointtt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointtt1 (list (+ (car pointtt) 30) (+ (cadr pointtt) 25) 0 ))
(setq d1 (strcat "PL" w1 "x" w2 "x" chieudai))
(command "text" pointtt1 50 0 d1 "")
(setvar "osmode" osn)  
)
)
  ((/= 1 n)
    (progn
      (while (< i n)
(if (= (cdr (assoc 1 (entget (ssname ent i)))) "")
(setq chieudai (itoa (fix (+ 0.5 (cdr (assoc 42 (entget (ssname ent i))))))))
(setq chieudai (cdr (assoc 1 (entget (ssname ent i)))))
)
(setq pointt (getpoint "\nChon Diem Dat: "))
(setvar "osmode" 0)
(setq pointt1 (list (+ (car pointt) 30) (+ (cadr pointt) 25) 0 ))
(setq d (strcat "PL" f1 "x" f2 "x" chieudai)) 
(command "text" pointt1 50 0 d "")
(setvar "osmode" osn) 
(setq i (+ 1 i))
      )
    )
    (progn
  (setq select (ssget))
  (setq nn (sslength select))
  (if (= 3 nn)
    (progn
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  (setq c (cdr (assoc 1 (entget (ssname select 2)))))
  (setq s w2)
  (setq pointxt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointxt1 (list (+ (car pointxt) 30) (+ (cadr pointxt) 25) 0 ))
  (setq d (strcat "TP" a "x" b "x" s "x" c)) 
  (command "text" pointxt1 50 0 d "")
  (setvar "osmode" osn) 
    )
    (progn
  (setq a (cdr (assoc 1 (entget (ssname  select 0)))))
  (setq b (cdr (assoc 1 (entget (ssname select 1)))))
  (setq s w2)
  (setq pointyt (getpoint "\nChon Diem Dat: "))
  (setvar "osmode" 0)
  (setq pointyt1 (list (+ (car pointyt) 30) (+ (cadr pointyt) 25) 0 ))
  (setq d (strcat "PL" a "x" s "x" b )) 
  (command "text" pointyt1 50 0 d "")
  (setvar "osmode" osn) 
    )
    )
    )
    )
    )
(princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun C:tim()
 (setq ent (entsel))
 (setq entl(entget (car ent)))
 (setq ct 0)
 (textpage )
 (princ "\nentget of last entity: ")
 (repeat (length entl)
  (print (nth ct entl))
 (setq ct (1+ ct))
)
 (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












