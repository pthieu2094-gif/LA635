
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(Defun c:RT ()

(setq olddim (getvar "dimzin"))
(setvar "DimZin" 0)
(setq osn (getvar "osmode"))
(setvar "mirrtext" 0)
(setq canle (cond (canle) ("C")))
 (initget "B C")
 (setq canle (cond ((getkword (strcat "\Chon Kieu Cong Text [Base/Continue]<" canle ">"))) (canle)))
   (if 
     (eq canle "B")
    (progn
(setq en (ssget '((0 . "TEXT,DIMENSION,MTEXT"))))
(setq n (sslength en) i 0)

(if (null newo) (setq newo 1))

(setq new1 (getreal (strcat "\nNhap so can cong <" (rtos newo 2 0) ">: ")))

(if (null new1) (setq new1 newo) (setq newo new1))

(while (< i n)

(setq ename (entget (ssname en i)))


(setq li (cdr (assoc 1 ename)))

(setq lis (+ (atof li) (* (+ 1 i) new1)))

(setq ename (subst (cons 1 (rtos lis 2 0)) (assoc 1 ename) ename))

(entmod ename)
(setq i (+ i 1))
)
(setvar "dimzin" olddim)
)
)
(princ)

(if 
     (eq canle "C")
    (progn
(setq en (ssget '((0 . "TEXT,DIMENSION,MTEXT"))))
(setq n (sslength en) i 0)

(if (null newo) (setq newo 1))

(setq new1 (getreal (strcat "\nNhap so can cong <" (rtos newo 2 0) ">: ")))

(if (null new1) (setq new1 newo) (setq newo new1))

(while (< i n)

(setq ename (entget (ssname en i)))


(setq li (cdr (assoc 1 ename)))

(setq lis (+ (atof li) new1))

(setq ename (subst (cons 1 (rtos lis 2 0)) (assoc 1 ename) ename))

(entmod ename)
(setq i (+ i 1))
)
(setvar "dimzin" olddim)
)
)
(princ)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(Defun c:CTT (/ c e ss txt cmde ttdangs ttdangt)
  (setq cmde (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setq ttdangt (getstring 5"\nChuoi muon them phia truoc:")) 
  (setq ttdangs (getstring 5"\nChuoi muon them phia sau:")) 
  (if (null ttdangt)(setq ttdangt ""))
  (if (null ttdangs)(setq ttdangs ""))
 (prompt "\nChon chu muon chinh.")
  (setq ss (ssget))
  (setq c 0)
  (if ss (setq e (ssname ss c)))
  (while e
    (setq e (entget e))
    ; Ensure entity is text
    (if (= (cdr (assoc 0 e)) "TEXT")
        (progn
                 (setq txt (strcat ttdangt (cdr (assoc 1 e)) ttdangs))
           (setq e (subst (cons 1 txt) (assoc 1 e) e))
           (entmod e)
        )
    )
    (setq c (1+ c)) ; Increment counter.
    (setq e (ssname ss c))  ; Obtain next entity.
   )
   (setvar "CMDECHO" cmde)
      (PrinC)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun ss2ent (ss / sodt index lstent)
(setq 	sodt (if ss (sslength ss) 0)
	index 0)
(repeat sodt
(setq 	ent (ssname ss index)
	index (1+ index)
	lstent (cons ent lstent)
);setq
);repeat
(reverse lstent)
)
(Defun c:ct ()
(setq osn (getvar "osmode"))
(setvar "mirrtext" 0)
 (Princ "\nHay chon doi tuong :")
 (setq SS (ssget '((0 . "TEXT,MTEXT"))))
 (setq i 0)
 (setq N (sslength ss))
 (setq canle (cond (canle) ("L")))
 (initget "L C R B S")
 (setq canle (cond ((getkword (strcat "\Vi tri can le [Left/Center/Right/Bottom/Space]<" canle ">"))) (canle)))
   (if 
     (eq canle "L")
    (progn
 (setq diemcanhle (getpoint "\nChon diem canh le :"))
 (while (< i N)

  (setvar "osmode" 0)

   (setq DT (ssname ss i))
   (setq DTT (entget DT))
   (setq TEXT (cdr (assoc 10 DTT)))
   (setq Xcanhle (list (car diemcanhle)(cadr text))) 
   (command ".move" DT "" TEXT Xcanhle)

   (setq i (1+ i))
(setvar "osmode" osn)
)
)
)
(princ)

   (if 
     (eq canle "C")

(progn

(setq diemcanhle (getpoint "\nChon diem canh le :"))

(while (< i N)

  
  (setvar "osmode" 0)

   (setq DT (ssname ss i))
   (setq DTT (entget DT))
   (setq TEXT (cdr (assoc 10 DTT)))
   (setq Xcanhle (list (car diemcanhle)(cadr text))) 
   (command ".move" DT "" TEXT Xcanhle)
   (command ".mirror" DT "" Xcanhle diemcanhle "y")

   (setq DTTG (entget DT))
   (setq TEXTG (cdr (assoc 10 DTTG)))
  (setq  daitextg (distance Xcanhle TEXTG))
  (setq goctextg(angle Xcanhle TEXTG))
  (setq dainuatextg (/ daitextg 2))
  (setq diemquayg (polar Xcanhle goctextg dainuatextg))
  ;(setq diemlatg (list (car diemquayg) (+ (cadr diemquayg) 100)))
  (command ".move" DT "" diemquayg Xcanhle)
  ;(command ".mirror" DT "" diemquayg diemlatg "y")

   (setq i (1+ i))
(setvar "osmode" osn)
)
)
)
(princ)

(if 
     (eq canle "R")

(progn
(setq diemcanhle (getpoint "\nChon diem canh le :"))

(while (< i N)
  (setvar "osmode" 0)

   (setq DT (ssname ss i))
   (setq DTT (entget DT))
   (setq TEXT (cdr (assoc 10 DTT)))
   (setq Xcanhle (list (car diemcanhle)(cadr text))) 
   (command ".move" DT "" TEXT Xcanhle)
   (command ".mirror" DT "" Xcanhle diemcanhle "y")

   (setq i (1+ i))
  (setvar "osmode" osn)  
 )
)
)
(princ)

(if 
     (eq canle "B")

(progn

(setq diemcanhle (getpoint "\nChon diem canh le :"))
(while (< i N)
  (setvar "osmode" 0)

   (setq DT (ssname ss i))
   (setq DTT (entget DT))
   (setq TEXT (cdr (assoc 10 DTT)))
   (setq Xcanhle (list (car text)(cadr diemcanhle)))  
   (command ".move" DT "" TEXT Xcanhle)

   (setq i (1+ i))
(setvar "osmode" osn)   
 )
)
)
(princ)

(if 
     (eq canle "S")

(progn
(setq oldos (getvar "osmode"))
(setq 	lst (ss2ent ss)
	lst (vl-sort lst '(lambda (e1 e2) (< (cadr (assoc 10 (entget e1))) (cadr (assoc 10 (entget e2))))))
	lst (vl-sort lst '(lambda (e1 e2) (> (caddr (assoc 10 (entget e1))) (caddr (assoc 10 (entget e2))))))
);setq
(command "undo" "begin")
(setvar "osmode" 15359)
(setq kc (getdist "\n Nhap khoang cach giua cac text"))
(setq ddau (cdr(assoc 10 (entget(car lst)))) i 0 a2 (ssadd))
(setq mau (entget (car (entsel "\nChon text chuan"))))
(setq ptmau (cdr(assoc 10 mau)))
(setq ym (cadr ptmau))
(foreach e lst
(setq ent (entget e))
(setq dcuoi (cdr(assoc 10 ent)))
(setq yi (cadr dcuoi))
(setq ddauu (list (car dcuoi) (- (cadr ddau) (* i kc))))
(if (= yi ym) (setq ptgoc (list (car dcuoi) (- (cadr ddau) (* i kc)))))
(setvar "osmode" 0)
(command "move" e "" dcuoi ddauu)
(setq 	a2 (ssadd e a2))
(setq i (1+ i))
);foreach
(command "move" a2 "" ptgoc ptmau)
(setvar "osmode" oldos)
(command "undo" "end")
)
)
(princ)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun copy-add-text-content (mode / err oer sta res sel mtx dim chc chg
			      hig sor rdw dec temp
			      sou data)
;											
  (defun err(s)
    (if (and (/= s "Function cancelled")(/= s "quit / exit abort"))
      (princ (strcat "\n--->> Error: " s))
      )
    (res)
    )
;											
  (defun res()
    (if hig (setvar "HighLight" hig))
    (if sor (setvar "Sortents" sor))
    (if pst (setvar "Pickstyle" pst))
    (if rdw (chc 0))
    (command "_.Undo" "_End")
    (setq *error* oer)
    (setvar "Cmdecho" 1)
    (princ)
    )
;											
  (defun sta()
    (setq oer *error*
	  *error* err
	  hig (getvar "HighLight")
	  sor (getvar "Sortents")
	  pst (getvar "Pickstyle")
	  dec (getvar "Dimdec")
	  )
    (setvar "Cmdecho" 0)
    (command "_.Undo" "_Group")
    (setvar "HighLight" 1)
    (setvar "Sortents" 1)
    (setvar "Pickstyle" 0)
    (graphscr)
    )
;											
  (defun sel(/ loop lis typ intro)
    (if (null del-mode)(setq del-mode "0"))
    (if (null mat-mode)(setq mat-mode "0"))
    (setq loop T
	  lis '("TEXT" "MTEXT" "DIMENSION" "ARCALIGNEDTEXT")
	  )
    (if (= mode 0)
      (setq intro "\nSelect copy source text ")
      (setq intro "\nSelect additon source text ")
      )
    (while loop
      (initget "Exit Delete Match MD DM")
      ;(setq del T);;;
      (setq sou (entsel (strcat intro "[Delete source("del-mode")/Match properties("mat-mode")]: ")))
      (cond
	((= sou "Exit")(exit))
	((null sou)(exit))
	((= sou "Delete")
	 (if (= del-mode "0")
	   (setq del-mode "1")
	   (setq del-mode "0")
	   )
	 )
	((= sou "Match")
	  (if (= mat-mode "0")
	   (setq mat-mode "1")
	   (setq mat-mode "0")
	   )
	  )
	((or (= sou "MD")(= sou "DM"))
	  (progn
	    (if (= del-mode "0")
	      (setq del-mode "1")
	      (setq del-mode "0")
	      )
	    (if (= mat-mode "0")
	      (setq mat-mode "1")
	      (setq mat-mode "0")
	      )
	    )
	  )
	((progn
	   (setq data (entget (car sou))
		 typ (cdr (assoc 0 data))
		 )
	   (if (not (member typ lis))
	     (princ "Invalid selection.")
	     (progn
	       (setq temp (assoc 1 data)
		     loop nil
		     )
	       (cond
		 ((= typ "MTEXT")(mtx))
		 ((= typ "DIMENSION")(dim))
		 )
	       )
	     ); if end
	   ))
	); cond end
      )
    (chc 1)
    (setq rdw T)
    )
;											
  (defun mtx(/ con test)
    (setq con (cdr temp)
	  test (substr con 1 1)
	  )
    (if (= test "\\")(setq temp (cons 1 (substr con 5))))
    )
;											
  (defun dim(/ con)
    (setq con (cdr temp))
    (if (or (= con "")(= con "<>"))
      (setq temp (cons 1 (rtos (cdr (assoc 42 data)) 2 dec)))
      )
    )
;											
  (defun chc(mode / col)
    (cond
      ((and (= del-mode "1") (= mat-mode "0"))(setq col "230"))
      ((and (= del-mode "0") (= mat-mode "1"))(setq col "110"))
      ((and (= del-mode "1") (= mat-mode "1"))(setq col "30"))
      ((setq col "140"))
      )
    (if (= mode 0)
      (progn
	(command "_.Chprop" sou "" "_Color" "BYLAYER" "")
	(redraw (car sou) 4)
	)
      (progn
	(command "_.Chprop" sou "" "_Color" col "")
	(redraw (car sou) 3)
	)
      )
    )
;											
  (defun chg(/ ss inc data-)
    (if (= mode 0)
      (princ "\nSelect destiantion texts to change: ")
      (princ "\nSelect destiantion texts to add: ")
      )
    (setq ss (ssget '((-4 . "<OR")
		      (0 . "TEXT")(0 . "MTEXT")(0 . "DIMENSION")(0 . "ARCALIGNEDTEXT")
		      (-4 . "OR>")
		      )))
    (if (null ss)(exit))
    (setq inc 0)
    (repeat (sslength ss)
      (setq data- (entget (ssname ss inc))
	    inc (1+ inc))
      (if (= mode 1)
	(setq temp (cons 1 (strcat (cdr (assoc 1 data-)) "x" (cdr temp))))
	)
      (entmod (subst temp (assoc 1 data-) data-))
      )
    (if (= mat-mode "1")
      (progn
	(if rdw (chc 0))
	(command "_.MatchProp" sou ss "")
	)
      )
    (if (= del-mode "1")
      (progn
	(entdel (car sou))
	(setq rdw nil)
	)
      )
    )
;											
  (sta)
  (sel)
  (chg)
  (res)
  )

(defun c:TC()(copy-add-text-content 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun etype (e)
(cdr (assoc 0 (entget e)))
)
;;;-------------------------------------------------
(defun wtxt (txt p / sty d h);;;Write txt on graphic screen, defaul setting
(setq
	sty (getvar "textstyle")
	d (tblsearch "style" sty)
	h (cdr (assoc 40 d))
)
(if (= h 0) (setq h (cdr (assoc 42 d))))
(entmake
	(list (cons 0 "TEXT") (cons 7 sty) (cons 1 txt) (cons 10 p) (cons 40 h) (assoc 41 d))
)
)
;;;-------------------------------------------------
(defun incN (n dn / n2 i n1);;;Increase number n
(setq
	n2 (itoa (+ dn (atoi n)))
	i (- (strlen n) (strlen n2))
)
(if (> i 0) (setq n1 (substr n 1 i)) (setq n1 ""))
(strcat n1 n2)
)
;;;-------------------------------------------------
(defun incC (c / i c1 c2);;;Increase character c
(setq
	i (strlen c)
	c1 (substr c 1 (- i 1))
	c2 (chr (1+ (ascii (substr c i 1))))
)
(if (or (= c2 "{") (= c2 "["))
	(progn (command "erase" (entlast) "") (alert "Over character!") (exit))
	(strcat c1 c2)
)
)
;;;============================
(defun C:OD( / cn dn c n p);;;Make OrDinal number with any format
(setq
	cn (getstring "\nBegin at <1>: " T)
	dn (getint "\nIncrement <1>: ")
)
(if (not dn) (setq dn 1))
(if (= cn "") (setq cn "1"))
(setq c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn))
(setq n (vl-string-subst "" c cn))
(if (/= n "") (setq mode 1) (setq mode 0))
(while (setq p (getpoint "\nBase point <exit>: "))
	(wtxt cn p)
	(if (= n "") 
		(setq cn (incC cn))
		(setq cn (strcat c (incN (vl-string-subst "" c cn) dn)))		
	)
)
(princ)
)
;;;============================
(defun C:OC( / e dn p1 cn c n p2 dat);;;Make Ordinal number. Copy from template
(setq
	e (car (entsel "\nSelect template text:"))
	dn (getint "\nIncrement <1>: ")
	p1 (getpoint "\nBase point:")
	cn (cdr (assoc 1 (entget e)))
)
(if (not dn) (setq dn 1))
(if (= cn "") (setq cn "1"))
(setq
	c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn)
	n (vl-string-subst "" c cn)
)
(while (setq p2 (getpoint p1 "\nNew point <exit>: "))
	(command "copy" e "" p1 p2)
	(if (= n "") 
		(setq cn (incC cn))
		(setq cn (strcat c (incN (vl-string-subst "" c cn) dn)))		
	)
	(setq
		dat (entget (entlast))
		dat (subst (cons 1 cn) (assoc 1 dat) dat)
	)
	(entmod dat)	
)
(princ)
)
;;;============================
(defun C:OCA( / e e0 dn p1 cn c n p2 dat);;;Make Ordinal number. Copy from Atttribute block
(setq
	e0 (car (entsel "\nSelect attribute block:"))
	e (entnext e0)
)
(if (/= (etype e) "ATTRIB") (progn (alert "Object is not a Attribute Block!") (exit)))
(setq
	dn (getint "\nIncrement <1>: ")
	p1 (getpoint "\nBase point:")
	cn (cdr (assoc 1 (entget e)))
)
(if (not dn) (setq dn 1))
(if (= cn "") (setq cn "1"))
(setq
	c (vl-string-right-trim "0 1 2 3 4 5 6 7 8 9" cn)
	n (vl-string-subst "" c cn)
)
(while (setq p2 (getpoint p1 "\nNew point <exit>: "))
	(command "copy" e0 "" p1 p2)
	(if (= n "") 
		(setq cn (incC cn))
		(setq cn (strcat c (incN (vl-string-subst "" c cn) dn)))		
	)
	(setq
		dat (entget (entnext (entlast)))
		dat (subst (cons 1 cn) (assoc 1 dat) dat)
	)
	(entmod dat)
	(command "regen")
)
(princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:K ()
    (setvar "cmdecho" 0)
    (setq olderr *error* *error* myerror)
    (prompt "\nSelect Text: ")
    (command "select" "au" pause)
    (setq sstxt (ssget "p")
          sslen (sslength sstxt)
          ctr 0
    )
    (command ".undo" "mark")
    (while (< ctr sslen)
           (setq listxt (entget (ssname sstxt ctr))
                 txttxt (cdr (assoc 1 listxt))
                 enttxt (cdr (assoc 0 listxt))
           )
           (if (= enttxt "TEXT")
               (progn
                   (setq testxt (substr txttxt 1 3))
                   (if (or (= testxt "%%u") (= testxt "%%U"))
                       (setq newtxt (substr txttxt 4))
                       (setq newtxt (strcat "%%u" txttxt))
                   )
                   (setq listxt (subst (cons 1 newtxt) (assoc 1 listxt) listxt))
                   (entmod listxt)
                )
            )
            (setq ctr (1+ ctr))
    )
    (setq *error* olderr)
    (setvar "cmdecho" 1)
    (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:TKT (/ lst msp pt ss str txtsiz)    ; THONG KE TEXT 1
  (vl-load-com)  
  (if (setq ss (ssget(list (cons 0 "TEXT,MTEXT"))))
    (progn
      (foreach e (mapcar 'vlax-ename->vla-object(vl-remove-if 'listp (mapcar 'cadr (ssnamex ss))))
	(setq str (vla-get-TextString e))
	(if (not (assoc str lst))
	  (setq lst (cons (cons str 1) lst))
	  (setq lst (subst (cons str (1+ (cdr (assoc str lst))))
			   (assoc str lst) lst)))	)
      (setq lst (vl-sort lst '(lambda (x y) (< (cdr x) (cdr y))))
	    pt (getpoint "\nDiem dat Bang :" )
	    txtsiz (* (getvar "dimtxt")(getvar "dimscale"))
	    msp (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
      (foreach e lst
	(vla-addtext msp (cdr e) (vlax-3d-point pt) txtsiz )
	(vla-addtext msp (car e) (vlax-3d-point (polar pt 0 (* 5 txtsiz))) txtsiz )
	(setq pt (polar pt (/ pi -2) (* 1.5 txtsiz)))	)      )
    (alert "Khong chon duoc Text.")    )
  (princ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:NS (/ x1 t1 font1 font)
  (setq font1 (getvar "textstyle"))
  (setq select (entget (ssname (ssget) 0)))
  (setq x1 (cdr (assoc 40 select)))
  (setq font (cdr (assoc 7 select)))
  (setq tenfile (open "D:/TIEN ICH LISP/TEXT/NFS.txt" "r"))
  (setq t1 (read-line tenfile))
  (setvar "textstyle" font)
  (command "text" pause x1 0 t1 "")
  (setvar "textstyle" font1)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:FS (/ x1 t1 font1 font)
  (setq font1 (getvar "textstyle"))
  (setq select (entget (ssname (ssget) 0)))
  (setq x1 (cdr (assoc 40 select)))
  (setq font (cdr (assoc 7 select)))
  (setq tenfile (open "D:/TIEN ICH LISP/TEXT/NFS.txt" "r"))
  (repeat 2
  (setq t1 (read-line tenfile)))
  (setvar "textstyle" font)
  (command "text" pause x1 0 t1 "")
  (setvar "textstyle" font1)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:NF (/ x1 t1 font1 font)
  (setq font1 (getvar "textstyle"))
  (setq select (entget (ssname (ssget) 0)))
  (setq x1 (cdr (assoc 40 select)))
  (setq font (cdr (assoc 7 select)))
  (setq tenfile (open "D:/TIEN ICH LISP/TEXT/NFS.txt" "r"))
  (repeat 3
  (setq t1 (read-line tenfile)))
  (setvar "textstyle" font)
  (command "text" pause x1 0 t1 "")
  (setvar "textstyle" font1)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:TY (/ x1 t1 font1 font)
  (setq font1 (getvar "textstyle"))
  (setq select (entget (ssname (ssget) 0)))
  (setq x1 (cdr (assoc 40 select)))
  (setq font (cdr (assoc 7 select)))
  (setq tenfile (open "D:/TIEN ICH LISP/TEXT/NFS.txt" "r"))
  (repeat 4
  (setq t1 (read-line tenfile)))
  (setvar "textstyle" font)
  (command "text" pause x1 0 t1 "")
  (setvar "textstyle" font1)
  (princ)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:SCT ()
 (setq caotext (cond (caotext) ("50")))
 (initget 1)
 (setq caotext (cond ((getstring (strcat "\nNhap chieu cao text<"caotext">"))) (caotext)))
(command ".scaletext" (ssget (list (cons 0 "TEXT,MTEXT,DIMENSION"))) "" "" caotext)
(princ)
) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(Defun c:zoomp ( )
  (command ".zoom" "")
    (Princ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:ttm ()(foreach en (acet-ss-to-list (ssget '((0 . "*TEXT")))) (command "_txt2mtxt" En "")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun C:tit()
  (setq dcl_id (load_dialog "D:/TIEN ICH LISP/DCL/tienichtext.dcl"))
  (if (not (new_dialog "txt" dcl_id) ) (exit))
  	(action_tile "cancel" "(setq ddiag 0)(done_dialog)")
        (action_tile "zoom" "(setq ddiag 1)(done_dialog)")
	(action_tile "btn_od" "(setq ddiag 2)(done_dialog)")
	(action_tile "btn_oc" "(setq ddiag 3)(done_dialog)")
	(action_tile "btn_ctt" "(setq ddiag 4)(done_dialog)")
	(action_tile "btn_clt" "(setq ddiag 5)(done_dialog)")
	(action_tile "btn_clp" "(setq ddiag 6)(done_dialog)")
	(action_tile "btn_cln" "(setq ddiag 7)(done_dialog)")
	(action_tile "btn_k" "(setq ddiag 8)(done_dialog)")
	(action_tile "btn_dc" "(setq ddiag 9)(done_dialog)")
	(action_tile "btn_td" "(setq ddiag 10)(done_dialog)")
	(action_tile "btn_tc" "(setq ddiag 11)(done_dialog)")
	(action_tile "btn_ttm" "(setq ddiag 12)(done_dialog)")
	(action_tile "btn_sct" "(setq ddiag 13)(done_dialog)")
(start_dialog) 
  (unload_dialog dcl_id)

 (cond 
      ((= ddiag 1) (c:zoomp))
      ((= ddiag 2) (c:od))
      ((= ddiag 3) (c:oc))
      ((= ddiag 4) (c:ctt))
      ((= ddiag 5) (c:clt))
      ((= ddiag 6) (c:clp))
      ((= ddiag 7) (c:cln))
      ((= ddiag 8) (c:k))
      ((= ddiag 9) (c:dc))
      ((= ddiag 10) (c:td))
      ((= ddiag 11) (c:tc))
      ((= ddiag 12) (c:ttm))
      ((= ddiag 13) (c:sct))
    )
	(princ)
  )





