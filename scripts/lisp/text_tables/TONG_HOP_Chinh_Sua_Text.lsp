;;;--------------------------------------------------------------------;
(defun c:TC()(copy-add-text-content 0))
;;;--------------------------------------------------------------------;
;;;COPY DOI TEXT SANG TEXT KHAC
(defun c:tv ()
(command "undo" "be")
(setq donvi (/ (getvar "viewsize") 40))
(setq ddd (entsel "\nChon doi tuong mau"))
(while
(or
(null ddd)
(and (/= "TEXT" (cdr (assoc 0 (entget (car ddd))))) (/= "MTEXT" (cdr (assoc 0 (entget (car ddd))))) (/= "DIMENSION" (cdr (assoc 0 (entget (car ddd)))))))
(setq ddd (entsel "\nDoi tuong phai la TEXT, MTEXT hoac DIMENSION! Chon lai")))
   (setq DT (car ddd))
   (setq DTM (entget DT))
   (setq NOIDUNG (cdr (assoc 1 DTM)))
   (setq DIEMCHENMAU (cdr (assoc 10 DTM)))
(setq diemvt1 (polar DIEMCHENMAU pi donvi))
(setq diemvt2 (polar DIEMCHENMAU (* 2 pi) donvi))
(setq diemvt3 (polar DIEMCHENMAU (/ pi 2) donvi))
(setq diemvt4 (polar DIEMCHENMAU (- 0 (/ pi 2)) donvi))
            (grdraw diemvt1 diemvt2 3)
            (grdraw diemvt3 diemvt4 3)
 (Princ "\nChon TEXT,MTEXT,DIMENSION muon chinh :")
 (setq xx (ssget '((0 . "TEXT,MTEXT,DIMENSION"))))
 (setq L 0)
 (setq M (sslength XX))
 (while (< L M)
           (setq DTs (ssname XX L))
           (setq DTMs (entget DTs))
           (setq NOIDUNGM NOIDUNG)
           (setq DTMs (subst (cons 1 NOIDUNGM) (assoc 1 DTMs) DTMs))
           (entmod DTMs)
   (setq L (1+ L)))
(command ".pan" DIEMCHENMAU DIEMCHENMAU)
(command "undo" "end")
(setvar "MODEMACRO" "**TAILIEUKYTHUAT.COM**")
      (Princ))
;;;----------------------------------------------------------------------------;

;;;DOI DTEXT VE MTEXT
(defun c:yu ()(foreach en (acet-ss-to-list (ssget '((0 . "*TEXT")))) (command "_txt2mtxt" En "")))
;;;----------------------------------------------------------------------------;

;;;CHUYEN DIM VE TEXT
(defun c:YY (/ ss sst)
(if (setq ss (ssget '((0 . "DIMENSION"))) i -1)
(Repeat (sslength ss)
(if (vl-cmdf "explode" ss)
(Repeat (sslength (setq sst (ssget "P" (list(cons 0 "~*TEXT")))))
(vl-cmdf "erase" (ssname sst (setq i (1+ i))) "")))(setq i -1))))

;;;--------------------------------------------------------------------;

;;;XOAY TEXT TRONG ATT BLOCK VE DUNG CHIEU
(defun c:XO( / ssdt sodt index tt entdt)    
(setq ssdt (ssget)	sodt (sslength ssdt)	index 0  )  
(repeat sodt    (setq entdt (ssname ssdt index)	  index (1+ index)	  entdt (entnext entdt)	  tt (entget entdt)	  tt (subst (cons 50 0.0) (assoc 50 tt) tt)    )    (entmod tt)    (entupd entdt)  )  
(princ))
;;;------------------------------------------------------------------;
;;;THAY DOI CHIEU CAO TEXT
(defun c:TY ()
 (setq caotext (cond (caotext) ("50")))
 (initget 1)
 (setq caotext (cond ((getstring (strcat "\nNhap chieu cao text<"caotext">"))) (caotext)))
(command ".scaletext" (ssget (list (cons 0 "TEXT,MTEXT"))) "" "" caotext)
(princ))
;;;------------------------------------------------------------------;
;;;THAY DOI DO RONG TEXT
(defun c:tt(/ ss tw)
(defun Tue-ent-mod (dxf ename newValue / entget-ename)
  ;;;;;Ex: (Tue-ent-mod 1 (ssname (TUE-ss-entsel '((0 . "TEXT")) "\npick chon doi tuong TEXT / An phim bat ki de thoat :")  0)"TUE")
  ;;;;;;;;-->> Thay Text thanh chuoi "TUE"
  ;;;;;;;;dxf = 62 ma mau object; dxf = 6 ma Linetype cuar object
  (setq entget-ename (entget ename))
  (if (and (or (= dxf 62) (= dxf 6)) (null (assoc dxf entget-ename)))
          (setq entget-ename (append entget-ename (list (cons dxf newValue))))
  )
  (setq entget-ename (subst (cons dxf newValue) (assoc dxf entget-ename) entget-ename))
  (entmod entget-ename)
  ename
)
(defun Tue-ss-list (L-ss-vlaobj / n L Lst ssg vlaobj)
 
  (mapcar 'set '(ssg vlaobj) L-ss-vlaobj)
  (setq L (sslength ssg))
  (Repeat L
        (setq ename (ssname ssg (setq L (1- L))))
          (setq Lst (cons (if vlaobj (vlax-ename->vla-object ename) ename) Lst))
  )
)
(if (setq ss (ssget '((0 . "TEXT"))))
  (progn
    (setq tw (getreal "\n Nhap do rong chu :"))
    (foreach x (Tue-ss-list (list ss))
      (Tue-ent-mod 41 x tw)
    )
  )
)
)