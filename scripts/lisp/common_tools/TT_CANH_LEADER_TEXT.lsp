;LISP CANH TEXT VA LEADER
;LENH TAT ALR-CANH PHAI, ALL-CANH TRAI
;THANH TRI AUTOCAD REVIT
(defun c:alr(/ n)
  (setvar "CMDECHO" 0)
  (setq occho (getvar "osmode"))
 
(setq ss(ssget (list (cons 0 "LEADER,TEXT"))));chon doi tuong la leader
(setq p1 (getpoint "\nChon diem cuoi leader."))
 (setvar "osmode" 16384); tat che do bat diem
(setq ssl1 (sslength ss)) ;so luong leader duoc chon
(setq n 0)
(while (< n ssl1)  ;bat dau vong lap
(progn 
(setq o0 (ssname ss n));ma ename ua doi tuong
(setq o1 (entget o0));lay danh sach doi tuong de phan tich
(setq dt(cdr(assoc 0 o1))); kiem tra xem thuoc doi tuong gi?
  (cond
    ((= dt "LEADER");dieu kien neu la leader
       	(setq lst1 (reverse o1))
	(setq lst (assoc 10 lst1))
	(setq botoadox (cdr(cdr lst))); bo toa do x cua diem cuoi leader
	(setq toadox1(car p1)); lay toa do x cua diem chon
	(setq toadodiem1 (append (list toadox1) botoadox)); toa do diem thay doi
	(setq lst2 (subst (cons 10 toadodiem1) lst lst1))
	(setq lts3 (reverse lst2))
	(entmod lts3)
     );dong dieu kien leader
    ((= dt "TEXT")
        (setq pt1 (cdr(assoc 10 o1)));lay toa do diem chen text
        (setq botoadoxpt1 (cdr pt1)); bo toa do x cua diem cuoi leader
	(setq toadox1(car p1)); lay toa do x cua diem chon
	(setq pt2 (append (list toadox1) botoadoxpt1))
        (setq LTEXT(car(car(cdr(textbox o1)))))
        (setq pt3 (polar pt2 pi LTEXT))
    	(command "JUSTIFYTEXT" o0 "" "Right")
        (command "move" o0 ""pt1 pt3)
        );dong dieu kien text
    );dong ham cond
(setq n (+ n 1)))); ket thuc vong lap
(setvar "osmode" occho); bat lai che do bat diem
(princ)
);ket thuc chuong trinh

;;;;;;;;;;;;;;;;;
(defun c:all()
  (setvar "CMDECHO" 0)
  (setq occho (getvar "osmode"))
  
(setq ss(ssget (list (cons 0 "LEADER,TEXT"))));chon doi tuong la leader
(setq p1 (getpoint "\nChon diem cuoi leader."))
(setvar "osmode" 16384); tat che do bat diem
(setq ssl1 (sslength ss)) ;so luong leader duoc chon
(setq n 0)
(while (< n ssl1)  ;bat dau vong lap  ;bat dau vong lap
(setq o0 (ssname ss n));ma ename ua doi tuong
(setq o1 (entget o0));lay danh sach doi tuong de phan tich
(setq dt(cdr(assoc 0 o1))); kiem tra xem thuoc doi tuong gi?
  (cond
    ((= dt "LEADER");dieu kien neu la leader
       	(setq lst1 (reverse o1))
	(setq lst (assoc 10 lst1))
	(setq botoadox (cdr(cdr lst))); bo toa do x cua diem cuoi leader
	(setq toadox1(car p1)); lay toa do x cua diem chon
	(setq toadodiem1 (append (list toadox1) botoadox)); toa do diem thay doi
	(setq lst2 (subst (cons 10 toadodiem1) lst lst1))
	(setq lts3 (reverse lst2))
	(entmod lts3)
     );dong dieu kien leader
    ((= dt "TEXT")
        (setq pt1 (cdr(assoc 10 o1)));lay toa do diem chen text
        (setq botoadoxpt1 (cdr pt1)); bo toa do x cua diem cuoi leader
	(setq toadox1(car p1)); lay toa do x cua diem chon
	(setq pt2 (append (list toadox1) botoadoxpt1))
        (command "JUSTIFYTEXT" o0 "" "Left")
        (command "move" o0 ""pt1 pt2)
     );dong dieu kien text
    );dong ham cond
(setq n (+ n 1))); ket thuc vong lap
(setvar "osmode" occho); bat lai che do bat diem
(princ)
);ket thuc chuong trinh

