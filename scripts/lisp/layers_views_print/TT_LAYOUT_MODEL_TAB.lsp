(defun c:MM()
  (setq a(getvar "tilemode"))
  (if (= a 1)(command "tilemode" 0)(command "tilemode" 1)))