;;;========== LISP TAO DIM ATAD ==========;;;
;;; AUTHOR: THANH TRI;;;
(defun _SetDimStyleCurrent (dim / acdoc) ;ham setdimtype
 	(vl-load-com)
 	(setq acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
 	(if (tblsearch "DIMSTYLE" dim)
   	(vla-put-activeDimstyle    acdoc
     	(vla-item (vla-get-Dimstyles acdoc) dim)   ) )
 	(princ)
	);DONG HAM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:DS ()
(setq tlc (cond (tlc) ("1")))
	(initget 1)
	(setq tlc (cond ((getstring (strcat "Drawing Scale: <"tlc">"))) (tlc)))
(setvar "textstyle" "VNI")
(setvar "textsize" 1.46)
(setq sc (strcat "ATAD1-" tlc))
(setq tls (distof tlc))
(command "-dimstyle" "" "ATAD1-1")
(setvar "dimscale" tls)
(if	(tblsearch "dimstyle" sc)
        (_SetDimStyleCurrent sc)
	(command "-dimstyle" "s" sc))
(setq a (getvar "dimtxt"))
(setq b (getvar "dimtxsty"))
(setq c (getvar "dimscale")) 
(setvar "textsize" (* a c))
(setvar "textstyle" b)
(princ))
