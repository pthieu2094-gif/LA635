;;; Lisp ve them duong leader tu duong leader co san
;;; Lenh tat AD1
;;; THANH TRI AUTOCAD REVIT
(defun c:AD1()
  (setvar "CMDECHO" 0)
  (setq osm (getvar "osmode"))
  (setq ob1(entget(car(entsel"\nPick 1 LEADER."))))
  (setq pt2(cdr(nth 19 ob1)))
  (setq pt3(cdr(nth 20 ob1)))
  (setq pt1(getpoint pt2"\nFirst point new LEADER."))
  (command "clayer" "21 Dim")
  (command "leader" pt1 pt2 pt3 "" "" "N")
    (while
    	(setq pt1(getpoint"\nNext point new LEADER (or ENTER to exit)"))
    	(command "leader" pt1 pt2 pt3 "" "" "N")
    );;ket thuc vong lap
  (command "clayer" "31 Drawing")
  (setvar "osmode" osm)
  (princ)
  )
;;;;;