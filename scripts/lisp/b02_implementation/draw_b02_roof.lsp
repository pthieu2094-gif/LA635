;; Auto-generated B02 Roof Plan
(defun b02_mkwipeout (pts lay / ename)
  (vl-load-com)
  (entmake (append (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)
                         '(100 . "AcDbPolyline") (cons 90 (length pts)) '(70 . 1))
                   (mapcar '(lambda (p) (cons 10 p)) pts)))
  (setq ename (entlast))
  (command "_.WIPEOUT" "_P" ename "_Y")
  (entlast))

(defun b02_mkhatch (pts ang sc lay / ename h)
  (vl-load-com)
  (entmake (append (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)
                         '(100 . "AcDbPolyline") (cons 90 (length pts)) '(70 . 1))
                   (mapcar '(lambda (p) (cons 10 p)) pts)))
  (setq ename (entlast))
  (setvar "HPNAME" "STEEL")
  (setvar "HPANG" ang)
  (setvar "HPSCALE" sc)
  (command "_.-HATCH" "_S" ename "" "")
  (entdel ename))

(defun c:DRAW_B02_ROOF ( / sc xs ys x y i wp c1 c2 c3 c4 c5 c6 o)
  (setvar "CMDECHO" 0)
  (vl-load-com)
  (setq sc 100.0)
  (setq xs '((90000 "1") (96200 "2") (102200 "3") (108400 "4") (113050 "5") (117700 "6") (120600 "7") (126600 "8")))
  (setq ys '((-59500 "A") (-51500 "B") (-45500 "C")))

  ;; 1. Bubbles & Dims for Roof
  (foreach item xs
    (setq x (car item) txt (cadr item))
    (b02_bubble (list x -39500) txt sc)
    (b02_bubble (list x -66000) txt sc))

  (foreach item ys
    (setq y (car item) txt (cadr item))
    (b02_bubble (list 85500 y) txt sc)
    (b02_bubble (list 131100 y) txt sc))

  ;; Dims Top (Y=-45500)
  (setq i 0)
  (while (< i (1- (length xs)))
    (b02_add_dim (list (car (nth i xs)) -45500) (list (car (nth (1+ i) xs)) -45500) (list (car (nth i xs)) -42500) 0.0 "ATAD1-100")
    (setq i (1+ i)))
  (b02_add_dim '(90000 -45500) '(126600 -45500) '(90000 -41000) 0.0 "ATAD1-100")

  ;; Dims Bottom (Y=-59500)
  (setq i 0)
  (while (< i (1- (length xs)))
    (b02_add_dim (list (car (nth i xs)) -59500) (list (car (nth (1+ i) xs)) -59500) (list (car (nth i xs)) -63000) 0.0 "ATAD1-100")
    (setq i (1+ i)))
  (b02_add_dim '(90000 -59500) '(126600 -59500) '(90000 -64500) 0.0 "ATAD1-100")

  ;; Dims Left (X=90000)
  (b02_add_dim '(90000 -59500) '(90000 -51500) '(88000 -59500) (/ pi 2.0) "ATAD1-100")
  (b02_add_dim '(90000 -51500) '(90000 -45500) '(88000 -51500) (/ pi 2.0) "ATAD1-100")
  (b02_add_dim '(90000 -59500) '(90000 -45500) '(86500 -59500) (/ pi 2.0) "ATAD1-100")

  ;; Dims Right (X=126600)
  (b02_add_dim '(126600 -59500) '(126600 -51500) '(128600 -59500) (/ pi 2.0) "ATAD1-100")
  (b02_add_dim '(126600 -51500) '(126600 -45500) '(128600 -51500) (/ pi 2.0) "ATAD1-100")
  (b02_add_dim '(126600 -59500) '(126600 -45500) '(130100 -59500) (/ pi 2.0) "ATAD1-100")

  ;; 2. Main Roof outline (Trục 1..7: X=89000..121100, Y=-60500..-44500)
  (setvar "CLAYER" "31 Drawing")
  (command "_.RECTANG" "_non" '(89000 -60500) "_non" '(121100 -44500))
  ;; Fascia inner boundary (150mm inside top, right, bottom)
  (command "_.PLINE" "_non" '(89200 -44650) "_non" '(120950 -44650)
                     "_non" '(120950 -60350) "_non" '(89200 -60350) "")

  ;; 3. Main Roof Gutter (WIPEOUT layer 41 Steel section, X=89000..89200, Y=-60500..-44500)
  (b02_mkwipeout '((89000 -60500) (89200 -60500) (89200 -44500) (89000 -44500)) "41 Steel section")

  ;; Downspouts (Circle Ø100 on tim máng xối X=89100 at Axis C, B, A)
  (setvar "CLAYER" "31 Drawing")
  (command "_.CIRCLE" "_non" '(89100 -45500) 50.0)
  (command "_.CIRCLE" "_non" '(89100 -51500) 50.0)
  (command "_.CIRCLE" "_non" '(89100 -59500) 50.0)

  ;; 4. Lower Roof outline (Trục 7..8: X=120600..127600, Y=-59500..-45500)
  (command "_.RECTANG" "_non" '(120600 -59500) "_non" '(127600 -45500))
  (command "_.PLINE" "_non" '(120600 -45650) "_non" '(127400 -45650)
                     "_non" '(127400 -59350) "_non" '(120600 -59350) "")
  ;; Lower Roof Gutter (X=127400..127600, Y=-59500..-45500)
  (b02_mkwipeout '((127400 -59500) (127600 -59500) (127600 -45500) (127400 -45500)) "41 Steel section")
  (command "_.CIRCLE" "_non" '(127500 -45500) 50.0)
  (command "_.CIRCLE" "_non" '(127500 -51500) 50.0)
  (command "_.CIRCLE" "_non" '(127500 -59500) 50.0)

  ;; 5. Canopy (Trục C, nhịp 1-2: X=90000..96200, Y=-45500..-44500)
  (command "_.RECTANG" "_non" '(90000 -45500) "_non" '(96200 -44500))

  ;; 6. Slope Tags (ATAD_SLOPE_TOP)
  ;; Main roof: slope points left (towards X=89000)
  ;; Insert ATAD_SLOPE_TOP with rotation pi (180 deg) so arrow points left
  (setq ms (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
  (foreach pt '((100000 -48000) (110000 -48000) (100000 -52500) (110000 -52500) (100000 -57000) (110000 -57000))
    (setq o (vla-insertblock ms (vlax-3d-point (car pt) (cadr pt) 0) "ATAD_SLOPE_TOP" sc sc sc pi))
    (vla-put-layer o "21 Dim")
    (if (= (vla-get-hasattributes o) :vlax-true)
      (foreach a (vlax-invoke o 'GetAttributes)
        (if (= (vla-get-tagstring a) "SLOPE") (vla-put-textstring a "SLOPE 3%%d")))))

  ;; Lower roof: slope points right (towards X=127600)
  ;; Insert ATAD_SLOPE_TOP with rotation 0
  (foreach pt '((124000 -49000) (124000 -56000))
    (setq o (vla-insertblock ms (vlax-3d-point (car pt) (cadr pt) 0) "ATAD_SLOPE_TOP" sc sc sc 0.0))
    (vla-put-layer o "21 Dim")
    (if (= (vla-get-hasattributes o) :vlax-true)
      (foreach a (vlax-invoke o 'GetAttributes)
        (if (= (vla-get-tagstring a) "SLOPE") (vla-put-textstring a "SLOPE 2%%d")))))

  ;; 7. Roof Hatch STEEL (layer 23 Tole Hatch)
  (b02_mkhatch '((89200 -60350) (120950 -60350) (120950 -44650) (89200 -44650)) 0.0 50.0 "23 Tole Hatch")
  (b02_mkhatch '((120600 -59350) (127400 -59350) (127400 -45650) (120600 -45650)) 0.0 50.0 "23 Tole Hatch")

  ;; 8. Title Text
  (setvar "CLAYER" "12 Text-title")
  (command "_.TEXT" "_non" '(108300 -69000) (* 5.0 sc) "0" "%%UROOF PLAN")
  (command "_.TEXT" "_non" '(108300 -70500) (* 3.0 sc) "0" "SCALE 1/100")

  (setvar "CLAYER" "31 Drawing")
  (setvar "CMDECHO" 1)
  (princ "\\nRoof Plan B02 created successfully!")
  (princ)
)
