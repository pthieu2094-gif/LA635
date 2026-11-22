(defun c:TAG()
  (setq occho1(getvar "dimscale"))
  (setvar "MLEADERSCALE" occho1)
  (setq p1(getpoint "First point"))
  (setvar "ORTHOMODE" 0)
  (setq p2(getpoint p1"Second point"))
  (setvar "ORTHOMODE" 1)
  (command "mleader" p2 p1));;;;;