---
name: cad-arch-grid-frame
description: >-
  Use this skill when starting any new architectural building deployment or view in AutoCAD across any project: automatically discovering existing drawing standards (frame blocks, bounding box baselines, grid bubble blocks, dimstyles, layers), flattening Z=0, cleaning exploded hatches, generating parameterized structural gridlines ($X_GRIDS, $Y_GRIDS) with scaled grid bubbles, and inserting/cloning aligned view frames ($FRAME_BLOCK) with preserved dynamic scale fields.
---

# Skill 1: Khảo Sát Mẫu, Hệ Lưới Trục & Khung Bản Vẽ Tổng Quát (`cad-arch-grid-frame`)

Skill này cung cấp quy trình và công thức tổng quát (project-agnostic) để khởi tạo bất kỳ hạng mục công trình mới nào trên AutoCAD: từ bước tự động quét chuẩn mực bản vẽ hiện hành (`Auto-Discovery`), làm sạch môi trường 2D, đến dựng hệ lưới trục định vị và khung bản vẽ căn thẳng hàng theo đường chuẩn `$Y_BASELINE`.

---

## 1. Quy Trình Tự Động Khảo Sát Bản Vẽ Mẫu (`Auto-Discovery`) & Làm Sạch 2D

Khi mở một file `.dwg` của dự án bất kỳ, AI không được giả định trước tọa độ hay tên Block mà phải chạy quy trình 3 bước:

### Bước 1: Tự động quét thông số chuẩn từ bản vẽ hiện hành
Chạy hàm AutoLISP khảo sát dưới đây để trích xuất tự động:
- Tên Block khung bản vẽ (`$FRAME_BLOCK`), tọa độ điểm chèn $(X_{\text{ins}}, Y_{\text{ins}})$, hệ số tỉ lệ `$SCALE` (`XScaleFactor`), và Bounding Box $(X_{\min}, Y_{\min}) \to (X_{\max}, Y_{\max})$ để xác định đường chuẩn **`$Y_BASELINE`** (`Y_bottom = Y_min` hoặc `Y_top = Y_max`).
- Tên Block bong bóng trục (`$GRID_TAG_BLOCK`, mặc định `"ATAD_GRIDLINE_TAG"`), Block cao độ (`$LEVEL_TAG_BLOCK`, mặc định `"ATAD_LEVEL_TAG"`), và danh sách `DIMSTYLE`, `LAYER` có sẵn.

```lisp
;; Script Auto-Discovery tổng quát quét toàn bộ khung bản vẽ và block mẫu trong file DWG bất kỳ
(defun c:AUTO_DISCOVER_STANDARDS ( / doc ms ss i ent obj bName ins sc minPt maxPt pMin pMax)
  (vl-load-com)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))
        ms  (vla-get-ModelSpace doc)
        ss  (ssget "X" '((0 . "INSERT"))))
  (if ss
    (repeat (setq i (sslength ss))
      (setq ent   (ssname ss (setq i (1- i)))
            obj   (vlax-ename->vla-object ent)
            bName (if (vlax-property-available-p obj 'EffectiveName)
                    (vla-get-EffectiveName obj) (vla-get-Name obj))
            sc    (abs (vla-get-XScaleFactor obj)))
      ;; Lọc các block khung tên/khung view lớn (Scale >= 5 và bề rộng > 3000mm)
      (vla-GetBoundingBox obj 'minPt 'maxPt)
      (setq pMin (vlax-safearray->list minPt)
            pMax (vlax-safearray->list maxPt)
            ins  (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
      (if (> (- (car pMax) (car pMin)) 3000.0)
        (princ (strcat "\n[FRAME] Block=" bName
                       " | Scale=" (rtos sc 2 1)
                       " | Ins=(" (rtos (car ins) 2 2) ", " (rtos (cadr ins) 2 2) ")"
                       " | BBox_Y=[" (rtos (cadr pMin) 2 2) " .. " (rtos (cadr pMax) 2 2) "]"
                       " | Width=" (rtos (- (car pMax) (car pMin)) 2 2))))))
  (princ))
```

### Bước 2: Chuẩn hóa mặt phẳng $Z = 0$ & Làm sạch Hatch vỡ
1. **Đưa toàn bộ đối tượng về $Z = 0.0$:** Chạy `TT_CHUYEN_Z_VE_0.lsp` (Lệnh: `ZZZ`) để khử hoàn toàn cao độ 3D, đảm bảo bắt điểm và nối Polyline chính xác 100%.
2. **Dọn dẹp Hatch bị explode:** Nếu bản vẽ nhận từ bên ngoài có các vùng hatch bị rã thành hàng nghìn đoạn `LINE` ngắn rời rạc trên layer Hatch, phải quét và xóa sạch trước khi dựng hình mới.

---

## 2. Công Thức Tham Số Hóa Dựng Hệ Lưới Trục (`32 Gridline`)

Mọi hệ lưới trục của dự án bất kỳ được định nghĩa bởi:
- **Gốc tọa độ lưới trục:** `$ORIGIN = (P_X, P_Y)` (Giao điểm trục đứng đầu tiên `offX = 0` và trục ngang đầu tiên `offY = 0`).
- **Mảng trục đứng `$X_GRIDS`:** `((offX_1 "Name_1") (offX_2 "Name_2") ... (offX_n "Name_n"))`, tổng chiều dài $L_{\text{total}} = \text{offX}_n$.
- **Mảng trục ngang `$Y_GRIDS`:** `((offY_1 "Name_1") (offY_2 "Name_2") ... (offY_m "Name_m"))`, tổng chiều rộng $W_{\text{total}} = \text{offY}_m$.
- **Hệ số tỉ lệ khung nhìn:** `$SCALE = sc` (`100.0`, `150.0`, `120.0`, `60.0`...).

### Công thức Khoảng nhô Đường trục & Tọa độ Bong bóng trục theo `$SCALE` (`sc`):
- **Khoảng nhô đường trục ra ngoài biên công trình (`$GRID_EXT`):**
  $$\Delta_{\text{ext}} = 35.0 \times sc \div 60.0 \times sc \quad (\text{đủ chứa 2 lớp Dim chi tiết + Dim tổng})$$
- **Khoảng cách từ đầu mút đường trục tới tâm Bong bóng trục (`$BUBBLE_RAD`):**
  $$R_{\text{bubble}} = 4.25 \times sc \quad (\text{Ví dụ: } 425\text{ mm ở } 1/100,\ 637.5\text{ mm ở } 1/150)$$

```lisp
;; Hàm tổng quát vẽ Hệ lưới trục và Bong bóng trục cho bất kỳ dự án nào
;; - px, py: Tọa độ gốc (Trục 1 giao Trục A)
;; - xGrids: Danh sách '((0.0 "1") (6000.0 "2") ...)
;; - yGrids: Danh sách '((0.0 "A") (8000.0 "B") ...)
;; - sc: Tỉ lệ bản vẽ (100.0, 150.0...)
;; - bubbleSides: Danh sách các phía đặt bong bóng '("TOP" "BOTTOM" "LEFT" "RIGHT")
(defun univ_draw_grid_system (px py xGrids yGrids sc bubbleBlk bubbleSides /
                              ms lTotal wTotal ext rBub gx gy tag)
  (vl-load-com)
  (setq ms     (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object)))
        lTotal (car (last xGrids))
        wTotal (car (last yGrids))
        ext    (* 40.0 sc)
        rBub   (* 4.25 sc))

  (defun _mkGridLine (p1 p2 / obj)
    (setq obj (vla-AddLine ms (vlax-3d-point p1) (vlax-3d-point p2)))
    (if (tblsearch "LAYER" "32 Gridline") (vla-put-Layer obj "32 Gridline"))
    obj)

  (defun _insBubble (pt txt / bRef atts)
    (setq bRef (vla-InsertBlock ms (vlax-3d-point pt) bubbleBlk sc sc sc 0.0))
    (if (tblsearch "LAYER" "31 Drawing") (vla-put-Layer bRef "31 Drawing"))
    (if (= (vla-get-HasAttributes bRef) :vlax-true)
      (foreach a (vlax-invoke bRef 'GetAttributes)
        (if (member (strcase (vla-get-TagString a)) '("SYMBOL" "TAG" "GRID" "NAME"))
          (vla-put-TextString a txt))))
    bRef)

  ;; 1. Vẽ các trục đứng (X Grids)
  (foreach g xGrids
    (setq gx  (+ px (car g))
          tag (cadr g))
    (_mkGridLine (list gx (- py ext) 0.0) (list gx (+ py wTotal ext) 0.0))
    (if (member "TOP" bubbleSides)
      (_insBubble (list gx (+ py wTotal ext rBub) 0.0) tag))
    (if (member "BOTTOM" bubbleSides)
      (_insBubble (list gx (- py ext rBub) 0.0) tag)))

  ;; 2. Vẽ các trục ngang (Y Grids)
  (foreach g yGrids
    (setq gy  (+ py (car g))
          tag (cadr g))
    (_mkGridLine (list (- px ext) gy 0.0) (list (+ px lTotal ext) gy 0.0))
    (if (member "LEFT" bubbleSides)
      (_insBubble (list (- px ext rBub) gy 0.0) tag))
    (if (member "RIGHT" bubbleSides)
      (_insBubble (list (+ px lTotal ext rBub) gy 0.0) tag))))
```

---

## 3. Công Thức Tổng Quát Căn Hàng & Chèn Khung Bản Vẽ (`$FRAME_BLOCK`)

Để toàn bộ các khung bản vẽ của một dự án nằm thẳng hàng chuyên nghiệp trên một dải ngang:
1. **Xác định offset từ điểm chèn khung tới đáy khung ($\Delta Y_{\text{bot}}$) và đỉnh khung ($\Delta Y_{\text{top}}$) ở tỉ lệ đơn vị (`sc = 1.0`):**
   - Gọi $(x_{\text{ins}}, y_{\text{ins}})$ là điểm chèn và $[y_{\min}, y_{\max}]$ là cao độ Bounding Box của một khung mẫu có tỉ lệ $sc_0$:
     $$k_{\text{bot}} = \frac{y_{\text{ins}} - y_{\min}}{sc_0}, \quad k_{\text{top}} = \frac{y_{\max} - y_{\text{ins}}}{sc_0}, \quad w_0 = \frac{x_{\max} - x_{\min}}{sc_0}$$
2. **Công thức tính Tọa độ Điểm chèn $Y_{\text{insert}}$ cho khung mới ở tỉ lệ `sc` bất kỳ:**
   - **Nếu dự án căn bằng Đáy khung (`$Y_BOTTOM` cố định):**
     $$Y_{\text{insert}}(sc) = Y_{\text{BOTTOM}} + k_{\text{bot}} \times sc$$
   - **Nếu dự án căn bằng Đỉnh khung (`$Y_TOP` cố định):**
     $$Y_{\text{insert}}(sc) = Y_{\text{TOP}} - k_{\text{top}} \times sc$$
   - **Tọa độ $X$ của khung kế tiếp bên phải (cách khung trước một khoảng `FRAME_GAP`):**
     $$X_{\text{next}} = X_{\text{prev}} + w_0 \times sc_{\text{prev}} + \text{FRAME\_GAP}$$
3. **Bảo toàn Dynamic Field tỷ lệ trên khung:**
   - Nếu khung mới có cùng tỉ lệ `sc` với khung mẫu gốc: Dùng `vla-Copy` từ khung mẫu rồi `vla-Move` tới $(X_{\text{target}}, Y_{\text{insert}})$ để giữ nguyên Dynamic Field `Scale X`.
   - Nếu khung mới khác tỉ lệ `sc`: Chèn block hoặc scale khung, sau đó cập nhật Attribute `"SCC"` thành `(strcat "1/" (itoa (fix sc)))`.

---

## 4. Checklist Kiểm Tra Nghiệm Thu (`Verification`)
- [ ] Đã chạy khảo sát `AUTO_DISCOVER_STANDARDS` để lấy đúng tên Block khung, tên Block bong bóng trục và `$Y_BASELINE` của file `.dwg` hiện hành.
- [ ] Toàn bộ đối tượng có tọa độ $Z = 0.0$, đường trục nằm trên layer `"32 Gridline"`.
- [ ] Mép đáy (hoặc mép đỉnh) của toàn bộ các khung View trên cùng một hàng gióng thẳng hàng tuyệt đối theo `$Y_BASELINE`.
- [ ] Góc hiển thị tỉ lệ của mỗi khung hiển thị đúng `1/<sc>` mà không bị lỗi `####` hay đè 2 khung trùng nhau.

---

## 5. Ví Dụ Minh Họa Tham Khảo (Từ Dự Án Mẫu B01 & B02)
- **Khung chuẩn `"A$Ce291ec07"`:** Có $w_0 = 581.7\text{ mm}$, $h_0 = 436.58\text{ mm}$, $k_{\text{bot}} = 408.805\text{ mm}$, $k_{\text{top}} = 27.78\text{ mm}$.
  - Khi căn bằng đáy $Y_{\text{BOTTOM}} = -12,607.6\text{ mm}$ (dãy B01):
    - Khung `1/150` (`sc = 150`): $Y_{\text{insert}} = -12607.6 + 408.805 \times 150 = 48,712.42\text{ mm}$, rộng $87,255.5\text{ mm}$.
    - Khung `1/10` (`sc = 10`): $Y_{\text{insert}} = -12607.6 + 408.805 \times 10 = -8,519.55\text{ mm}$, rộng $5,817.0\text{ mm}$.
  - Khi căn bằng đỉnh $Y_{\text{TOP}} = -32,608.0\text{ mm}$ (dãy B02):
    - Khung `1/100` (`sc = 100`): $Y_{\text{insert}} = -32608.0 - 27.78 \times 100 = -35,386.0\text{ mm}$.
