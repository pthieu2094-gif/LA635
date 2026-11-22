;; Get Dynamic Block Property Value  -  Lee Mac
;; Returns the value of a Dynamic Block property (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)

(defun LM:getdynpropvalue ( blk prp )
    (setq prp (strcase prp))
    (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'value)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;;;-------------------------------------------------------------
;; Set Dynamic Block Property Value  -  Lee Mac
;; Modifies the value of a Dynamic Block property (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)
;; val - [any] New value for property
;; Returns: [any] New value if successful, else nil

(defun LM:setdynpropvalue ( blk prp val )
    (setq prp (strcase prp))
    (vl-some
       '(lambda ( x )
            (if (= prp (strcase (vla-get-propertyname x)))
                (progn
                    (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
                    (cond (val) (t))
                )
            )
        )
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Get Dynamic Block Properties  -  Lee Mac
;; Returns an association list of Dynamic Block properties & values.
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [lst] Association list of ((<prop> . <value>) ... )

(defun LM:getdynprops ( blk )
    (mapcar '(lambda ( x ) (cons (vla-get-propertyname x) (vlax-get x 'value)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Set Dynamic Block Properties  -  Lee Mac
;; Modifies values of Dynamic Block properties using a supplied association list.
;; blk - [vla] VLA Dynamic Block Reference object
;; lst - [lst] Association list of ((<Property> . <Value>) ... )
;; Returns: nil

(defun LM:setdynprops ( blk lst / itm )
    (setq lst (mapcar '(lambda ( x ) (cons (strcase (car x)) (cdr x))) lst))
    (foreach x (vlax-invoke blk 'getdynamicblockproperties)
        (if (setq itm (assoc (strcase (vla-get-propertyname x)) lst))
            (vla-put-value x (vlax-make-variant (cdr itm) (vlax-variant-type (vla-get-value x))))
        )
    )
)
;; Get Dynamic Block Property Allowed Values  -  Lee Mac
;; Returns the allowed values for a specific Dynamic Block property.
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)
;; Returns: [lst] List of allowed values for property, else nil if no restrictions

(defun LM:getdynpropallowedvalues ( blk prp )
    (setq prp (strcase prp))
    (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'allowedvalues)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Toggle Dynamic Block Flip State  -  Lee Mac
;; Toggles the Flip parameter if present in a supplied Dynamic Block.
;; blk - [vla] VLA Dynamic Block Reference object
;; Return: [int] New Flip Parameter value

(defun LM:toggleflipstate ( blk )
    (vl-some
       '(lambda ( prp / rtn )
            (if (equal '(0 1) (vlax-get prp 'allowedvalues))
                (progn
                    (vla-put-value prp (vlax-make-variant (setq rtn (- 1 (vlax-get prp 'value))) vlax-vbinteger))
                    rtn
                )
            )
        )
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)
;; Get Visibility Parameter Name  -  Lee Mac
;; Returns the name of the Visibility Parameter of a Dynamic Block (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [str] Name of Visibility Parameter, else nil

(defun LM:getvisibilityparametername ( blk / vis )  
    (if
        (and
            (vlax-property-available-p blk 'effectivename)
            (setq blk
                (vla-item
                    (vla-get-blocks (vla-get-document blk))
                    (vla-get-effectivename blk)
                )
            )
            (= :vlax-true (vla-get-isdynamicblock blk))
            (= :vlax-true (vla-get-hasextensiondictionary blk))
            (setq vis
                (vl-some
                   '(lambda ( pair )
                        (if
                            (and
                                (= 360 (car pair))
                                (= "BLOCKVISIBILITYPARAMETER" (cdr (assoc 0 (entget (cdr pair)))))
                            )
                            (cdr pair)
                        )
                    )
                    (dictsearch
                        (vlax-vla-object->ename (vla-getextensiondictionary blk))
                        "ACAD_ENHANCEDBLOCK"
                    )
                )
            )
        )
        (cdr (assoc 301 (entget vis)))
    )
)
;; Get Dynamic Block Visibility State  -  Lee Mac
;; Returns the value of the Visibility Parameter of a Dynamic Block (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [str] Value of Visibility Parameter, else nil

(defun LM:getvisibilitystate ( blk / vis )
    (if (setq vis (LM:getvisibilityparametername blk))
        (LM:getdynpropvalue blk vis)
    )
)
;; Set Dynamic Block Visibility State  -  Lee Mac
;; Sets the Visibility Parameter of a Dynamic Block (if present) to a specific value (if allowed)
;; blk - [vla] VLA Dynamic Block Reference object
;; val - [str] Visibility State Parameter value
;; Returns: [str] New value of Visibility Parameter, else nil

(defun LM:SetVisibilityState ( blk val / vis )
    (if
        (and
            (setq vis (LM:getvisibilityparametername blk))
            (member (strcase val) (mapcar 'strcase (LM:getdynpropallowedvalues blk vis)))
        )
        (LM:setdynpropvalue blk vis val)
    )
)
;;;;;-------------------------------------
;;;;;;;;;;
;;;;;;;;;;
(defun hrail ( p1 p2 / p1 p2 p3 p4 p5 d1 angle1 b1 d3 d2 c c1 c3)
;(setvar "cmdecho" 0)
;(setq occho (getvar "osmode"))
  ;(setvar "ORTHOMODE" 0)
  (setq	p3 (polar p1 (/ pi 2) 900)
	p4 (polar p1 (/ pi 2) 300)
	p5 (polar p1 (/ pi 2) 600)
	d1 (distance p1 p2)
	angle1 (angle p1 p2))
  (if (equal angle1 0)(setq p3 (polar p1 (/ pi 2) 1100)));dieu kien cho handrail 1100
  (if (equal angle1 0)(setq p5 (polar p1 (/ pi 2) 700)));dieu kien cho handrail 1100
  (if (equal angle1 0)(setq p4 (polar p1 (/ pi 2) 350)));dieu kien cho handrail 1100
  (if (equal angle1 pi)(setq p3 (polar p1 (/ pi 2) 1100)));dieu kien cho handrail 1100
  (if (equal angle1 pi)(setq p5 (polar p1 (/ pi 2) 700)));dieu kien cho handrail 1100
  (if (equal angle1 pi)(setq p4 (polar p1 (/ pi 2) 350)));dieu kien cho handrail 1100
  
  (if (> angle1 (/ pi 2))(setq angle1 (+ pi angle1)))
        (setq b1 (cos angle1))
  (if (< b1 0)(setq b1 (* -1 b1)))
	(setq d3 (* b1 d1)
	max1000 (/ d3 1000)
	sigment(fix max1000)
	max10001 (- max1000 sigment))
  (if (eq max10001 0)(setq a (+ 1 sigment))(setq a (+ 2 sigment)))
  (setq d2 (/ d1 a))
  ;(setvar "osmode" 16384)
  (command "clayer" "36 tole")
  
  (command "line" p1 p3"") ;line dung
  (setq c (entlast));line dung
  (command "clayer" "35 Border (light wide)")
  (command "line" p1 p2"");line ngang
  (setq c1 (entlast));line ngang
  (command "copy" c""  p1 "A" a "F" p2)
  (initcommandversion)
  (command "copy" c1 ""  p1 p4 p5 p3"")
  (setq c3 (entlast))
  (command "MATCHPROP" c c3"")
  (command "erase" c1 "")
  (command "clayer" "31 drawing"))
  ;(setvar "ORTHOMODE" 1)
 ; (setvar "osmode" occho))
;;;;;;;;;;
(defun c:cc (/ sobacsinh)
  (initcommandversion)
  (setvar "cmdecho" 0)
  (setq occho (getvar "osmode"))
  (setq heightfloor (getreal "Nhap chieu cao tang"))
  (setq sobacsinh 5)
  (setq heightstep (/ heightfloor sobacsinh))
  (while (> heightstep 180)  
  (setq heightstep (/ heightfloor sobacsinh))
  (setq sobacsinh (+ sobacsinh 4)))
  (setq sobacsinh (- sobacsinh 4))
  (setq landing (+ (/ sobacsinh 2) 1)) ;chieu nghi
  (setq bacconlai (- sobacsinh landing 1))
  (setq widthstep (getreal "Nhap chieu rong bac thang"))
  (setq LLANGDING (getreal "Nhap chieu dai chieu nghi"))
  (setq pt1 (getpoint "Nhap diem dat cau thang"))
  (setvar "osmode" 16384)
  (setq pt2 (polar pt1 0 widthstep))
  (setq pt3 (polar pt2 (/ pi 2) heightstep)); toa do bac thu nhat
  (setq pt22 (polar pt2 pi 25))
  (setq pt222 (polar pt22 0 250)); line srtinger bulong chan 
  (command "-insert" "STEP STAIR" pt1 1 0 0)
  (setq o1 (entlast))
  (setq vlao1 (vlax-ename->vla-object o1))
  (LM:setdynpropvalue vlao1 "L" (+ widthstep 20));;; set gia tri chieu rong bac thang vao block
  (command "copy" o1"" pt1 "A" (+ landing 1) pt3)
  (command "erase" o1 "")  
  (setq o02 (entlast)) ;chieu nghi
  (setq o3 (entget o02))
  (setq o33 (assoc 10 o3))
  (setq  o3331 (cdr o33)); toa do chieu nghi
  (setq  o333 (polar o3331 (/ pi -2) 5)); toa do chieu nghi
  (setq goc1 (angle pt1 pt3)); goc stringer
  (setq v1(polar o3331 (+ (- (/ pi 2) goc1) goc1) (/ 25 (cos goc1)))) ; diem tren handrail duoi
  (setq  o3333 (polar o333 0 LLANGDING)); chieu dai chieu nghi stringer
  (setq t1 (polar o3333 (/ pi -2) 250)); stringger 250
 
  (command "line" o3333 o333"")
  (setq o8 (entlast))
  (command "line" pt22 pt222"")
  (command "line" o3331 pt3"")
  (setq o4 (entlast)); line xeo
  (setq pt6 (polar pt2 (/ pi 2) 500)) ; diem ofset  
  (command "line" pt3 pt2"")
  (setq o5 (entlast)); line thang
  (command "offset" 25 o4 pt6"")
  (setq o6 (entlast)); line xeo
  (setq o66 (entget o6))
  (setq o666 (assoc 10 o66)); diem dau
  (setq p01 (cdr o666))
  (setq o667 (assoc 11 o66)); diem cuoi
  (setq p02 (cdr o667))
  (hrail p02 v1); HANDRAIL DUOI
  (command "offset" 25 o5 pt1"")
  (setq o7 (entlast)); line thang
  (command "erase" o4 o5 "")
  (command "FILLETRAD" 0)
  (command "fillet" o6"" o7)
  (command "fillet" o6"" o8)
  (command "PEDIT" "M" o7 o6 o8"" "Y" "J" 0 "")
  (setq o9 (entlast))
  (command "offset" 250 o9 pt3"")  
  (command "offset" 13 o9 pt3"")
  (command "offset" 237 o9 pt3"")
  (command "line" o3333 t1"")
  (setq pt11 (polar pt1 (/ pi 2) heightstep))
  (command "copy" o02"" pt1 pt11)
  (setq o2 (entlast))
  (setq o22 (entget o2))
  (setq o222 (assoc 10 o22))
  (setq  o2222 (cdr o222)); toa do bac thang tren chieu nghi
  (setq ob (polar o2222 pi 1000))
  (setq o22222 (polar o2222 (/ pi 2) 10))
  (command "mirror" o2"" o2222 o22222 "Y"); bac tren chieu nghi
  (setq pt4 (polar o2222 pi widthstep))
  (setq pt5 (polar pt4 (/ pi 2) heightstep))
  (command "copy" o2"" o2222 "A" bacconlai pt5)
  (setq t2 (entlast))
  (setq t22 (entget t2))
  (setq t222 (assoc 10 t22))
  (setq  t2222 (cdr t222)); toa do bac thang cuoi cung
  (setq t3 (polar o2222 (/ pi -2) heightstep))
  (setq angle1 (angle t2222 o2222))
  (setq angle2 (- angle1 (/ pi 2)))
  (setq l1 (abs(/ 25 (sin angle2))))
  (setq p1 (polar o2222 (/ pi 2) l1));diem dau line stg xeo
  (setq point2 (polar p1 (/ pi 2) 900))
  (setq point3 (polar t2222 (/ pi 2) l1)) ;diem cuoi line stg xeo
  (setq point4 (polar point3 pi widthstep)) ;line ngang stg tren cung
  (setq point5 (polar point3 (/ pi 2) 900))
  (setq point6 (polar point4 (/ pi 2) 900))
  (setq point7 (polar point2 (/ pi -2) 300))
  (setq point8 (polar point4 (/ pi -2) 250))
  (setq vlao2 (vlax-ename->vla-object o02))
  (LM:SetVisibilityState vlao2 "so2");;;;set chieu nghi
  (LM:setdynpropvalue vlao2 "L" LLANGDING);;chieu dai chieu nghi
  (command "pline" t3 p1 point3 point4"");line tren stg
  (setq dt3 (entlast))
  (setq angle3 (angle p1 point3))
  (setq leng1 (abs(/ 250 (cos angle3))))
  (setq p2 (polar point3 angle3 leng1))
  (hrail p1 p2); HANDRAIL TREN  
  (command "line" p2 point8"")
  (command "offset" 13 dt3  pt1 "")
  (command "offset" 237 dt3  pt1 "")
  (command "offset" 250 dt3  pt1 "")
  (command "EXTEND" o9"" "f" o2222 ob"""")   
  (setvar "osmode" occho)
  (princ))
  