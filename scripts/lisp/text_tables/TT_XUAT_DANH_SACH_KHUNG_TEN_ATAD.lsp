
;HAM XAC DINH CHIEU RONG CUA TEXT
 (defun TxtWidth (val msp / txt minp maxp)
   (vla-getBoundingBox (setq txt (vla-AddText msp val (vlax-3d-point '(0 0 0)) 2.2)) 'minp 'maxp)
   (vla-Erase txt)
   (-(car(vlax-safearray->list maxp))(car(vlax-safearray->list minp))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;HAM SAP XEP KI TU
  (defun TT:SAPXEPKYTU ( l ) 
   (car(vl-sort l (function (lambda (a b) (> (strlen a)(strlen b)))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;HAM LAY GIA TRI ATT
(defun LM:vl-getattributevalues1 ( blk )
    (mapcar '(lambda ( att )  (LIST(vla-get-tagstring att) (vla-get-textstring att)(vlax-safearray->list(vlax-variant-value(vla-get-insertionpoint att))))) (vlax-invoke blk 'getattributes)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;HAM SAP XEP GIA TRI ATT
(defun TT:SAPXEPATT ( l ) 
   (vl-sort l (function (lambda (a b) (< (car(nth 2(car a)))(car(nth 2(car b))))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;LENH CHINH
(defun c:EAT1 (/ ss1 le)
  (vl-load-com)
  (setq name (cdr(assoc 2 (entget(car(entsel "Select BLOCK"))))))		;CHON BLOCK
  (setq LT3 (list "DWG.NO" "DRAWING_NAME" "REV." "DATE"))
  (setq lengatt (length lt3))  							;SO LUONG ATT
  (setq ss1 (ssget "X" (list (cons 0 "INSERT")(cons 2 name))))			;CHON TAT CA BLOCK ATT
  (setq lengss (sslength ss1))							;SO LUONG BLOCK ATT DUOC CHON
  (setq n 0)
  (setq lt1 (list))								;TAO DANH SACH RONG
  (setq lt5 (list))								;TAO DANH SACH RONG CHUA GIA TRI ATT
  
(REPEAT lengss									;VONG LAP REPEAT
  (setq a( vlax-ename->vla-object (ssname ss1 n)))
  (setq b(list (LM:vl-getattributevalues1  a)))					;LAY GIA TRI CUA CAC ATT
  (setq lt1 (append b lt1))							;CONG DON CAC GIA TRI ATT VAO LT1
  (setq n (+ n 1)))								;DONG HAM REPEAT
  (setq lt2(TT:SAPXEPATT lt1))							;DANH SACH DA SAP XEP GIA TRI ATT THEO STT
  

;;TAO DANH SACH CHUA CAC GIA TRI ATT DE LAY TEXT DAI NHAT GAN CHO BANG TABLE  
  (setq lengattLlt2 (length (NTH 0 lt2)))					;SO LUONG ATT TRONG DANH SACH DA SAP XEP
  (SETQ n10 0)
  (SETQ DS1 (LIST))								;TAO DANH SACH RONG
  (SETQ DS2 (LIST))								;TAO DANH SACH RONG
  
(REPEAT lengattLlt2								;VONG LAP REPEAT
  (FOREACH x1 lt2
    (SETQ NAME10 (CAR (NTH n10 x1)))
    (SETQ DS1(APPEND (LIST (CADR (NTH n10 x1))) DS1)))
    (SETQ DS1(TT:SAPXEPKYTU DS1))						;LOC RA TEXT CO NOI DUNG DAI NHAT  
    (SETQ DS1A (LIST(CONS NAME10 DS1)))						;VI DU DANH SACH ("SCALE" . "TEXT DAI NHAT")  
    (SETQ DS2 (APPEND DS1A DS2))  
    (SETQ DS1 (LIST))
    (SETQ N10 (+ n10 1)))							;KET THUC REPEAT CO DANH SACH DS2 VOI TEXT DAI NHAT
  										;(("DWG.NO" . "02")
  										;("DRAWING_NAME" . "GROUND PLAN 123123123")
  										;("SCALE" . "1231232131231232312")) 

;XAC DINH DANG O LAYOUT HAY MODEL 
  (IF (=(GETVAR"TILEMODE")0)
  	(setq msp (vla-get-paperspace (vla-get-activedocument (vlax-get-acad-object))))
    	(setq msp (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (setq pt (getpoint "\nPick InsertPoint For Table:"))					;DIEM DAT BANG TABLE
  (setq	TblObj (vla-addtable msp (vlax-3d-point pt) (+ (length lt2) 2) lengatt 5 15)) 	;CAI DAT BANG LUC DAU "TblObj"  
  (vla-put-regeneratetablesuppressed TblObj :vlax-true)					;TAT TAI TAO BANG
  (vla-put-vertcellmargin TblObj (* 0.25 2))
  (vla-put-horzcellmargin TblObj (* 0.75 2))
  
;CAI DAT CHIEU RONG CUA CAC COT ATT
  (vla-SetColumnWidth TblObj 0 17)
  (vla-SetColumnWidth TblObj 1 112)
  (vla-SetColumnWidth TblObj 2 11)
  (vla-SetColumnWidth TblObj 3 22)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;CAI DAT CHIEU CAO CHU CUA TITLE HEADER DATA
  (vla-setTextHeight TblObj actitlerow 3.5)
  (vla-setTextHeight TblObj acHeaderRow 2.2)
  (vla-setTextHeight TblObj acdataRow 2)
;CAI DAT CANH LE CHO TITLE HEADER DATA
  (vla-setAlignment TblObj actitlerow 5)
  (vla-setAlignment TblObj acHeaderRow 5)
  (vla-setAlignment TblObj acDataRow 5)
;NOI DUNG TITLE & HEADER
  (vl-catch-all-error-p (vl-catch-all-apply (function(lambda () (vla-MergeCells TblObj 0 0 0 2)) )))
  (vla-setText TblObj 0 0 "DRAWING LIST")  
  (vla-setText TblObj 1 0  "DWG No.")
  (vla-setText TblObj 1 1  "DRAWING NAME")
  (vla-setText TblObj 1 2  "REV.")
  (vla-setText TblObj 1 3  "DATE")
;GAN GIA TRI ATT VAO BANG;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
(setq row 2 )
(setq n1 0)
(foreach e lt2
  (repeat lengatt
  	(foreach e1 e
  		(COND ((= (nth n1 LT3) (car e1))	 
  			(vla-setText TblObj row n1  (cadr e1)))))
  (setq n1 ( + n1 1)))
  (setq n1 0)  
  (setq  row (+ 1 row)))
  

;BAT TAI TAO BANG  
  (vla-put-regeneratetablesuppressed TblObj :vlax-false)
  (vlax-release-object TblObj)	  
  (princ)
 	);THE END

