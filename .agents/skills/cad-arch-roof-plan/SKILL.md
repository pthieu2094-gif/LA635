---
name: cad-arch-roof-plan
description: >-
  Use this skill when drawing or editing an architectural Roof Plan in AutoCAD for any project: generating main roof, lower roof, and canopy outlines from grid bounds plus overhangs ($OVERHANG), offsetting 150mm fascia inner boundaries, creating gutter wipeouts ($GUTTER_W = 200mm) on layer 41 Steel section, placing Ø100 downspouts at grid intersections along gutter centerlines, inserting ATAD_SLOPE_TOP slope arrows oriented along drainage vectors, applying STEEL roof hatch on layer 23 Tole Hatch, and adding 4-side roof dimensions.
---

# Skill 3: Triển Khai Mặt Bằng Mái Tổng Quát (`cad-arch-roof-plan`)

Skill này cung cấp quy trình và công thức tham số hóa tổng quát để dựng **Mặt bằng Mái (`ROOF PLAN`)** cho bất kỳ công trình nhà công nghiệp, nhà xưởng hoặc nhà phụ trợ nào trên AutoCAD.

---

## 1. Cấu Trúc Hình Học & Hệ Tham Số Mặt Bằng Mái

Mặt bằng mái được đặt bên phải Mặt bằng tầng trệt với khoảng dịch ngang $\Delta X_{\text{roof}}$ và **gióng thẳng hàng tuyệt đối theo phương $Y$ (các trục ngang A, B, C...)** với Mặt bằng tầng trệt.

### Bảng Tham Số Thiết Kế Mái (Roof Parameters):
| Tham số | Ký hiệu | Giá trị Chuẩn / Mặc định | Ý nghĩa Kỹ thuật |
| :--- | :--- | :---: | :--- |
| **Gốc tọa độ Mái** | $(P_{X,\text{roof}}, P_Y)$ | $(P_X + \Delta X_{\text{roof}},\ P_Y)$ | Giao điểm Trục 1 và Trục A trên Mặt bằng mái |
| **Độ đua mái (Overhang)** | `$OVERHANG` ($O_{\text{left}}, O_{\text{right}}, O_{\text{top}}, O_{\text{bot}}$) | $500 \div 1,000\text{ mm}$ | Khoảng vươn của mép mái ra ngoài tim trục biên |
| **Bề rộng Diềm mái (Fascia)** | `$FASCIA_W` ($w_f$) | $150.0\text{ mm}$ | Khoảng offset từ mép ngoài mái vào đường viền trong ở các cạnh không có máng xối |
| **Bề rộng Máng xối (Gutter)** | `$GUTTER_W` ($w_g$) | $200.0\text{ mm}$ | Bề rộng lòng máng xối thu nước mưa dọc theo cạnh thấp của mái |
| **Bán kính Ống thoát nước** | `$SPOUT_R` ($r_s$) | $50.0\text{ mm}$ ($\varnothing 100$) | Bán kính phễu thu nước mưa đặt tại tim máng xối giao với các trục |
| **Độ dốc mái & Hướng dốc** | `$SLOPE_STR`, $\theta_{\text{slope}}$ | `"SLOPE 3%%d"`..`"10%"` | Giá trị độ dốc và góc xoay mũi tên thoát nước ($0^\circ, 90^\circ, 180^\circ, 270^\circ$) |

---

## 2. Công Thức Dựng Đường Bao Mái, Diềm Mái (`Fascia`), Máng Xối (`Wipeout`) & Ống Thoát Nước

Giả sử một khối mái (Mái chính hoặc Mái phụ) giới hạn bởi vùng lưới trục $[X_{\text{grid,min}},\ X_{\text{grid,max}}] \times [Y_{\text{grid,min}},\ Y_{\text{grid,max}}]$ và có độ đua mái 4 phía $(O_L, O_R, O_B, O_T)$:

### A. Tọa độ Đường Bao Ngoài Mái (`Outer Roof Boundary` — Layer `"31 Drawing"`)
$$X_{\min} = X_{\text{grid,min}} - O_L, \quad X_{\max} = X_{\text{grid,max}} + O_R$$
$$Y_{\min} = Y_{\text{grid,min}} - O_B, \quad Y_{\max} = Y_{\text{grid,max}} + O_T$$

### B. Tọa độ Máng Xối (`Gutter Wipeout` — Layer `"41 Steel section"`) & Phễu Thu Nước ($\varnothing 100$)
1. **Trường hợp Mái dốc thu nước về Cạnh Trái ($X_{\min}$):**
   - Vùng Máng xối (`WIPEOUT` trên layer `"41 Steel section"`):
     $$[X_{\min},\ X_{\min} + w_g] \times [Y_{\min},\ Y_{\max}] \quad (\text{với } w_g = 200.0\text{ mm})$$
   - Đường viền trong Diềm mái (`Fascia Inner Polyline` trên layer `"31 Drawing"`):
     $$[X_{\min} + w_g,\ X_{\max} - w_f] \times [Y_{\min} + w_f,\ Y_{\max} - w_f] \quad (\text{với } w_f = 150.0\text{ mm})$$
   - Tọa độ tâm các Ống thoát nước mưa (`CIRCLE` bán kính $R = 50.0\text{ mm}$ trên layer `"31 Drawing"`):
     $$\left(X_{\min} + \frac{w_g}{2},\ Y_{\text{grid},j}\right) \quad \forall Y_{\text{grid},j} \in \$Y\_GRIDS$$
2. **Trường hợp Mái dốc thu nước về Cạnh Phải ($X_{\max}$):**
   - Vùng Máng xối (`WIPEOUT`): $[X_{\max} - w_g,\ X_{\max}] \times [Y_{\min},\ Y_{\max}]$.
   - Tâm Ống thoát nước mưa: $\left(X_{\max} - \frac{w_g}{2},\ Y_{\text{grid},j}\right)$.
3. **Trường hợp Mái 2 dốc thu nước về Cạnh Trên ($Y_{\max}$) & Cạnh Dưới ($Y_{\min}$):**
   - Vùng Máng xối đặt dọc theo $[Y_{\min},\ Y_{\min} + w_g]$ và $[Y_{\max} - w_g,\ Y_{\max}]$.
   - Tâm Ống thoát nước đặt tại giao điểm tim máng xối với các trục đứng $X_{\text{grid},i} \in \$X\_GRIDS$.

---

## 3. Quy Tắc Đặt Block Độ Dốc (`ATAD_SLOPE_TOP`) & Hatch Tôn Mái (`23 Tole Hatch`)

### A. Block Ký Hiệu Độ Dốc Mái (`"ATAD_SLOPE_TOP"`)
- **Layer:** `"21 Dim"`, tỉ lệ chèn `Scale X = Scale Y = Scale Z = sc` (`$SCALE`).
- **Quy tắc Góc xoay $\theta_{\text{slope}}$ theo hướng chảy về máng xối:**
  - Chảy sang **Phải** ($+X$): $\theta_{\text{slope}} = 0.0\text{ rad}$ ($0^\circ$).
  - Chảy lên **Trên** ($+Y$): $\theta_{\text{slope}} = \pi / 2\text{ rad}$ ($90^\circ$).
  - Chảy sang **Trái** ($-X$): $\theta_{\text{slope}} = \pi\text{ rad}$ ($180^\circ$).
  - Chảy xuống **Dưới** ($-Y$): $\theta_{\text{slope}} = -\pi / 2\text{ rad}$ ($270^\circ$).
- **Attribute `"SLOPE"`:** Ghi độ dốc theo thiết kế (dùng `%%d` cho ký hiệu độ: `"SLOPE 3%%d"`, `"SLOPE 2%%d"`, hoặc `"SLOPE 10%"`).

### B. Hatch Sóng Tôn Mái (`"23 Tole Hatch"`)
- **Layer:** `"23 Tole Hatch"`.
- **Pattern Name:** `"STEEL"`.
- **Pattern Angle:** Song song với hướng dốc thoát nước:
  - Mái dốc sang Trái / Phải: `PatternAngle = 0.0`.
  - Mái dốc lên Trên / Dưới: `PatternAngle = (/ pi 2.0)` ($90^\circ$).
- **Pattern Scale:** `0.5 * sc` (Ví dụ: `50.0` cho bản vẽ `1/100`).
- **Vùng Hatch:** Chỉ hatch bên trong đường **Fascia Inner Boundary** (không bao giờ hatch đè lên vùng máng xối `WIPEOUT`).

---

## 4. Mẫu Hàm AutoLISP Tổng Quát Triển Khai Mặt Bằng Mái

```lisp
;; 1. Hàm tạo máng xối bằng WIPEOUT trên layer "41 Steel section"
(defun univ_roof_gutter_wipeout (pts / ename)
  (vl-load-com)
  (entmake (append (list '(0 . "LWPOLYLINE")
                         '(100 . "AcDbEntity")
                         '(8 . "41 Steel section")
                         '(100 . "AcDbPolyline")
                         (cons 90 (length pts))
                         '(70 . 1))
                   (mapcar '(lambda (p) (cons 10 p)) pts)))
  (setq ename (entlast))
  (command "_.WIPEOUT" "_P" ename "_Y")
  (entlast))

;; 2. Hàm tạo Hatch tôn mái STEEL trên layer "23 Tole Hatch"
(defun univ_roof_tole_hatch (pts ang sc / ename)
  (vl-load-com)
  (entmake (append (list '(0 . "LWPOLYLINE")
                         '(100 . "AcDbEntity")
                         '(8 . "23 Tole Hatch")
                         '(100 . "AcDbPolyline")
                         (cons 90 (length pts))
                         '(70 . 1))
                   (mapcar '(lambda (p) (cons 10 p)) pts)))
  (setq ename (entlast))
  (setvar "HPNAME" "STEEL")
  (setvar "HPANG" ang)
  (setvar "HPSCALE" (* 0.5 sc))
  (command "_.-HATCH" "_S" ename "" "")
  (entdel ename))

;; 3. Hàm chèn Block độ dốc mái ATAD_SLOPE_TOP theo góc hướng thoát nước
(defun univ_roof_slope_tag (pt sc rotRad slopeStr / ms o a)
  (vl-load-com)
  (setq ms (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))
  (setq o (vla-InsertBlock ms (vlax-3d-point (car pt) (cadr pt) 0.0) "ATAD_SLOPE_TOP" sc sc sc rotRad))
  (if (tblsearch "LAYER" "21 Dim") (vla-put-Layer o "21 Dim"))
  (if (= (vla-get-HasAttributes o) :vlax-true)
    (foreach a (vlax-invoke o 'GetAttributes)
      (if (= (strcase (vla-get-TagString a)) "SLOPE")
        (vla-put-TextString a slopeStr))))
  o)
```

---

## 5. Checklist Kiểm Tra Nghiệm Thu (`Verification`)
- [ ] Mặt bằng mái có các trục ngang (`A, B, C...`) gióng thẳng hàng theo phương $Y$ với Mặt bằng tầng trệt.
- [ ] Đầy đủ bong bóng trục và 2 lớp Dim ở cả 4 phía (Trên, Dưới, Trái, Phải).
- [ ] Có đường viền trong của diềm mái (Fascia offset $150\text{ mm}$) và vùng máng xối `WIPEOUT` rộng $200\text{ mm}$ trên layer `"41 Steel section"`.
- [ ] Đầy đủ vòng tròn phễu thu nước mưa $\varnothing 100$ ($R = 50$) tại tâm máng xối giao với các trục.
- [ ] Mũi tên `"ATAD_SLOPE_TOP"` trỏ đúng về phía máng xối và Hatch `"STEEL"` nằm gọn trong lòng mái (không tràn vào máng xối).

---

## 6. Ví Dụ Minh Họa Tham Khảo (Từ Dự Án B02)
- **Mặt bằng mái B02 (`Scale = 100.0`, gốc $P_{X,\text{roof}} = 90,000$):**
  - **Mái chính (Trục 1..7):** Bao ngoài $[89000, 121100] \times [-60500, -44500]$; máng xối trái `WIPEOUT` tại $X \in [89000, 89200]$; 3 ống thoát nước $\varnothing 100$ tại $X = 89100$ giao Trục A, B, C; độ dốc `"SLOPE 3%%d"` xoay $\pi$ ($180^\circ$).
  - **Mái thấp (Trục 7..8):** Bao ngoài $[120600, 127600] \times [-59500, -45500]$; máng xối phải `WIPEOUT` tại $X \in [127400, 127600]$; độ dốc `"SLOPE 2%%d"` xoay $0.0$ ($0^\circ$).
