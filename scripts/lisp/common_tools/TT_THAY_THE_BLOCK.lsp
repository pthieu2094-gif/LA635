;;LISP THAY THE BLOCK
;;THANH TRI AUTOCAD
(defun c:TTB(/ list1 ss ssl1 o0 o1 point)
  (vl-load-com)
  (setvar "CMDECHO" 0)
  (setq occho (getvar "osmode"))
  (while
    	(null(setq DT1(car(entsel"\nChon Block Se Thay The"))))
    	(alert "\nChon Block chua duoc. Vui long chon lai Block.")); vong lap neu chon doi tuong khong trung
  (setq name (vlax-get-property(vlax-ename->vla-object DT1) 'effectivename)); lay ten co dau *
  (setq scale (vla-get-blockscaling (vla-item (vla-get-blocks(vla-get-activedocument(vlax-get-acad-object))) name )));kien tra block co scale uniform hay khong 0 1
  (while
    	(null(setq DT2(car(entsel"\nChon Block Duoc Thay The"))))
    	(alert "\nChon Block chua duoc. Vui long chon lai Block.")); vong lap neu chon doi tuong khong trung
  (setq name1(cdr(assoc 2 (entget DT2))))
  (setq ss(ssget (list (cons 0 "INSERT"))));chon doi tuong la block
  (setq ssl1 (sslength ss)) ;so luong block duoc chon
  (setq list1 (list))
  (setq n 0)
  (repeat ssl1
  	(setq o0 (ssname ss n));ma ename ua doi tuong
  	(setq o1 (entget o0));lay danh sach doi tuong de phan tich
    	(setq o2 (cdr(assoc 2 o1)))
    	(if ( = name1 o2)
		(progn
  			(setq point(cdr(assoc 10 o1)))
  			(setq list1 (append point list1))
		  	(setq goc (* (/ 180 pi) (cdr(assoc 50 o1)))) ; lay goc quay cua block
		  	(setq scale1 (cdr(assoc 41 o1))) ; lay ti le scale
		  	(setq scale2 (cdr(assoc 42 o1))) ; lay ti le scale
		  	(if ( = 1 scale )(command "-insert" name point scale1 goc);SACLE UNIFORM
		  	(command "-insert" name point scale1 scale2 goc));SACLE NO UNIFORM
		  	(setq n (+ n 1)))
    		(progn(ssdel o0 ss))));
  (command "erase" ss "")
  (princ))
  