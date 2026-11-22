;;;----------------------------------------------------------------------------;
(defun c:FF () (command "FILTER"))
(defun c:ffd () (sssetfirst nil (ssget (list (cons 0 "DIMENSION")))))
(defun c:fft () (sssetfirst nil (ssget (list (cons 0 "text,MTEXT")))))
(defun c:ffh () (sssetfirst nil (ssget (list (cons 0 "hatch")))))
(defun c:ffb () (sssetfirst nil (ssget (list (cons 0 "insert")))))
(defun c:ffv () (setvar "TILEMODE" 0) (sssetfirst nil (ssget (list (cons 0 "VIEWPORT")))))