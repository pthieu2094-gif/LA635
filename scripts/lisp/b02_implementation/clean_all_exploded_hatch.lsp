(defun c:SCAN_ALL_EXPLODED_HATCH ( / f ss i e ed p10 p11 x1 y1 x2 y2 dx dy len ratio cnt delList )
  (vl-load-com)
  (setq f (open "C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/all_exploded_hatch.txt" "w"))
  (setq ss (ssget "_X" '((0 . "LINE") (8 . "31 Drawing"))))
  (setq i 0 cnt 0 delList nil)
  (while (and ss (< i (sslength ss)))
    (setq e (ssname ss i))
    (setq ed (entget e))
    (setq p10 (cdr (assoc 10 ed)) p11 (cdr (assoc 11 ed)))
    (setq x1 (car p10) y1 (cadr p10) x2 (car p11) y2 (cadr p11))
    ;; Within MB T1 B02: X: -1000 to 38000, Y: -61000 to -43000
    (if (and (>= (min x1 x2) -1000.0) (<= (max x1 x2) 38000.0)
             (>= (min y1 y2) -61000.0) (<= (max y1 y2) -43000.0))
      (progn
        (setq dx (abs (- x1 x2)) dy (abs (- y1 y2)) len (distance p10 p11))
        ;; Slanted line with len < 350, dx > 15, dy > 15, ratio between 0.6 and 1.6
        (if (and (> len 15.0) (< len 350.0) (> dx 15.0) (> dy 15.0))
          (progn
            (setq ratio (/ dx dy))
            (if (and (>= ratio 0.6) (<= ratio 1.6))
              (progn
                (setq cnt (1+ cnt))
                (setq delList (cons e delList))
                (if (< cnt 20)
                  (write-line (strcat "HATCH_LINE h=" (cdr (assoc 5 ed)) " len=" (rtos len 2 1) " dx=" (rtos dx 2 1) " dy=" (rtos dy 2 1)) f))
              ))
          ))
      ))
    (setq i (1+ i)))
  
  (write-line (strcat "TOTAL EXPLODED HATCH TO DELETE: " (itoa cnt)) f)
  ;; Delete them
  (foreach e delList
    (entdel e))
  (write-line "DELETED SUCCESSFULLY" f)
  (close f)
  (princ (strcat "\nDeleted " (itoa cnt) " exploded hatch lines.\n"))
  (princ)
)
