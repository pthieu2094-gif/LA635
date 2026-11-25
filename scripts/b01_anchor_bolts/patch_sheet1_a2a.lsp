(vl-load-com)
(defun c:PatchSheet1A2A ( / acadDoc mSpace safeSetLayer mkRoundRect insHexTag delOldNear getBlkName)
  (setq acadDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq mSpace (vla-get-ModelSpace acadDoc))

  (defun safeSetLayer (obj lyr)
    (if (and lyr (tblsearch "LAYER" lyr))
      (vl-catch-all-apply 'vla-put-Layer (list obj lyr))
    )
  )

  (defun mkRoundRect (minx miny maxx maxy r lyr c lt lts / pts arr pObj)
    (setq pts (list
      (+ minx r) miny
      (- maxx r) miny
      maxx (+ miny r)
      maxx (- maxy r)
      (- maxx r) maxy
      (+ minx r) maxy
      minx (- maxy r)
      minx (+ miny r)
    ))
    (setq arr (vlax-make-safearray vlax-vbDouble '(0 . 15)))
    (vlax-safearray-fill arr pts)
    (setq pObj (vla-AddLightWeightPolyline mSpace arr))
    (vla-put-Closed pObj :vlax-true)
    (vla-SetBulge pObj 1 0.41421356)
    (vla-SetBulge pObj 3 0.41421356)
    (vla-SetBulge pObj 5 0.41421356)
    (vla-SetBulge pObj 7 0.41421356)
    (safeSetLayer pObj lyr)
    (if c (vla-put-Color pObj c))
    (if lt (vla-put-Linetype pObj lt))
    (if lts (vla-put-LinetypeScale pObj lts))
    pObj
  )

  (defun insHexTag (pt tag / blkRef atts)
    (setq blkRef (vla-InsertBlock mSpace (vlax-3d-point pt) "QHP_AnchorBolt_Tag_2022" 150.0 150.0 150.0 0.0))
    (safeSetLayer blkRef "0")
    (if (and (= (vla-get-HasAttributes blkRef) :vlax-true)
             (setq atts (vlax-invoke blkRef 'GetAttributes)))
      (vla-put-TextString (car atts) tag)
    )
    blkRef
  )

  (defun getBlkName (obj / bName)
    (setq bName (vl-catch-all-apply 'vla-get-EffectiveName (list obj)))
    (if (vl-catch-all-error-p bName)
      (setq bName (vla-get-Name obj))
    )
    bName
  )

  ;; Delete old boundary polylines and tags near I/1 and I/8
  (defun delOldNear (cx cy / ss i ent obj bName)
    (setq ss (ssget "C" (list (- cx 1500.0) (- cy 1500.0) 0.0) (list (+ cx 3000.0) (+ cy 1500.0) 0.0)))
    (if ss
      (repeat (setq i (sslength ss))
        (setq ent (ssname ss (setq i (1- i))))
        (setq obj (vlax-ename->vla-object ent))
        (cond
          ;; Polyline boundary (dashed)
          ((= (vla-get-ObjectName obj) "AcDbPolyline")
           (vla-Delete obj)
           (princ "\nDeleted old boundary polyline")
          )
          ;; Hex tag block
          ((= (vla-get-ObjectName obj) "AcDbBlockReference")
           (setq bName (getBlkName obj))
           (if (wcmatch (strcase bName) "*QHP_ANCHORBOLT_TAG*")
             (progn
               (vla-Delete obj)
               (princ "\nDeleted old hex tag")
             )
           )
          )
        )
      )
    )
  )

  (princ "\nDeleting old tags/boundaries at I/1 & I/8...")
  (delOldNear 419692.16 0.0)
  (delOldNear 419692.16 36400.0)

  (princ "\nAdding new A2A boundaries (Color 150 - Spring Green) & A2A tags...")
  ;; At I/1
  (mkRoundRect (- 419692.16 800.0) (- 0.0 800.0) (+ 419692.16 800.0) (+ 0.0 800.0) 300.0 nil 150 "DASHED" 300.0)
  (insHexTag (list (+ 419692.16 2000.0) 0.0 0.0) "A2A")

  ;; At I/8
  (mkRoundRect (- 419692.16 800.0) (- 36400.0 800.0) (+ 419692.16 800.0) (+ 36400.0 800.0) 300.0 nil 150 "DASHED" 300.0)
  (insHexTag (list (+ 419692.16 2000.0) 36400.0 0.0) "A2A")

  (princ "\n*** SHEET 1 A2A SYNCHRONIZED SUCCESSFULLY ***\n")
  (princ)
)
(c:PatchSheet1A2A)
