;;;----------------------------------------------------------------------------
(defun c:DS(/ A B C TLC TLS SC)
(setvar "TEXTSTYLE" "VNI")
(setvar "TEXTSIZE" 2.2)
(setq 	TLC (getSTRING "Nhan ty le: "))
(setq 	SC (strcat "ATAD1-" TLC))
(setq 	tlS (distof tlC))
(command "-dimstyle" "" "ATAD1-1" "")
(setvar "DIMSCALE" tls)
(command "-dimstyle" "s" sc)
(setq A (getvar "DIMTXT"))
(setq B (getvar "DIMTXSTY"))
(setq C (getvar "DIMSCALE")) 
(setvar "TEXTSIZE" (* A C))
(setvar "TEXTSTYLE" B)
(princ))
;;;----------------------------------------------------------------------------

(Defun c:TOP ()	;;;(VE MAT CHUAN TOP)
	(command "-view" "TOP")
	(command "zoom" "e")
	(command "regen"))
;;;--------------------------------------------------------------------;
;;;HATCH MAT DINH THEP
(defun c:HI ()
  (COMMAND "-HATCH" "LA" "22 Hatch" "P" "ANSI32" "2.5" "0" "CO" "." "")(princ))
;;;--------------------------------------------------------------------;
----------------------------------------------------------------;

;;;DOI DIM DUOC CHON VE DIM HIEN HANH
(defun c:Q1 () (command "-dimstyle" "APPLY" pause))

;;;DOI LAYER DUOC CHON VE LAYER HIEN HANH
(defun c:Q2 () (command "LAYCUR"))
;;;--------------------------------------------------------------------;

;;;CHON LAYER DUOC CHON LAM LAYER HIEN HANH
(defun c:aw()
(command "clayer" (cdr(assoc 8 (entget(car(entsel "\nChon doi tuong lay layer hien hanh:")))))))
;;;--------------------------------------------------------------------;

;;;CHUYEN DOI TUONG VE LAYER MAC DINH
(defun c:B1 (/ SSE) (SETQ SSE (SSGET)) (command "-SETBYLAYER" SSE "" "Y" "Y"))

;;;--------------------------------------------------------------------;
(defun c:at()
(command "textstyle" (cdr(assoc 7 (entget(car(entsel "\nChon doi tuong lay textstyle hien hanh:")))))))

;;;--------------------------------------------------------------------;

;;;LAY DIM DUOC CHON LAM DIM MAC DINH
(defun c:AS (/ A B C)
(command "-dimstyle" "" "" pause)
(setq A (getvar "DIMTXT"))
(setq B (getvar "DIMTXSTY"))
(setq C (getvar "DIMSCALE")) 
(setvar "TEXTSIZE" (* A C))
(setvar "TEXTSTYLE" B)
(PRINC)
)
;;;--------------------------------------------------------------------;
(defun c:as2 ()
(setvar "cmdecho" 0)
(setq tls0 (getvar "dimscale"))
(setq sel1 (entsel "Select Block"))  
(if (= (cdr (assoc 0 (entget(car sel1)))) "INSERT")
    (setq tls (abs (cdr (assoc 41 (entget(car sel1))))))
    (progn (alert "This Is Not BLock, Are You Kidding Me !")
    (exit)))

(setq tlc (itoa (fix tls)))
(setvar "textstyle" "VNI")
(setvar "textsize" 2.2)
(setq 	sc (strcat "ATAD1-" tlc))
(command "-dimstyle" "" "ATAD1-1")
  
(setvar "dimscale" tls)
(if	(tblsearch "dimstyle" sc)
	(command "-dimstyle" "s" sc "y")
	(command "-dimstyle" "s" sc))
(setq a (getvar "dimtxt"))
(setq b (getvar "dimtxsty"))
(setq c (getvar "dimscale")) 
(setvar "textsize" (* a c))
(setvar "textstyle" b)
(setvar "ltscale" (* 5 c ))
(setvar "cmdecho" 1)
(princ))
;;;--------------------------------------------------------------------;
(defun c:N (/ tdt ssdt sodt index)
(defun ObjName (ssdt /)
(cdr (assoc '0 (entget ssdt))))
(defun MoPL (ssdt /)
(= (cdr (assoc '70 (entget ssdt))) 0))
(defun NoiPL (ssdt /)(if (MoPL ssdt)
(command ".PEDIT" ssdt "J" "All" "" "X")))
(defun NoiLC (ssdt /)
(command ".PEDIT" ssdt "Y" "J" "All" "" "X"))
(setq tdt (ssget) sodt (sslength tdt) index 0)
(repeat sodt (setq ssdt (ssname tdt index) index (1+ index))
(if (or (= (Objname ssdt) "LWPOLYLINE")
(= (Objname ssdt) "POLYLINE"))
(NoiPL ssdt))
(if (or (= (Objname ssdt) "LINE") (= (Objname ssdt) "ARC"))
(NoiLC ssdt)))
(princ))

;;;--------------------------------------------------------------------;
(defun c:K ()
    (setvar "cmdecho" 0)
    (setq olderr *error* *error* myerror)
    (prompt "\nSelect Text: ")
    (command "select" "au" pause)
    (setq sstxt (ssget "p")sslen (sslength sstxt)ctr 0)
    (command ".undo" "mark")
    (while (< ctr sslen)
           (setq listxt (entget (ssname sstxt ctr))
                 txttxt (cdr (assoc 1 listxt))
                 enttxt (cdr (assoc 0 listxt)))
           (if (= enttxt "TEXT")
               (progn(setq testxt (substr txttxt 1 3))
                   (if (or (= testxt "%%u") (= testxt "%%U"))
                       (setq newtxt (substr txttxt 4))
                       (setq newtxt (strcat "%%u" txttxt)))
                   (setq listxt (subst (cons 1 newtxt) (assoc 1 listxt) listxt))
                   (entmod listxt)))(setq ctr (1+ ctr)))
    (setq *error* olderr)
    (setvar "cmdecho" 1)
    (princ))

