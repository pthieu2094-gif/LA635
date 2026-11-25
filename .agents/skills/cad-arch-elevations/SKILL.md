---
name: cad-arch-elevations
description: >-
  Use this skill when drawing or annotating architectural Elevations 1 to 4 in AutoCAD for any project: mapping gridline coordinates for all 4 viewing directions (Front X_i, Rear L_total - X_i, Left W_total - Y_i, Right Y_i), generating horizontal level lines sent to back (DRAWORDER _B), inserting ATAD_LEVEL_TAG markers with automatic Y-flip on closely spaced base levels (0.000 vs +0.500), projecting wall/roof sheeting profiles and doors/windows, and placing dynamic downspout blocks (TT-Dowspout 2021-12-07-D) brought to front (DRAWORDER _F).
---

# Skill 4: Triển Khai Các Mặt Đứng Kiến Trúc Tổng Quát (`cad-arch-elevations`)

Skill này cung cấp quy trình và công thức tham số hóa tổng quát để dựng và hoàn thiện **4 Mặt đứng Kiến trúc (`ELEVATION 1` đến `ELEVATION 4`)** cho bất kỳ công trình nào trên AutoCAD.

---

## 1. Công Thức Ánh Xạ Hệ Trục Cho 4 Hướng Nhìn Mặt Đứng

Gọi $L_{\text{total}} = \max(\$X\_GRIDS)$ là tổng chiều dài nhà theo trục $X$ (từ Trục $1 \to n$) và $W_{\text{total}} = \max(\$Y\_GRIDS)$ là tổng chiều rộng nhà theo trục $Y$ (từ Trục $A \to m$). Với một mặt đứng bất kỳ có điểm gốc chân trục đầu tiên bên trái là $(O_X, O_Y)$, tọa độ $X_{\text{elev}}$ của từng trục đứng từ **Trái sang Phải** được tính theo công thức tổng quát:

| Mặt Đứng | Hướng Nhìn | Thứ Tự Trục (Trái $\to$ Phải) | Công Thức Tọa Độ Trục Đứng $X_{\text{elev}}(i)$ |
| :--- | :--- | :--- | :--- |
| **Mặt đứng Chính (`ELEVATION 1`)** | Nhìn từ biên Dưới (Trục A nhìn lên $+Y$) | Trục $1 \to 2 \to \dots \to n$ | $$X_{\text{elev}}(i) = O_X + \text{offX}_i$$ |
| **Mặt đứng Sau (`ELEVATION 4`)** | Nhìn từ biên Trên (Trục cuối nhìn xuống $-Y$) | Trục $n \to \dots \to 2 \to 1$ (**Đảo trục**) | $$X_{\text{elev}}(i) = O_X + \left(L_{\text{total}} - \text{offX}_i\right)$$ |
| **Mặt đứng Trái (`ELEVATION 2`)** | Nhìn từ biên Trái (Trục 1 nhìn sang $+X$) | Trục $m \to \dots \to B \to A$ (**Đảo trục**) | $$X_{\text{elev}}(j) = O_X + \left(W_{\text{total}} - \text{offY}_j\right)$$ |
| **Mặt đứng Phải (`ELEVATION 3`)** | Nhìn từ biên Phải (Trục $n$ nhìn sang $-X$) | Trục $A \to B \to \dots \to m$ | $$X_{\text{elev}}(j) = O_X + \text{offY}_j$$ |

> [!WARNING]
> Khi chiếu vị trí cửa đi, cửa sổ, cột, mái thấp từ Mặt bằng sang **Mặt đứng Sau (Elevation 4)** hoặc **Mặt đứng Trái (Elevation 2)**, mọi tọa độ cục bộ $x$ trên mặt bằng đều phải biến đổi qua phép đối xứng $x' = L_{\text{total}} - x$ (hoặc $y' = W_{\text{total}} - y$).

---

## 2. Hệ Thống Đường Gióng Cao Độ (`Level Lines`) & Mốc Cao Độ (`ATAD_LEVEL_TAG`)

### A. Công thức Dựng Đường Gióng Cao Độ (`DRAWORDER _B`)
Với mảng cao độ thiết kế `$LEVELS` $= [(z_1, \text{text}_1, \text{note}_1), (z_2, \text{text}_2, \text{note}_2), \dots]$ (trong đó $z_k$ tính bằng mm so với cốt $\pm 0.000$):
- Cao độ $Y$ trên mặt đứng của mốc thứ $k$:
  $$Y_{\text{level}}(k) = O_Y + z_k$$
- Đường gióng cao độ vẽ trên layer `"32 Gridline"` từ $X_{\text{left}} = O_X - 25.0 \times sc$ đến $X_{\text{right}} = O_X + B_{\text{elev}} + 10.0 \times sc$.
- **Quy tắc hiển thị bắt buộc:** Ngay sau khi vẽ đường gióng cao độ, phải gọi lệnh **`DRAWORDER _B` (Send to Back)** để đường lưới đỏ chìm xuống dưới, không cắt đứt nét tường, cửa và sóng tôn.

### B. Quy Tắc Tự Động Flip Âm Chống Đè Chữ Khi Hai Mốc Cao Độ Gần Nhau
- Trong hầu hết các công trình, cốt mặt đất tự nhiên `%%P0.000 (G.FL)` và cốt sàn tầng 1 `+0.100 / +0.500 (1.FL)` chỉ cách nhau $100 \div 500\text{ mm}$ ($< 8.0 \times sc$).
- Nếu cả hai mốc đều chèn với `Scale Y > 0`, hai ký hiệu tam giác cao độ sẽ **đè chồng lên nhau (clash)**.
- **Giải pháp tổng quát:**
  - Mốc dưới (`z_1 = 0`, cốt `%%P0.000`): Chèn với **`Scale Y = -sc` (`flip = T`)** để tam giác và chữ lật xuống phía dưới đường chuẩn.
  - Các mốc phía trên (`z_2, z_3...`): Chèn với **`Scale Y = +sc` (`flip = nil`)** hướng lên trên.

```lisp
;; Hàm tổng quát chèn hệ thống Đường cao độ & Block ATAD_LEVEL_TAG tự động chống clash
;; - ox, oy: Gốc tọa độ chân trục trái của mặt đứng (tại cốt 0.000)
;; - width: Tổng bề rộng mặt đứng (L_total hoặc W_total)
;; - sc: Hệ số tỉ lệ mặt đứng (150.0, 120.0, 100.0, 60.0...)
;; - levels: Danh sách '((0.0 "%%P0.000" "(G.FL)" T) (500.0 "+0.500" "(1.FL)" nil) ...)
(defun univ_elev_draw_levels (ox oy width sc levels / ms xTag xRight yLvl lyr ename o a)
  (vl-load-com)
  (setq ms     (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object)))
        xTag   (- ox (* 22.0 sc))
        xRight (+ ox width (* 10.0 sc)))

  (foreach item levels
    (setq yLvl (+ oy (nth 0 item)))
    ;; 1. Vẽ đường gióng cao độ trên layer "32 Gridline" và đẩy xuống dưới (Send to Back)
    (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(8 . "32 Gridline")
                   '(100 . "AcDbPolyline") '(90 . 2) '(70 . 0)
                   (cons 10 (list xTag yLvl)) (cons 10 (list xRight yLvl))))
    (setq ename (entlast))
    (command "_.DRAWORDER" ename "" "_B")

    ;; 2. Chèn Block ATAD_LEVEL_TAG (hỗ trợ flip âm Scale Y = -sc)
    (setq o (vla-InsertBlock ms (vlax-3d-point xTag yLvl 0.0)
                             "ATAD_LEVEL_TAG" sc (if (nth 3 item) (- sc) sc) sc 0.0))
    (vla-put-Layer o "0")
    (if (= (vla-get-HasAttributes o) :vlax-true)
      (foreach a (vlax-invoke o 'GetAttributes)
        (cond
          ((= (strcase (vla-get-TagString a)) "LEVEL") (vla-put-TextString a (nth 1 item)))
          ((= (strcase (vla-get-TagString a)) "NOTE")  (vla-put-TextString a (nth 2 item))))))))
```

---

## 3. Quy Chuẩn Dựng Tường, Sóng Tôn, Cửa & Ống Thoát Nước Đứng

1. **Tường xây, Vách tôn & Độ dốc mái trên Mặt đứng:**
   - Phần tường gạch từ cốt sàn lên đỉnh tường: Vẽ đường bao trên layer `"31 Drawing"`.
   - Phần vách tôn bao che và diềm mái: Rải các đường sóng tôn đứng cách đều nhau ($\Delta x \approx 200 \div 600\text{ mm}$) trên layer `"31 Drawing"` hoặc `"23 Tole Hatch"`.
   - Trên mặt đứng có mái dốc: Cao độ đỉnh mái tính chính xác theo công thức lượng giác từ cao độ diềm mái $Z_{\text{eave}}$ và góc dốc $\alpha$:
     $$Z_{\text{ridge}} = Z_{\text{eave}} + L_{\text{slope}} \times \tan(\alpha)$$
2. **Cửa đi, Cửa sổ & Cửa cuốn trên Mặt đứng:**
   - Gióng thẳng tọa độ từ Mặt bằng xuống Mặt đứng theo đúng quy tắc ánh xạ trục ở Mục 1.
   - Cửa kính: Vẽ khung bao kép và ký hiệu 3 nét chéo mảnh phản quang giữa tâm kính.
   - Cửa cuốn: Vẽ các đường nan ngang song song cách đều trong lòng cửa.
3. **Ống thoát nước mưa đứng (Dynamic Block `"TT-Dowspout 2021-12-07-D"`):**
   - Đặt tại đúng tọa độ các trục có phễu thu nước từ Mặt bằng mái chiếu xuống.
   - Thiết lập Dynamic Properties: `"Leng"` $= Z_{\text{gutter}} - Z_{\text{ground}}$ (chiều dài ống từ đáy máng xối xuống cốt nền $0.000$), `"Diameter"` $= 140.0$ (hoặc $100.0$).
   - **Bắt buộc gọi `DRAWORDER _F` (Bring to Front)** để ống thoát nước nổi rõ phía trước các đường sóng tôn đứng.

---

## 4. Bong Bóng Trục, Dim Chân Mặt Đứng & Tiêu Đề

- **Vị trí dưới chân mặt đứng (tính từ cốt $O_Y$ trở xuống):**
  - Lớp 1 (Dim nhịp trục): $Y_{\text{dim1}} = O_Y - 12.5 \times sc$.
  - Lớp 2 (Dim tổng bề rộng mặt đứng): $Y_{\text{dim2}} = O_Y - 21.0 \times sc$.
  - Hàng bong bóng trục `"ATAD_GRIDLINE_TAG"`: $Y_{\text{bubble}} = O_Y - 28.0 \times sc$.
  - Tiêu đề `"%%UELEVATION <k>"` (`Layer "12 Text-title"`, Height $= 5.0 \times sc$): $Y_{\text{title}} = O_Y - 45.0 \times sc$, kèm `"SCALE 1/<sc>"` (Height $= 3.0 \times sc$) bên dưới.

---

## 5. Checklist Kiểm Tra Nghiệm Thu (`Verification`)
- [ ] Thứ tự trục và vị trí cửa/mái trên Mặt đứng Sau (Elevation 4) và Mặt đứng Trái (Elevation 2) đã được đảo ngược đúng chiều nhìn thực tế.
- [ ] Mốc cao độ `%%P0.000` đã được flip âm (`Scale Y = -sc`), không đè lên mốc cốt sàn tầng 1.
- [ ] Toàn bộ đường gióng cao độ đỏ đã được đẩy xuống dưới (`DRAWORDER _B`).
- [ ] Các Dynamic Block ống thoát nước đứng có chiều dài `"Leng"` khớp với cao độ máng xối và nằm nổi phía trước sóng tôn (`DRAWORDER _F`).

---

## 6. Ví Dụ Minh Họa Tham Khảo (Từ Dự Án B02)
- **Elevation 1 & Elevation 4 (`Scale = 120.0`, DimStyle `"ATAD1-120"`, dài $36,600\text{ mm}$):** E1 có trục `1 -> 8`, E4 đảo trục `8 -> 1`; 5 mốc cao độ `0.000 (flip=T), +0.500, +4.500, +8.500, +11.200`.
- **Elevation 2 & Elevation 3 (`Scale = 60.0`, DimStyle `"ATAD1-80"`, rộng $14,000\text{ mm}$):** E2 nhìn vào Trục 1 (`C -> B -> A`, 3 ống thoát nước dài $8,500\text{ mm}$); E3 nhìn vào Trục 8 (`A -> B -> C`, 3 ống thoát nước mái thấp dài $4,500\text{ mm}$).
