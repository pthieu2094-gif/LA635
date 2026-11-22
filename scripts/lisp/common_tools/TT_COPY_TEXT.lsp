
;;;========== LISP MA TEXT ==========;;;
;;LENH TAT D1
;;; AUTHOR: THANH TRI;;;
(defun c:d1 (/ o1 o11 o111 ct1 typ ss1 ssl1 a o2 o222 ct2 newo1 a)
  (while
    (null(setq o1(car(entsel"\nSelect Text 1:"))))
    (alert "\nChon text chua duoc. Vui long chon lai text.")); vong lap neu chon doi tuong khong trung
  (setq o11(redraw o1 3))
  (setq o111 (entget o1))
  (setq ct1 (assoc 1 o111))
  (Setq typ (cons 0 "DIMENSION,TEXT,MTEXT"))
  (setq ss1 (ssget (list typ)))
  (setq ssl1 (sslength ss1))  
  (setq a 0)
  (WHILE (< a ssl1)
  (setq o2 (ssname ss1 a))
  (setq o222 (entget o2))
  (setq ct2 (assoc 1 o222))
  (setq newo1(subst ct1 ct2 o222))
  (entmod newo1)
  (setq a (+ 1 a)))
  (command "regen")
  (princ))
;;;THE END