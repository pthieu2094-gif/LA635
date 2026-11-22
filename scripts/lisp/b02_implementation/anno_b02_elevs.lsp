;; Complete Elevation Annotations, Levels, Dims, Bubbles, Downspouts & Titles for B02
(defun b02_elev_bubble (pt txt sc / ms o a)
  (vl-load-com)
  (setq ms (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
  (setq o (vla-insertblock ms (vlax-3d-point (car pt) (cadr pt) 0) "ATAD_GRIDLINE_TAG" sc sc sc 0))
  (vla-put-layer o "31 Drawing")
  (if (= (vla-get-hasattributes o) :vlax-true)
    (foreach a (vlax-invoke o 'GetAttributes)
      (if (= (vla-get-tagstring a) "SYMBOL")
        (vla-put-textstring a txt))))
  o)

(defun b02_add_level (pt lvl note sc flip / ms o a)
  (vl-load-com)
  (setq ms (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
  (setq o (vla-insertblock ms (vlax-3d-point (car pt) (cadr pt) 0) "ATAD_LEVEL_TAG" sc (if flip (- sc) sc) sc 0))
  (vla-put-layer o "0")
  (if (= (vla-get-hasattributes o) :vlax-true)
    (foreach a (vlax-invoke o 'GetAttributes)
      (if (= (vla-get-tagstring a) "LEVEL") (vla-put-textstring a lvl))
      (if (= (vla-get-tagstring a) "NOTE") (vla-put-textstring a note))))
  o)

(defun b02_level_line (x1 x2 y / ename)
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(8 . "32 Gridline")
                 '(100 . "AcDbPolyline") '(90 . 2) '(70 . 0)
                 (cons 10 (list x1 y)) (cons 10 (list x2 y))))
  (setq ename (entlast))
  (command "_.DRAWORDER" ename "" "_B"))

(defun b02_add_spout (x y leng dia / ms o p)
  (vl-load-com)
  (setq ms (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
  (setq o (vla-insertblock ms (vlax-3d-point x y 0) "TT-Dowspout 2021-12-07-D" 1.0 1.0 1.0 0))
  (vla-put-layer o "31 Drawing")
  (if (= (vla-get-isdynamicblock o) :vlax-true)
    (foreach p (vlax-invoke o 'GetDynamicBlockProperties)
      (if (= (vla-get-propertyname p) "Leng") (vla-put-value p (vlax-make-variant (float leng) vlax-vbDouble)))
      (if (= (vla-get-propertyname p) "Diameter") (vla-put-value p (vlax-make-variant (float dia) vlax-vbDouble)))))
  (command "_.DRAWORDER" (vlax-vla-object->ename o) "" "_F")
  o)

(defun c:COMPLETE_B02_ELEVS ( / sc120 sc60 xs_e1 xs_e4 ys_e2 ys_e3 i x y dstyle120 dstyle60)
  (setvar "CMDECHO" 0)
  (vl-load-com)
  (setq sc120 120.0 sc60 60.0)

  ;; Check or fallback Dimstyles
  (setq dstyle120 "ATAD1-120")
  (setq dstyle60 "ATAD1-80") ; fallback to 80 if 60 not present

  ;; =========================================================================
  ;; 1. ELEVATION 1 (Y0 = -53700) & ELEVATION 4 (Y0 = -73700) [Scale 120]
  ;; =========================================================================
  (setq xs_e1 '((180000 "1") (186200 "2") (192200 "3") (198400 "4") (203050 "5") (207700 "6") (210600 "7") (216600 "8")))
  (setq xs_e4 '((180000 "8") (186000 "7") (188900 "6") (193550 "5") (198200 "4") (204400 "3") (210400 "2") (216600 "1")))

  ;; E1 Levels
  (b02_add_level '(177500 -53700) "%%P0.000" "(G.FL)" sc120 T)
  (b02_add_level '(177500 -53200) "+0.500" "(1.FL)" sc120 nil)
  (b02_add_level '(177500 -49200) "+4.500" "(2.FL)" sc120 nil)
  (b02_add_level '(177500 -45200) "+8.500" "(TOP COL)" sc120 nil)
  (b02_add_level '(177500 -42500) "+11.200" "(TOP ROOF)" sc120 nil)
  (foreach y '(-53700 -53200 -49200 -45200 -42500) (b02_level_line 177500 217500 y))

  ;; E1 Bubbles & Dims (Bottom Y = -53700)
  (foreach item xs_e1 (b02_elev_bubble (list (car item) -57000) (cadr item) sc120))
  (setq i 0)
  (while (< i (1- (length xs_e1)))
    (b02_add_dim (list (car (nth i xs_e1)) -53700) (list (car (nth (1+ i) xs_e1)) -53700) (list (car (nth i xs_e1)) -55200) 0.0 dstyle120)
    (setq i (1+ i)))
  (b02_add_dim '(180000 -53700) '(216600 -53700) '(180000 -56200) 0.0 dstyle120)

  ;; E1 Downspout at axis 1 & 8
  (b02_add_spout 180000 -45200 8500 140)

  ;; E1 Title
  (setvar "CLAYER" "12 Text-title")
  (command "_.TEXT" "_non" '(198300 -59000) (* 5.0 sc120) "0" "%%UELEVATION 1")
  (command "_.TEXT" "_non" '(198300 -60500) (* 3.0 sc120) "0" "SCALE 1/120")

  ;; E4 Levels
  (b02_add_level '(177500 -73700) "%%P0.000" "(G.FL)" sc120 T)
  (b02_add_level '(177500 -73200) "+0.500" "(1.FL)" sc120 nil)
  (b02_add_level '(177500 -69200) "+4.500" "(2.FL)" sc120 nil)
  (b02_add_level '(177500 -65200) "+8.500" "(TOP COL)" sc120 nil)
  (b02_add_level '(177500 -62500) "+11.200" "(TOP ROOF)" sc120 nil)
  (foreach y '(-73700 -73200 -69200 -65200 -62500) (b02_level_line 177500 217500 y))

  ;; E4 Bubbles & Dims (Bottom Y = -73700)
  (foreach item xs_e4 (b02_elev_bubble (list (car item) -77000) (cadr item) sc120))
  (setq i 0)
  (while (< i (1- (length xs_e4)))
    (b02_add_dim (list (car (nth i xs_e4)) -73700) (list (car (nth (1+ i) xs_e4)) -73700) (list (car (nth i xs_e4)) -75200) 0.0 dstyle120)
    (setq i (1+ i)))
  (b02_add_dim '(180000 -73700) '(216600 -73700) '(180000 -76200) 0.0 dstyle120)

  ;; E4 Downspout at axis 8 & 1
  (b02_add_spout 216600 -65200 8500 140)

  ;; E4 Title
  (setvar "CLAYER" "12 Text-title")
  (command "_.TEXT" "_non" '(198300 -79500) (* 5.0 sc120) "0" "%%UELEVATION 4")
  (command "_.TEXT" "_non" '(198300 -81000) (* 3.0 sc120) "0" "SCALE 1/120")

  ;; =========================================================================
  ;; 2. ELEVATION 2 (Trục 1: C->B->A, X0=245400) [Scale 60]
  ;; =========================================================================
  (setq ys_e2 '((245400 "C") (251400 "B") (259400 "A")))
  (b02_add_level '(243000 -50300) "%%P0.000" "(G.FL)" sc60 T)
  (b02_add_level '(243000 -49800) "+0.500" "(1.FL)" sc60 nil)
  (b02_add_level '(243000 -45800) "+4.500" "(2.FL)" sc60 nil)
  (b02_add_level '(243000 -41800) "+8.500" "(TOP COL)" sc60 nil)
  (b02_add_level '(243000 -39100) "+11.200" "(TOP ROOF)" sc60 nil)
  (foreach y '(-50300 -49800 -45800 -41800 -39100) (b02_level_line 243000 260000 y))

  (foreach item ys_e2 (b02_elev_bubble (list (car item) -52500) (cadr item) sc60))
  (b02_add_dim '(245400 -50300) '(251400 -50300) '(245400 -51300) 0.0 dstyle60)
  (b02_add_dim '(251400 -50300) '(259400 -50300) '(251400 -51300) 0.0 dstyle60)
  (b02_add_dim '(245400 -50300) '(259400 -50300) '(245400 -52000) 0.0 dstyle60)

  ;; 3 downspouts for E2 (at axes C, B, A)
  (b02_add_spout 245400 -41800 8500 140)
  (b02_add_spout 251400 -41800 8500 140)
  (b02_add_spout 259400 -41800 8500 140)

  ;; E2 Title
  (setvar "CLAYER" "12 Text-title")
  (command "_.TEXT" "_non" '(252400 -54000) (* 5.0 sc60) "0" "%%UELEVATION 2")
  (command "_.TEXT" "_non" '(252400 -55000) (* 3.0 sc60) "0" "SCALE 1/60")

  ;; =========================================================================
  ;; 3. ELEVATION 3 (Trục 8: A->B->C, X0=283000) [Scale 60]
  ;; =========================================================================
  (setq ys_e3 '((283000 "A") (291000 "B") (297000 "C")))
  (b02_add_level '(280600 -50300) "%%P0.000" "(G.FL)" sc60 T)
  (b02_add_level '(280600 -49800) "+0.500" "(1.FL)" sc60 nil)
  (b02_add_level '(280600 -45800) "+4.500" "(2.FL)" sc60 nil)
  (b02_add_level '(280600 -41800) "+8.500" "(TOP COL)" sc60 nil)
  (b02_add_level '(280600 -39100) "+11.200" "(TOP ROOF)" sc60 nil)
  (foreach y '(-50300 -49800 -45800 -41800 -39100) (b02_level_line 280600 297500 y))

  (foreach item ys_e3 (b02_elev_bubble (list (car item) -52500) (cadr item) sc60))
  (b02_add_dim '(283000 -50300) '(291000 -50300) '(283000 -51300) 0.0 dstyle60)
  (b02_add_dim '(291000 -50300) '(297000 -50300) '(291000 -51300) 0.0 dstyle60)
  (b02_add_dim '(283000 -50300) '(297000 -50300) '(283000 -52000) 0.0 dstyle60)

  ;; 3 downspouts for lower roof of E3 (axes A, B, C)
  (b02_add_spout 283000 -45800 4500 140)
  (b02_add_spout 291000 -45800 4500 140)
  (b02_add_spout 297000 -45800 4500 140)

  ;; E3 Title
  (setvar "CLAYER" "12 Text-title")
  (command "_.TEXT" "_non" '(290000 -54000) (* 5.0 sc60) "0" "%%UELEVATION 3")
  (command "_.TEXT" "_non" '(290000 -55000) (* 3.0 sc60) "0" "SCALE 1/60")

  (setvar "CLAYER" "31 Drawing")
  (setvar "CMDECHO" 1)
  (princ "\\nCompleted all 4 elevations!")
  (princ)
)
