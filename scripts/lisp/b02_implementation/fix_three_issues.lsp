(defun c:FIX_ALL ( / ss_old_stair i ent lay tp minp maxp p1 p2 pl_c_left pl_stair_wall x0 step y_bot y_wc k cur_x cur_ytop y_circ r_circ j cx y_arrow )
  (vl-load-com)
  (setvar "CMDECHO" 0)
  
  ;; ========================================================
  ;; BƯỚC 1: CỘT KẾT CẤU TRỤC 6-C & NỐI KÍN TƯỜNG TRỤC C
  ;; ========================================================
  (princ "\n--- Buoc 1: Cot Truoc 6-C & Tuong Truc C ---\n")
  ;; 1.1 Xóa polyline cũ 2C8644 và hatch 2C8645 của tường Trục C bên trái (nếu còn)
  (if (and (handent "2C8644") (entget (handent "2C8644")))
    (entdel (handent "2C8644"))
  )
  (if (and (handent "2C8645") (entget (handent "2C8645")))
    (entdel (handent "2C8645"))
  )
  
  ;; 1.2 Tạo lại Polyline & Hatch tường Trục C bên trái nối kín đến mép cột X = 26651.1
  (command "_.PLINE" "_non" '(25638.1 -45434.2 0.0)
                     "_non" '(26651.1 -45434.2 0.0)
                     "_non" '(26651.1 -45359.8 0.0)
                     "_non" '(25638.1 -45359.8 0.0)
                     "_C")
  (setq pl_c_left (entlast))
  (vla-put-layer (vlax-ename->vla-object pl_c_left) "31 Drawing")
  
  (command "_.HATCH" "_P" "LINE" 50.0 45.0 "_S" pl_c_left "" "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "22 Hatch")
  
  ;; 1.3 Tạo Cột kết cấu tại góc ngoài WC trái (đối xứng Cột Trục 7):
  ;; X in [26651.1, 26953.9], Y in [-45647.5, -45345.0]
  (command "_.PLINE" "_non" '(26651.1 -45345.0 0.0)
                     "_non" '(26953.9 -45345.0 0.0)
                     "_non" '(26953.9 -45647.5 0.0)
                     "_non" '(26651.1 -45647.5 0.0)
                     "_C")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
  
  ;; Đường hoàn thiện trát tường Trục C nối tiếp
  (command "_.LINE" "_non" '(25638.1 -45345.0 0.0) "_non" '(26651.1 -45345.0 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
  (command "_.LINE" "_non" '(25638.1 -45449.0 0.0) "_non" '(26651.1 -45449.0 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  ;; ========================================================
  ;; BƯỚC 2: LÀM PHẲNG TƯỜNG TRỤC C PHÍA TRÊN WC TRÁI
  ;; ========================================================
  (princ "\n--- Buoc 2: Lam phang tuong Truc C tren WC trai ---\n")
  (foreach h '("2C8A05" "2C8A06" "2C8A07" "2C8A08" "2C8A09" "2C8A0A" "2C8A01")
    (if (and (handent h) (entget (handent h)))
      (entdel (handent h))
    )
  )
  ;; Đường hoàn thiện trát tường Trục C mặt ngoài (Y = -45345.0) từ cửa sang vách giữa
  (command "_.LINE" "_non" '(27753.0 -45345.0 0.0) "_non" '(28651.3 -45345.0 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
  ;; Đường hoàn thiện trát tường Trục C mặt trong (Y = -45449.0)
  (command "_.LINE" "_non" '(27852.2 -45449.0 0.0) "_non" '(28651.3 -45449.0 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  ;; ========================================================
  ;; BƯỚC 3 & 4: CĂN CHỈNH LẠI CẦU THANG ĐỀU ĐẶN 250MM
  ;; ========================================================
  (princ "\n--- Buoc 3: Don dep thang cu va ve lai ---\n")
  (setq ss_old_stair (ssget "_C" '(26600 -49700 0) '(28700 -47946 0)))
  (if ss_old_stair
    (progn
      (setq i 0)
      (while (< i (sslength ss_old_stair))
        (setq ent (entget (ssname ss_old_stair i)))
        (setq lay (cdr (assoc 8 ent)))
        (vla-getboundingbox (vlax-ename->vla-object (ssname ss_old_stair i)) 'minp 'maxp)
        (setq p2 (vlax-safearray->list maxp))
        (if (<= (cadr p2) -47945.5)
          (if (or (equal lay "31 Drawing") (equal lay "22 Hatch") (equal lay "0") (wcmatch lay "*STRS*"))
            (entdel (ssname ss_old_stair i))
          )
        )
        (setq i (1+ i))
      )
    )
  )

  ;; 3.2 Vẽ lại vách tường biên trái thang mới tại X = 26735.6, hoàn thiện X = 26651.1
  ;; Lõi tường: X in [26665.9, 26735.6], Y in [-49637.8, -47930.6]
  (command "_.PLINE" "_non" '(26665.9 -47930.6 0.0)
                     "_non" '(26735.6 -47930.6 0.0)
                     "_non" '(26735.6 -49637.8 0.0)
                     "_non" '(26665.9 -49637.8 0.0)
                     "_C")
  (setq pl_stair_wall (entlast))
  (vla-put-layer (vlax-ename->vla-object pl_stair_wall) "31 Drawing")
  (command "_.HATCH" "_P" "LINE" 50.0 45.0 "_S" pl_stair_wall "" "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "22 Hatch")

  ;; Đường hoàn thiện trát tường biên trái thang:
  (command "_.LINE" "_non" '(26651.1 -47945.4 0.0) "_non" '(26651.1 -49637.8 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
  (command "_.LINE" "_non" '(26735.6 -47945.4 0.0) "_non" '(26735.6 -49563.3 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  ;; 3.3 Vẽ đường biên dưới chân thang: Y = -49563.3 từ X = 26735.6 đến X = 28507.2
  (command "_.LINE" "_non" '(26735.6 -49563.3 0.0) "_non" '(28507.2 -49563.3 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  ;; Lan can / Gờ chân tường dưới: Y = -49637.8 từ X = 26651.1 đến X = 28542.0
  (command "_.LINE" "_non" '(26651.1 -49637.8 0.0) "_non" '(28542.0 -49637.8 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
  (command "_.LINE" "_non" '(28507.2 -49563.3 0.0) "_non" '(28542.0 -49637.8 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  ;; 3.4 Vẽ 10 bậc thang vế dưới đều đặn 250mm
  (setq x0 26735.6)
  (setq step 250.0)
  (setq y_bot -49563.3)
  (setq y_wc -47945.4)

  (setq k 1)
  (while (<= k 9)
    (setq cur_x (+ x0 (* k step)))
    (if (< cur_x 27750.0)
      (setq cur_ytop y_wc)
      (setq cur_ytop (- y_wc (* (- cur_x 27750.0) 2.1572)))
    )
    (if (> cur_ytop y_bot)
      (progn
        (command "_.LINE" "_non" (list cur_x y_bot 0.0) "_non" (list cur_x cur_ytop 0.0) "")
        (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
      )
    )
    (setq k (1+ k))
  )

  ;; 3.5 Vẽ đường Break line zíc-zắc:
  (command "_.PLINE" "_non" '(27750.0 -47945.4 0.0)
                     "_non" '(28020.0 -48550.0 0.0)
                     "_non" '(28180.0 -48470.0 0.0)
                     "_non" '(28080.0 -48770.0 0.0)
                     "_non" '(28240.0 -48690.0 0.0)
                     "_non" '(28500.0 -49563.3 0.0)
                     "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  ;; 3.6 Đặt 8 vòng tròn số thứ tự bậc (1 đến 8)
  (setq y_circ -49250.0)
  (setq r_circ 75.0)
  (setq j 0)
  (while (<= j 7)
    (setq cx (+ x0 (* j step) (/ step 2.0)))
    (command "_.CIRCLE" "_non" (list cx y_circ 0.0) r_circ)
    (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
    (setq j (1+ j))
  )

  ;; Mũi tên UP:
  (setq y_arrow -48750.0)
  (command "_.CIRCLE" "_non" (list (+ x0 125.0) y_arrow 0.0) 30.0)
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")
  
  (command "_.LINE" "_non" (list (+ x0 155.0) y_arrow 0.0) "_non" (list 27800.0 y_arrow 0.0) "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  (command "_.PLINE" "_non" (list 27680.0 (+ y_arrow 50.0) 0.0)
                     "_non" (list 27800.0 y_arrow 0.0)
                     "_non" (list 27680.0 (- y_arrow 50.0) 0.0)
                     "")
  (vla-put-layer (vlax-ename->vla-object (entlast)) "31 Drawing")

  (setvar "CMDECHO" 1)
  (command "_.REGEN")
  (princ "\nFIX_ALL completed successfully!\n")
  (princ)
)
