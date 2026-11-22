(defun b02_bubble (pt txt sc / ms o a)
  (vl-load-com)
  (setq ms (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
  (setq o (vla-insertblock ms (vlax-3d-point (car pt) (cadr pt) 0) "ATAD_GRIDLINE_TAG" sc sc sc 0))
  (vla-put-layer o "31 Drawing")
  (if (= (vla-get-hasattributes o) :vlax-true)
    (foreach a (vlax-invoke o 'GetAttributes)
      (if (= (vla-get-tagstring a) "SYMBOL")
        (vla-put-textstring a txt))))
  o)

(defun b02_dimh (x1 x2 y py dstyle)
  (setvar "DIMSTYLE" dstyle)
  (command "_.DIMLINEAR" "_non" (list x1 y) "_non" (list x2 y) "_non" (list x1 py)))

(defun b02_dimv (y1 y2 x px dstyle)
  (setvar "DIMSTYLE" dstyle)
  (command "_.DIMLINEAR" "_non" (list x y1) "_non" (list x y2) "_non" (list px y1)))

(defun c:ANNO_B02_PLAN ( / sc y0 xs ys i x y)
  (setvar "CMDECHO" 0)
  (vl-load-com)
  (setq sc 100.0)
  (setq xs '((0 "1") (6200 "2") (12200 "3") (18400 "4") (23050 "5") (27700 "6") (30600 "7") (36600 "8")))
  (setq ys '((-62000 "A") (-54000 "B") (-48000 "C")))

  ;; 1. Bubbles top & bottom
  (foreach item xs
    (setq x (car item) txt (cadr item))
    (b02_bubble (list x -42000) txt sc)
    (b02_bubble (list x -68500) txt sc))

  ;; 2. Bubbles left & right
  (foreach item ys
    (setq y (car item) txt (cadr item))
    (b02_bubble (list -4500 y) txt sc)
    (b02_bubble (list 41100 y) txt sc))

  ;; 3. Dims Top (trên trục C)
  (setvar "CLAYER" "21 Dim")
  (setq i 0)
  (while (< i (1- (length xs)))
    (b02_dimh (car (nth i xs)) (car (nth (1+ i) xs)) -48000 -45000 "ATAD1-100")
    (setq i (1+ i)))
  ;; Total top
  (b02_dimh 0 36600 -48000 -43500 "ATAD1-100")

  ;; 4. Dims Bottom (dưới trục A)
  (setq i 0)
  (while (< i (1- (length xs)))
    (b02_dimh (car (nth i xs)) (car (nth (1+ i) xs)) -62000 -65500 "ATAD1-100")
    (setq i (1+ i)))
  ;; Total bottom
  (b02_dimh 0 36600 -62000 -67000 "ATAD1-100")

  ;; 5. Dims Left (trục A, B, C)
  (b02_dimv -62000 -54000 0 -2000 "ATAD1-100")
  (b02_dimv -54000 -48000 0 -2000 "ATAD1-100")
  (b02_dimv -62000 -48000 0 -3500 "ATAD1-100")

  ;; 6. Title block / Title text
  (setvar "CLAYER" "12 Text-title")
  (command "_.TEXT" "_non" '(18300 -71500) (* 5.0 sc) "0" "%%U1ST FLOOR PLAN")
  (command "_.TEXT" "_non" '(18300 -73000) (* 3.0 sc) "0" "SCALE 1/100")

  (setvar "CLAYER" "31 Drawing")
  (setvar "CMDECHO" 1)
  (princ "\\nAnnotated Plan B02 successfully!")
  (princ)
)
