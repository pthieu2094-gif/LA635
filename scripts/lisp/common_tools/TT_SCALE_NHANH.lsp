;LENH CHINH
(defun c:GG (/ DIMSTYLE TEXTSIZE DIMSCALE ss lengss n OB OB1 name scale TIENTO_BLOCK)
  (setq DIMSTYLE (getvar "DIMSTYLE"))
  (setq TEXTSIZE (getvar "TEXTSIZE"))
  (setq DIMSCALE (getvar "DIMSCALE"))
;CHON TAP HOP DOI TUONG
  (setq ss (ssget (list (cons 0 "DIMENSION,LEADER,TEXT,MTEXT,INSERT"))))
  (setq lengss (sslength ss))
  (setq n 0)
;VONG LAP
  (REPEAT lengss
    (setq OB1 (ssname ss n))
    (setq OB (entget OB1))
;DIEU KIEN CHO TUNG DOI TUONG
  (COND
    ((EQ (cdr(assoc 0 OB)) "DIMENSION") 
           (entmod(subst(cons 3 DIMSTYLE)(assoc 3 OB) OB)))
    
    ((EQ (cdr(assoc 0 OB)) "LEADER") 
           (entmod(subst(cons 3 DIMSTYLE)(assoc 3 OB) OB)))
    
    ((EQ (cdr(assoc 0 OB)) "TEXT")
    	(IF (OR (eq (cdr(assoc 7 OB)) "ATAD drawing text") (eq (cdr(assoc 7 OB)) "Vni-helve"))
    	(entmod(subst(cons 40 (* 3.5 DIMSCALE)) (assoc 40 OB) OB))
    	(entmod(subst(cons 40 TEXTSIZE)(assoc 40 OB) OB))))
    
    ((EQ (cdr(assoc 0 OB)) "MTEXT")
    	(IF (OR (eq (cdr(assoc 7 OB)) "ATAD drawing text") (eq (cdr(assoc 7 OB)) "Vni-helve"))
	(entmod(subst(cons 40 (* 3.5 DIMSCALE)) (assoc 40 OB) OB))
    	(entmod(subst(cons 40 TEXTSIZE)(assoc 40 OB) OB))))
    
    ((EQ (cdr(assoc 0 OB)) "INSERT")
      (setq name (vlax-get-property(vlax-ename->vla-object OB1) 'effectivename)); lay ten co dau *
      (setq scale (vla-get-blockscaling (vla-item (vla-get-blocks(vla-get-activedocument(vlax-get-acad-object))) name )));kien tra block co scale uniform hay khong 0 1

      (setq TIENTO_BLOCK (substr name 1 4))
      (IF (eq TIENTO_BLOCK "ATAD")
	  (COND (( = 1 scale)		 
	    		(setpropertyvalue OB1 "ScaleFactors/UniformScale"  DIMSCALE))
		(( /= 1 scale)
			(setpropertyvalue OB1  "ScaleFactors/X"  (* DIMSCALE (/ (CDR(assoc 41 OB)) (ABS (CDR(assoc 41 OB))))))
		 	(setpropertyvalue OB1  "ScaleFactors/Y"  (* DIMSCALE (/ (CDR(assoc 42 OB)) (ABS (CDR(assoc 42 OB))))))
		 	(setpropertyvalue OB1  "ScaleFactors/Z"  (* DIMSCALE (/ (CDR(assoc 43 OB)) (ABS (CDR(assoc 43 OB))))))))))
    );DONG COND 	
    (setq n (+ n 1))
    );DONG REPEAT
    );DONG DEFUN
