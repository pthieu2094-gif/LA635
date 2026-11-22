
(defun hien ( / SelSet ST:VP-Toggle-DisplayLocked) ;VP toggle Locked
;======== Local Function =========
(defun ST:VP-Toggle-DisplayLocked (vpObj / rt)
;vp : vlaObject
;RT : T if Lock VP / nil if Open
(cond ((eq (vla-get-DisplayLocked vpObj) :vlax-false)(vla-put-DisplayLocked vpObj :vlax-true)(setq rt T)(vla-put-color vpObj acWhite))
		(T (vla-put-DisplayLocked vpObj :vlax-False)(vla-put-color vpObj acByLayer)))
)
;========== Start Here ==============
(grtext -1 "Free Lisp from Cadviet @Ketxu")
 (cond
  ((< (atof (getvar "ACADVER")) 15.0)
   (alert " Lisp requires AutoCAD 2000 or higher. "))
  ((= (getvar "TILEMODE") 1)   
   (alert " Lisp can only be done in paper space. "))
  ((> (getvar "CVPORT") 1)
   (ST:VP-Toggle-DisplayLocked (vlax-ename->vla-object (acet-currentviewport-ename))))
  ((and
    (not (prompt "\nSelect Viewport for (un)lock... "))
    (not (setq SelSet (ssget '((0 . "VIEWPORT"))))))
   (princ "Nothing or no Viewport selected."))
  (T
   (vl-load-com)
   (vlax-for vpObj (setq SelSet (vla-get-ActiveSelectionSet (vla-get-ActiveDocument (vlax-get-acad-object))))
	 (ST:VP-Toggle-DisplayLocked vpObj)	 
    )))
 (princ)
)
(defun c:Z()
  (setq p1(getpoint "First point"))
  (setq p2(getcorner p1"Second point"))
  (command "zoom" p1 p2)
  (setvar "ltscale" 3)
  (command "regen")
(hien)
  (command "_.PSPACE")
  
  (princ))