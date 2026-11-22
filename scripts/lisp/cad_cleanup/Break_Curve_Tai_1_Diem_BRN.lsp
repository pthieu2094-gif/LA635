=============================
(defun c:brn (/ dt p1)
(setvar "cmdecho" 0)
	(princ "\nChon duong can break: ")
   (command ".break" pause "f" (setq p1 (getpoint "\nChon diem can break: ")) p1)
(princ)
)