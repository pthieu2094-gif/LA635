 (defun TxtWidth (val msp / txt minp maxp)
  (setq txt (VLAX-VLA-OBJECT->ENAME (vla-AddText msp val (vlax-3d-point '(0 0 0)) 2)))
  (abs(- (car(car(TEXTBOX (ENTGET TXT)))) (car(cadr(TEXTBOX (ENTGET TXT)))))))
  (defun TT:SAPXEPKYTU ( l ) 
   (car(vl-sort l (function (lambda (a b) (> (strlen a)(strlen b)))))))
;HAM LAY GIA TRI ATT
(defun LM:vl-getattributevalues1 ( blk )
    (mapcar '(lambda ( att )  (LIST(vla-get-tagstring att) (vla-get-textstring att)(vlax-safearray->list(vlax-variant-value(vla-get-insertionpoint att))))) (vlax-invoke blk 'getattributes)))
;HAM SAP XEP GIA TRI ATT
(defun TT:SAPXEPATT ( l ) 
   (vl-sort l (function (lambda (a b) (< (car(nth 2(car a)))(car(nth 2(car b))))))))

;LENH CHINH
(defun c:eatt (/ ss1 le)
  (vl-load-com)
  (setq name (cdr(assoc 2 (entget(car(entsel "Select BLOCK"))))))	;CHON BLOCK
  (setq lt3 (list))							;CHON ATT THEO THU TU
  (while (setq ob1(nentsel "Select ATT"))
         (setq attname (assoc 2(entget(car ob1))))
    	 (setq lt3 (append (list attname) lt3)))
  (setq lt3 (reverse lt3))				;danh sach chua ten bien ATT
  (setq lengatt (length lt3))  
  (setq ss1 (ssget "X" (list (cons 0 "INSERT")(cons 2 name))))
(setq lengss (sslength ss1))
(setq n 0)
(setq lt1 (list))
  (setq lt5 (list))			;danh sach chua gia tri att
(REPEAT lengss
(setq a( vlax-ename->vla-object (ssname ss1 n)))
(setq b(list (LM:vl-getattributevalues1  a)))
;(setq c1 (list (TT:ATTVALUES a)))	;gia tri att
;(setq lt5 (append c1 lt5))  
(setq lt1 (append b lt1))
(setq n (+ n 1)))
(setq lt2(TT:SAPXEPATT lt1))
;;TAO DANH SACH CHUA CAC GIA TRI ATT DE LAY TEXT DAI NHAT GAN CHO BANG TABLE  
  (setq lengattLlt2 (length (NTH 0 lt2)))	;DIEM SO LUONG ATT TRONG BLOCK
  (SETQ n10 0)
  (SETQ DS1 (LIST))
  (SETQ DS2 (LIST))
  (REPEAT lengattLlt2
  (FOREACH x1 lt2
    (SETQ NAME10 (CAR (NTH n10 x1)))
    (SETQ DS1(APPEND (LIST (CADR (NTH n10 x1))) DS1)))
    (SETQ DS1(APPEND (list NAME10) DS1))
    (SETQ DS1(TT:SAPXEPKYTU DS1))
    (SETQ DS1A (LIST(CONS NAME10 DS1)))			;DANH SACH ("SCALE" . "ABCD")
    (SETQ DS2 (APPEND DS1A DS2))
    (SETQ DS1 (LIST))
    (SETQ N10 (+ n10 1)));;KET THUC REPEAT CO DANH SACH DS2 (("DWG.NO" . "02") ("DRAWING_NAME" . "GROUND PLAN 123123123") ("SCALE" . "1231232131231232312")) 

  
  (IF (=(GETVAR"TILEMODE")0)
  (setq msp (vla-get-paperspace (vla-get-activedocument (vlax-get-acad-object))))
    (setq msp (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))))
  (setq pt (getpoint "\nDiem dat Bang :")
	TblObj (vla-addtable msp (vlax-3d-point pt) (+ (length lt2) 2) lengatt 5 15)) 	;CAI DAT BANG LUC DAU
  (vla-put-regeneratetablesuppressed TblObj :vlax-true)		;TAT TAI TAO BANG
  (vla-put-vertcellmargin TblObj (* 0.25 2))
  (vla-put-horzcellmargin TblObj (* 0.75 2))
;CAI DAT CHIEU RONG CUA CAC COT
  (SETQ N11 0)
  (REPEAT lengatt
    (vla-SetColumnWidth TblObj N11 (+ 4 (TxtWidth (CDR(ASSOC (CDR(NTH N11 LT3)) DS2)) msp)))
    (setq N11 (+ N11 1)))			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CAI DAT CHIEU CAO CHU CUA TITLE HEADER DATA
  (vla-setTextHeight TblObj actitlerow 3.5)
  (vla-setTextHeight TblObj acHeaderRow 2.2)
  (vla-setTextHeight TblObj acdataRow 2)
;CAI DAT CANH LE CHO TITLE HEADER DATA
  (vla-setAlignment TblObj actitlerow 5)
  (vla-setAlignment TblObj acHeaderRow 5)
  (vla-setAlignment TblObj acDataRow 4)
;NOI DUNG TITLE & HEADER
  (vl-catch-all-error-p (vl-catch-all-apply (function(lambda () (vla-MergeCells TblObj 0 0 0 2)) )))
  (vla-setText TblObj 0 0 "DRAWING LIST")
  
  (setq num1 0)
  (REPEAT lengatt
  (vla-setText TblObj 1 num1  (cdr(nth num1 lt3)))
  (setq num1 (+ num1 1))) 
;GAN GIA TRI ATT VAO BANG;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
(setq row 2 )
(setq n1 0)
(foreach e lt2
  (repeat lengatt
  	(foreach e1 e
  		(COND ((= (cdr(nth n1 LT3)) (car e1))	 
  			(vla-setText TblObj row n1  (cadr e1)))))
  (setq n1 ( + n1 1)))
  (setq n1 0)
  
    (setq  row (+ 1 row)))
  

;BAT TAI TAO BANG  
  (vla-put-regeneratetablesuppressed TblObj :vlax-false)
  (vlax-release-object TblObj)	  
  (princ)
 	);THE END

;(entget(car(entsel)))