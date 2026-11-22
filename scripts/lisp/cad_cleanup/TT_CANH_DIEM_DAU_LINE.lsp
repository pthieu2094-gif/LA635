;LISP BANG LINE, POLINE
;THANH TRI AUTOCAD
;LENH TAT BLB: BANG LINE THEO PHUONG Y BEN DUOI
;LENH TAT BLT: BANG LINE THEO PHUONG Y BEN TREN
;LENH TAT BLL: BANG LINE THEO PHUONG X BEN TRAI
;LENH TAT BLL: BANG LINE THEO PHUONG X BEN PHAI
(defun c:BLB(/ list1 ss1 p1 y ssl1 a o2 p10)  
  (setq list1 (list))
  (setq ss1(ssget (list (cons 0 "LINE,LWPOLYLINE,POLYLINE")))) ;CHON LINE, POLYLINE
  (setq p1(getpoint "\nPick Point to align."))
  (setq y(cadr p1))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1    
  (setq o2 (entget(ssname ss1 a)))
  (cond
    ((= (cdr(assoc 0 o2)) "LINE")
  		(setq p2 (cdr(assoc 11 o2)))
  		(setq p3 (cdr(assoc 10 o2)))
  		(if (< (cadr p2) (cadr p3))
		(setq x(car p2))
		(setq x(car p3)))
     		(setq p10 (list x y 0))
     		(if (< (cadr p2) (cadr p3))
		(entmod(subst (cons 11 p10) (assoc 11 o2) o2))
		(entmod(subst (cons 10 p10) (assoc 10 o2) o2)))))
  (setq a (+ 1 a)))) ; KET THUC VONG LAP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:BLT(/ list1 ss1 p1 y ssl1 a o2 p10)  
  (setq list1 (list))
  (setq ss1(ssget (list (cons 0 "LINE,LWPOLYLINE,POLYLINE")))) ;CHON LINE, POLYLINE
  (setq p1(getpoint "\nPick Point to align."))
  (setq y(cadr p1))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1    
  (setq o2 (entget(ssname ss1 a)))
  (cond
    ((= (cdr(assoc 0 o2)) "LINE")
  		(setq p2 (cdr(assoc 11 o2)))
  		(setq p3 (cdr(assoc 10 o2)))
  		(if (< (cadr p2) (cadr p3))
		(setq x(car p2))
		(setq x(car p3)))
     		(setq p10 (list x y 0))
     		(if (< (cadr p2) (cadr p3))
		(entmod(subst (cons 10 p10) (assoc 10 o2) o2))
		(entmod(subst (cons 11 p10) (assoc 11 o2) o2)))))      
  (setq a (+ 1 a)))) ; KET THUC VONG LAP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:BLL(/ list1 ss1 p1 y ssl1 a o2 p10)   
  (setq list1 (list))
  (setq ss1(ssget (list (cons 0 "LINE,LWPOLYLINE,POLYLINE")))) ;CHON LINE, POLYLINE
  (setq p1(getpoint "\nPick Point to align."))
  (setq x(car p1))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1    
  (setq o2 (entget(ssname ss1 a)))
  (cond
    ((= (cdr(assoc 0 o2)) "LINE")
  		(setq p2 (cdr(assoc 11 o2)))
  		(setq p3 (cdr(assoc 10 o2)))
  		(if (< (car p2) (car p3))
		(setq y(cadr p2))
		(setq y(cadr p3)))
     		(setq p10 (list x y 0))
     		(if (> (car p2) (car p3))
		(entmod(subst (cons 10 p10) (assoc 10 o2) o2))
		(entmod(subst (cons 11 p10) (assoc 11 o2) o2))))) 
  (setq a (+ 1 a)))) ; KET THUC VONG LAP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:BLR(/ list1 ss1 p1 y ssl1 a o2 p10)   
  (setq list1 (list))
  (setq ss1(ssget (list (cons 0 "LINE,LWPOLYLINE,POLYLINE")))) ;CHON LINE, POLYLINE
  (setq p1(getpoint "\nPick Point to align."))
  (setq x(car p1))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (repeat ssl1    
  (setq o2 (entget(ssname ss1 a)))
  (cond
    ((= (cdr(assoc 0 o2)) "LINE")
  		(setq p2 (cdr(assoc 11 o2)))
  		(setq p3 (cdr(assoc 10 o2)))
  		(if (< (car p2) (car p3))
		(setq y(cadr p2))
		(setq y(cadr p3)))
     		(setq p10 (list x y 0))
     		(if (< (car p2) (car p3))
		(entmod(subst (cons 10 p10) (assoc 10 o2) o2))
		(entmod(subst (cons 11 p10) (assoc 11 o2) o2)))))      
  (setq a (+ 1 a)))) ; KET THUC VONG LAP