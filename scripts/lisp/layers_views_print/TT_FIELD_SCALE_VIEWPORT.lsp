(defun LM:setattributevalue ( blk tag val / end enx )
    (while
        (and
            (null end)
            (setq blk (entnext blk))
            (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
        )
        (if (= (strcase tag) (strcase (cdr (assoc 2 enx))))
            (if (entmod (subst (cons 1 val) (assoc 1 (reverse enx)) enx))
                (progn
                    (entupd blk)
                    (setq end val))))))

;INSERT FIELD TO ATT BLOCK
(defun c:FS()
  (vl-load-com)
  (setq src (nentsel "Select VIEWPORT"))
  (setq oSrc (vlax-ename->vla-object (car src)))
  (setq string (strcat "%<\\AcObjProp Object(%<\\_ObjId "  (itoa (vla-get-ObjectId oSrc))  ">%,1).CustomScale \\f "  "1:%lu2%ct1%qf2816>%"))
 ; (setq o01 (car(entsel "Select Block")))
  ;VONG LAP CHON DOI TUONG GOC
  (while (not (and
		(setq ent (car (nentsel "\nSelect ATT in Block:")))
		(if ent (eq (cdr (assoc 0 (entget ent))) "ATTRIB") ) ) )
  (princ "\n Ban chon nham roi! "))
  (setq blkName (cdr(assoc 330 (entget ent)))
	tagName (cdr (assoc 2 (entget ent))))
  (LM:setattributevalue blkName tagName string)
  (command "regen")
  (princ))
