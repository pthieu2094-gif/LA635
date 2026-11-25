---
name: cad-anchor-bolt-plan
description: >-
  Use this skill when deploying an Anchor Bolt Location Plan (Mặt bằng định vị bu lông neo, e.g. scale 1/150 or 1/100) in AutoCAD for any project: aligning the view frame to the project baseline ($Y_BASELINE), drawing top/left gridlines and ATAD1-<sc> dimensions without text below dim, inserting structural column base blocks with exact rotations, automatically grouping details (A1..An) by the 3-key rule (BlockType, RotationAngle, ElevationFFL) with distinct ACI color dashed rounded rectangles, placing scale-matched QHP_AnchorBolt_Tag_2022 hex tags, and adding clash-free ATAD_LEVEL_TAG markers.
---

# Skill 5: Triển Khai Mặt Bằng Định Vị Bu Lông Neo Tổng Quát (`cad-anchor-bolt-plan`)

Skill này cung cấp quy trình, thuật toán phân nhóm và công thức tham số hóa tổng quát để dựng **Mặt bằng Định vị Bu lông neo (`ANCHOR BOLT PLAN`)** ở tỉ lệ bất kỳ (`$SCALE` $= 150.0, 100.0\dots$) cho mọi dự án nhà xưởng tiền chế và kết cấu thép trên AutoCAD.

---

## 1. Quy Chuẩn Đặt Khung View & Hệ Tọa Độ Mặt Bằng Bu Lông Neo

1. **Căn thẳng hàng khung bản vẽ theo `$Y_BASELINE` của dự án:**
   - Mặt bằng Định vị Bu lông neo (Sheet 1) được đặt tiếp nối bên phải bản vẽ Kiến trúc cuối cùng với khoảng cách `FRAME_GAP` và có **đáy khung (hoặc đỉnh khung) gióng thẳng hàng tuyệt đối theo `$Y_BASELINE`** của toàn bộ dự án.
   - Sử dụng `vla-Copy` từ khung mẫu cùng tỉ lệ `$SCALE` (`sc`) rồi `vla-Move` sang $X_{\text{frame1}}$ để bảo toàn 100% **Dynamic Field `Scale X`** (tự động hiển thị `1/<sc>` ở góc trái trên khung).
2. **Gốc tọa độ lưới trục $(P_X, P_Y)$ trong khung:**
   - Giao điểm Trục đầu tiên (`offX = 0, offY = 0`) đặt tại:
     $$P_X = X_{\text{frame1}} + \Delta X_{\text{margin}}, \quad P_Y = Y_{\text{grid0}}$$
   - Trong đó $Y_{\text{grid0}}$ trùng khít với cao độ $Y$ của Trục ngang đầu tiên trên Mặt bằng tầng trệt Kiến trúc để toàn bộ các mặt bằng trong dự án gióng ngang thẳng hàng 100%.

---

## 2. Quy Chuẩn Lưới Trục & Kích Thước Mặt Bằng Định Vị (`No Text Below Dim`)

1. **Lưới trục (`"32 Gridline"`, màu `251`) & Bong bóng trục (`"ATAD_GRIDLINE_TAG"`, `Scale = sc`):**
   - Để mặt bằng thông thoáng tối đa cho các đường khoanh vùng nét đứt và tag bu lông neo ở biên phải và biên dưới:
     - **Các trục đứng (`$X_GRIDS`):** Chỉ đặt bong bóng trục ở **Phía Trên** ($Y_{\text{tag}} = P_Y + W_{\text{total}} + 44.0 \times sc$).
     - **Các trục ngang (`$Y_GRIDS`):** Chỉ đặt bong bóng trục ở **Phía Trái** ($X_{\text{tag}} = P_X - 67.0 \times sc$).
2. **Hệ thống Dim trục 2 lớp (`"21 Dim"`, DimStyle `"ATAD1-<sc>"`, `ScaleFactor = sc`):**
   - Chỉ đặt 2 lớp Dim (Dim nhịp chi tiết + Dim tổng) ở **Phía Trên** và **Phía Trái**:
     - Phía Trên: $Y_{\text{dim1}} = P_Y + W_{\text{total}} + 26.0 \times sc$, $Y_{\text{dim2}} = Y_{\text{dim1}} + 8.0 \times sc$.
     - Phía Trái: $X_{\text{dim1}} = P_X - 50.0 \times sc$, $X_{\text{dim2}} = X_{\text{dim1}} - 8.0 \times sc$.
   - **QUY TẮC BẮT BUỘC:** Tuyệt đối **KHÔNG** ghi chú chữ bên dưới đường Dim (`No text below dim`) trên mặt bằng bu lông neo để chữ không đè vào đường lưới trục.

---

## 3. Thuật Toán Tổng Quát Phân Nhóm Mã Chi Tiết (`A1..An`) Theo Bộ 3 Khóa

Khi đặt các Block chân cột (`AcDbBlockReference`) lên các giao điểm lưới trục trên Mặt bằng định vị, AI **BẮT BUỘC** phân nhóm mã chi tiết (`A1, A2, A2A, A3, A3A...`) dựa trên **Bộ 3 Khóa Định Danh (`3-Key Grouping Rule`)**:

$$\text{DetailKey} = \left(\text{BlockName},\ \text{RotationAngle }\theta,\ \text{ElevationFFL}\right)$$

### Ba Tiêu Chí Bắt Buộc Tách Mã Chi Tiết Riêng:
1. **Khóa 1 — Tên Block / Quy cách Tiết diện Cột, Bản mã & Bu lông (`BlockName`):**
   - Mỗi loại kích thước tiết diện cột ($H_c \times B_c$), kích thước bản mã ($t_p \times W_p \times L_p$) và số lượng bu lông ($4\text{M}20, 6\text{M}20, 8\text{M}24\dots$) nhận một số thứ tự gốc: `A1, A2, A3, ..., Ak`.
2. **Khóa 2 — Góc xoay thực tế của Cột trên Mặt bằng ($\theta = 0^\circ\text{ vs } 90^\circ$):**
   - **Quy tắc bất di bất dịch:** Nếu hai cột dùng **cùng một Block chân cột** nhưng một nhóm đặt xoay **$0^\circ$** (bụng cột dọc theo trục $Y$) và một nhóm đặt xoay **$90^\circ$** (bụng cột ngang theo trục $X$), thì **BẮT BUỘC phải tách thành 2 mã chi tiết riêng biệt** (ví dụ: nhóm $0^\circ$ là **`A2`**, nhóm $90^\circ$ tách thành **`A2A`**)!
   - *Lý do kỹ thuật:* Khi vẽ Chi tiết 1/10, hình chiếu bằng của `A2` và `A2A` có hướng xoay vuông góc nhau và hướng đặt ký hiệu vết mặt cắt cũng khác nhau.
3. **Khóa 3 — Cao độ đặt Chân cột (`FFL +0.100` vs `FFL +0.000` hoặc hạ cos):**
   - Nếu hai cột có cùng `BlockName` và cùng góc xoay $\theta$, nhưng một số vị trí cột được hạ cos chân cột xuống **`FFL +0.000`** (ví dụ tại vị trí cửa đi/ram dốc) trong khi các cột còn lại ở **`FFL +0.100`**, thì nhóm hạ cos **BẮT BUỘC phải tách thành mã có hậu tố `A` (hoặc `B`)** (ví dụ: **`A3A`**, **`A5A`**, **`A7A`**) để mặt cắt 1/10 thể hiện đúng mốc cao độ `FFL`.

### Bảng Mã Màu ACI Tương Phản Cao Cho Các Nhóm Khoanh Vùng:
Mỗi mã chi tiết sau khi phân nhóm phải được gán **1 mã màu ACI duy nhất** từ bảng màu chuẩn dưới đây để khoanh vùng nét đứt không bị trùng màu:

```javascript
// Bảng 14 màu ACI tương phản cao chuẩn cho các cụm A1..An trong mọi dự án:
const DETAIL_ACI_COLORS = [
  1,   // Nhóm 1 (VD: A1)  - Red
  3,   // Nhóm 2 (VD: A2)  - Green
  150, // Nhóm 3 (VD: A2A) - Spring Green
  4,   // Nhóm 4 (VD: A3)  - Cyan
  30,  // Nhóm 5 (VD: A3A) - Orange
  6,   // Nhóm 6 (VD: A4)  - Magenta
  2,   // Nhóm 7 (VD: A5)  - Yellow
  140, // Nhóm 8 (VD: A5A) - Light Blue
  5,   // Nhóm 9 (VD: A6)  - Blue
  210, // Nhóm 10 (VD: A7) - Violet
  10,  // Nhóm 11 (VD: A7A)- Red-Orange
  40,  // Nhóm 12          - Gold
  190, // Nhóm 13          - Deep Purple
  92   // Nhóm 14          - Lime Green
];
```

---

## 4. Công Thức Vẽ Đường Khoanh Vùng Bo Góc, Tag Lục Giác & Mốc Cao Độ

1. **Đường khoanh vùng bo góc (`mkRoundRect`):**
   - Bao quanh 1 cột đơn lẻ hoặc 1 dãy cột thẳng hàng cùng mã chi tiết với khoảng đệm $\Delta_{\text{pad}} = 5.3 \times sc \div 6.0 \times sc$ (ví dụ $800 \div 900\text{ mm}$ ở tỉ lệ `1/150`).
   - Vẽ bằng `LWPOLYLINE` 8 đỉnh khép kín (`Closed = :vlax-true`), gán hệ số bo góc `Bulge = 0.41421356` ($\tan(\pi/8)$) tại các đỉnh lẻ `(1, 3, 5, 7)`, bán kính góc bo $R = 2.0 \times sc \div 2.7 \times sc$.
   - Kiểu nét: `"DASHED"`, `LinetypeScale = 2.0 * sc` (ví dụ `300.0` ở tỉ lệ `1/150`), màu theo `DETAIL_ACI_COLORS[idx]`.
2. **Tag Lục Giác (`"QHP_AnchorBolt_Tag_2022"`):**
   - Đặt trên layer `"0"`, **Scale X = Scale Y = Scale Z = `sc`** (bằng đúng hệ số tỉ lệ khung view!).
   - Đặt cách tâm cột/nhóm cột một khoảng $\Delta_{\text{tag}} = 13.3 \times sc$ ($2,000\text{ mm}$ ở `1/150`) về phía thoáng (ưu tiên phía ngoài biên nhà) để không cắt qua đường trục hoặc cột lân cận.
3. **Mốc Cao Độ Mặt Bằng (`"ATAD_LEVEL_TAG"`):**
   - Chèn 1 block `"ATAD_LEVEL_TAG"` (`Scale = sc`, `NOTE = "FFL"`, `LEVEL = "+0.100"`) tại tâm khoang lưới trục trống ở giữa nhà để không va chạm (no clash) với bất kỳ đường khoanh vùng nào.

```lisp
;; 1. Hàm tổng quát vẽ Hình chữ nhật bo góc (Rounded Rectangle) nét đứt đa màu
(defun univ_ab_round_rect (minx miny maxx maxy r lyr aciCol lt lts / pts arr pObj)
  (setq pts (list
    (+ minx r) miny       (- maxx r) miny
    maxx (+ miny r)       maxx (- maxy r)
    (- maxx r) maxy       (+ minx r) maxy
    minx (- maxy r)       minx (+ miny r)))
  (setq arr (vlax-make-safearray vlax-vbDouble '(0 . 15)))
  (vlax-safearray-fill arr pts)
  (setq pObj (vla-AddLightWeightPolyline mSpace arr))
  (vla-put-Closed pObj :vlax-true)
  (foreach idx '(1 3 5 7) (vla-SetBulge pObj idx 0.41421356))
  (if (and lyr (tblsearch "LAYER" lyr)) (vla-put-Layer pObj lyr))
  (if aciCol (vla-put-Color pObj aciCol))
  (if lt (vla-put-Linetype pObj lt))
  (if lts (vla-put-LinetypeScale pObj lts))
  pObj)

;; 2. Hàm tổng quát chèn Tag Lục giác QHP_AnchorBolt_Tag_2022 theo tỉ lệ sc bất kỳ
(defun univ_ab_hex_tag (pt tag sc / blkRef atts)
  (setq blkRef (vla-InsertBlock mSpace (vlax-3d-point pt) "QHP_AnchorBolt_Tag_2022" sc sc sc 0.0))
  (vla-put-Layer blkRef "0")
  (if (and (= (vla-get-HasAttributes blkRef) :vlax-true)
           (setq atts (vlax-invoke blkRef 'GetAttributes)))
    (vla-put-TextString (car atts) tag))
  blkRef)
```

---

## 5. Checklist Kiểm Tra Nghiệm Thu (`Verification`)
- [ ] Khung View Mặt bằng Bu lông neo gióng thẳng hàng tuyệt đối theo `$Y_BASELINE` của dự án và góc trái trên hiển thị đúng `1/<sc>`.
- [ ] Các đường Dim trục chỉ nằm ở Phía Trên và Bên Trái, đúng DimStyle `"ATAD1-<sc>"`, không có chữ bên dưới đường Dim.
- [ ] Đã kiểm tra bộ 3 khóa `(BlockName, RotationAngle, ElevationFFL)`: mọi cột khác góc xoay ($0^\circ$ vs $90^\circ$) hoặc khác cốt cao độ `FFL` đều đã được tách mã riêng (`A2A`, `A3A`...).
- [ ] Mỗi mã chi tiết có một màu ACI khoanh nét đứt riêng biệt và tag `"QHP_AnchorBolt_Tag_2022"` có `Scale = sc`.
- [ ] Block cao độ `"ATAD_LEVEL_TAG"` nằm ở khoang trống, không đè lên lưới trục hay đường khoanh vùng.

---

## 6. Ví Dụ Minh Họa Tham Khảo (Từ Dự Án B01)
- **Mặt bằng Bu lông neo B01 (`$SCALE = 150.0`, `$Y_BOTTOM = -12,607.6 mm`, $X_{\text{frame1}} = 353,000.0$, $P_X = 369,692.16, P_Y = 0.0$):**
  - 33 chân cột thuộc 7 loại Block gốc, sau khi áp dụng **Bộ 3 Khóa** tách thành **11 mã chi tiết** với 11 màu ACI:
    - `A1` (Color 1), `A2` (xoay $0^\circ$, Color 3), `A2A` (cùng block với A2 nhưng tại `I/1, I/8` xoay $90^\circ$, Color 150), `A3` (Color 4), `A3A` (tại `A/6` cos `+0.000`, Color 30), `A4` (Color 6), `A5` (Color 2), `A5A` (tại `I/3` cos `+0.000`, Color 140), `A6` (Color 5), `A7` (Color 210), `A7A` (tại `I/4` cos `+0.000`, Color 10).
