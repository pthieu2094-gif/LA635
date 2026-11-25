---
name: cad-anchor-detail-plan
description: >-
  Use this skill when deploying 1/10 scale Anchor Bolt Detail Plan Views (Hình chiếu bằng chi tiết bản mã & bu lông neo tỉ lệ 1/10) across multi-frame 2x2 grids in AutoCAD for any project: automatically partitioning N detail types into scale-10 view frames aligned to $Y_BASELINE with HIDDEN dashed dividers, inserting the exact structural column blocks from the location plan with 100% matching rotation (0° vs 90°), placing GB_GRIDLINE_TAG_1 axis bubbles with "&" / "TO" connectors, adding 2-layer GB 1-10 dimensions with "=" symmetry overrides, drawing _Open30 leaders for bolt/plate specs, and orienting the Section Cut symbol parallel to the column web.
---

# Skill 6: Triển Khai Hình Chiếu Bằng Chi Tiết Bản Mã & Bu Lông Tỉ Lệ 1/10 Tổng Quát (`cad-anchor-detail-plan`)

Skill này cung cấp quy trình và thuật toán tham số hóa tổng quát để dựng **Hình chiếu bằng (`DETAIL A1`..`DETAIL An`)** ở tỉ lệ **1/10** cho bất kỳ số lượng mã chi tiết bu lông neo $N$ nào của dự án kết cấu thép trên AutoCAD.

---

## 1. Thuật Toán Tự Động Dàn $N$ Chi Tiết Vào Các Khung View 1/10 (`Scale = 10.0`)

### A. Tính toán Số lượng Khung View 1/10 & Tọa độ Đặt Khung
- Mỗi khung bản vẽ tiêu chuẩn (`$FRAME_BLOCK`, ví dụ `"A$Ce291ec07"`) khi chèn ở **`Scale = 10.0`** có:
  - Bề rộng khung: $W_{10} = 5,817.0\text{ mm}$, Chiều cao khung: $H_{10} = 4,365.8\text{ mm}$.
  - Khoảng cách giữa 2 khung kế tiếp: $\text{FRAME\_GAP} = 1,500.0\text{ mm}$.
  - Tọa độ điểm chèn $Y_{\text{insert}}$ căn theo đáy dự án `$Y_BOTTOM`:
    $$Y_{\text{insert,10}} = Y_{\text{BOTTOM}} + 4,088.05\text{ mm}$$
- **Quy tắc chia lưới 2x2 (4 ô: `TL`, `TR`, `BL`, `BR`) trong mỗi khung:**
  - Mỗi khung chứa tối đa **4 ô chi tiết** theo thứ tự ưu tiên:
    $$\text{Slot } 0 \to \text{TL (Trên-Trái)}, \quad \text{Slot } 1 \to \text{TR (Trên-Phải)}, \quad \text{Slot } 2 \to \text{BL (Dưới-Trái)}, \quad \text{Slot } 3 \to \text{BR (Dưới-Phải)}$$
  - Riêng ở khung cuối cùng (hoặc khi ô `BR` chứa khung tên dự án), chừa trống ô `BR` (tối đa 3 chi tiết ở khung cuối).
  - Với danh sách $N$ mã chi tiết đã sắp xếp, chi tiết thứ $k$ ($k = 0, 1, \dots, N-1$) thuộc về:
    $$\text{ViewIndex} = \lfloor k / 4 \rfloor + 1, \quad \text{SlotPos} = [\text{"TL"}, \text{"TR"}, \text{"BL"}, \text{"BR"}][k \bmod 4]$$
    $$X_{\text{frame}}(\text{ViewIndex}) = X_{\text{view1}} + (\text{ViewIndex} - 1) \times (W_{10} + \text{FRAME\_GAP})$$

### B. Đường Nét Đứt Phân Chia Các Ô (`Layer "HIDDEN"`)
Bên trong mỗi khung View thứ $v$ có góc dưới bên trái là $(f_{X0}, f_{Y0}) = (X_{\text{frame}}(v),\ Y_{\text{BOTTOM}})$:
- Đường chia ngang giữa khung: Từ $(f_{X0},\ f_{Y0} + 2044.0)$ đến $(f_{X0} + 5817.0,\ f_{Y0} + 2044.0)$.
- Đường chia dọc nửa trên: Từ $(f_{X0} + 2908.5,\ f_{Y0} + 2044.0)$ đến $(f_{X0} + 2908.5,\ f_{Y0} + 4088.05)$.
- Đường chia dọc nửa dưới: Từ $(f_{X0} + 2398.0,\ f_{Y0})$ đến $(f_{X0} + 2398.0,\ f_{Y0} + 2044.0)$.

### C. Bảng Tọa Độ Offset Chuẩn Cho 4 Ô Trong Khung 1/10 (`getSlotOffsets`)
Tính từ góc dưới-trái $(f_{X0}, f_{Y0})$ của mỗi khung View 1/10, tọa độ tâm Hình chiếu bằng $(px, py)$, mốc Mặt cắt $(sx, sy)$ và vị trí đặt Tiêu đề của từng ô luôn cố định theo bảng chuẩn:

| Vị trí Ô (`pos`) | `planX` | `planY` | `secX` | `secY` | `planTitleX` | `planTitleY` | `secTitleX` | `secTitleY` |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`TL`** (Trên - Trái) | `867.0` | `3127.0` | `2176.0` | `3303.8` | `785.0` | `2542.2` | `2034.0` | `2542.8` |
| **`TR`** (Trên - Phải) | `3830.0` | `3127.0` | `5138.0` | `3303.8` | `3748.0` | `2542.2` | `4997.0` | `2542.8` |
| **`BL`** (Dưới - Trái) | `742.0` | `977.9` | `1853.0` | `1154.7` | `660.0` | `393.0` | `1712.0` | `393.7` |
| **`BR`** (Dưới - Phải) | `3210.0` | `977.9` | `4348.0` | `1154.7` | `3128.0` | `393.0` | `4207.0` | `393.7` |

---

## 2. Chèn Block Chân Cột & Biến Đổi Hình Học Theo Góc Xoay $\theta$

1. **Chèn trực tiếp Block chân cột từ Mặt bằng định vị:**
   - Gọi `vla-InsertBlock` chèn trực tiếp `dt.blockName` tại tâm $(px, py)$ với `Scale = 1.0` và góc xoay $\theta_{\text{rad}} = \text{rotDeg} \times \pi / 180$ (`0.0` hoặc `(/ pi 2.0)`).
   - Việc tái sử dụng chính Block của mặt bằng định vị đảm bảo hình dáng bản mã, sườn tăng cứng (stiffeners), tiết diện cột và vị trí lỗ bu lông khớp 100% với mặt bằng.
2. **Công thức Tổng quát Quy đổi Kích thước Bản mã & Tọa độ Bu lông Sau Khi Xoay:**
   Gọi `plL` là chiều dài bản mã (dọc theo chiều cao tiết diện cột `colH`), `plW` là bề rộng bản mã (dọc theo bề rộng cánh cột `colB`), và `(boltLocalX, boltLocalY)` là khoảng cách từ tâm cột đến bu lông ngoài cùng trong hệ tọa độ cục bộ của Block (ví dụ: `boltLocalX = 50`, `boltLocalY = 50` cho 4 bu lông hoặc `100` cho 6 bu lông):

```javascript
// Công thức tổng quát cho cả 2 trường hợp xoay 0° và 90°:
const isRot90 = (dt.rotDeg === 90 || dt.rotDeg === 270);

// 1. Kích thước phủ bì bản mã trên Hình chiếu bằng theo phương X và Y:
const sizeX = isRot90 ? dt.plL : dt.plW;
const sizeY = isRot90 ? dt.plW : dt.plL;
const hX    = sizeX / 2.0; // Nửa bề rộng bản mã theo phương X
const hY    = sizeY / 2.0; // Nửa chiều cao bản mã theo phương Y

// 2. Tọa độ tim bu lông ngoài cùng so với tâm (px, py):
const boltX = isRot90 ? dt.boltLocalY : dt.boltLocalX;
const boltY = isRot90 ? dt.boltLocalX : dt.boltLocalY;
```

---

## 3. Công Thức Vẽ Lưới Trục, Bong Bóng Trục Ghép (`&`, `TO`) & Dim 2 Lớp (`GB 1-10`)

### A. Đường Tim Trục & Bong Bóng Trục (`"GB_GRIDLINE_TAG_1"`, `Scale = 10.0`)
- **Đường tim trục ngang & dọc (`Layer "32 Gridline"`, màu `251`, nét `"DASHED"`):**
  - Ngang: Từ $(px - hX - 150.0,\ py)$ đến $(px + hX + 120.0,\ py)$.
  - Dọc: Từ $(px,\ py - hY - 135.0)$ đến $(px,\ py + hY + 120.0)$.
  - *(Khoảng nhô $150\text{ mm}$ bên trái và $135\text{ mm}$ bên dưới giúp đường trục vượt qua hoàn toàn 2 lớp Dim, không cắt vào chữ số kích thước).*
- **Bong bóng trục ngang bên trái (`yBubbles` tại $X_{\text{bub}} = px - hX - 192.5$):**
  - Với mảng `yBubbles` (ví dụ `["1", "&", "8"]` hoặc `["2", "TO", "4", "&", "7"]`):
    - Các phần tử ở chỉ số chẵn ($i = 0, 2, 4\dots$, thứ tự bong bóng $b = i/2$): Chèn block `"GB_GRIDLINE_TAG_1"` (`Scale = 10.0`) tại $(X_{\text{bub}},\ py + b \times 136.7)$.
    - Các phần tử ở chỉ số lẻ ($i = 1, 3\dots$, từ nối `"&"`, `"TO"`, `","`): Đặt Text (Height $= 22.0$, layer `"4_Text data_GB"`) tại $(X_{\text{conn}},\ py + b \times 136.7 + 58.0)$.
- **Bong bóng trục dọc bên dưới (`xBubbles` tại $Y_{\text{bub}} = py - hY - 177.5$):**
  - Nếu có 1 trục (`["A"]`): Đặt tại $(px,\ Y_{\text{bub}})$.
  - Nếu có dải trục (`["B", "TO", "H"]`): Đặt bong bóng 1 tại $(px,\ Y_{\text{bub}})$, chữ nối `"TO"` tại $(px + 75.0,\ Y_{\text{bub}} - 11.0)$, và bong bóng 2 tại $(px + 175.0,\ Y_{\text{bub}})$.

### B. Hệ Thống Dim 2 Lớp Đối Xứng (`Layer "8"`, DimStyle `"GB 1-10"`)
1. **Dim Dọc Bên Trái (`addVDim10`):**
   - **Lớp 1 ($X_{\text{dim1}} = px - hX - 50.0$):** Gồm 4 chuỗi kích thước liên tiếp вдоль theo cạnh trái bản mã $(px - hX)$:
     - Đoạn 1: $[py - hY \to py - boltY]$ $\implies$ Ghi `TextOverride = "="` (khoảng cách từ mép bản mã đến bu lông).
     - Đoạn 2: $[py - boltY \to py]$ $\implies$ Giá trị thực (`nil`).
     - Đoạn 3: $[py \to py + boltY]$ $\implies$ Giá trị thực (`nil`).
     - Đoạn 4: $[py + boltY \to py + hY]$ $\implies$ Ghi `TextOverride = "="`.
   - **Lớp 2 ($X_{\text{dim2}} = px - hX - 95.0$):** Dim tổng chiều cao bản mã từ $(py - hY)$ đến $(py + hY)$.
2. **Dim Ngang Bên Dưới (`addHDim10`):**
   - **Lớp 1 ($Y_{\text{dim1}} = py - hY - 60.0$):** Gồm 4 chuỗi kích thước liên tiếp dọc theo cạnh dưới bản mã $(py - hY)$:
     - $[px - hX \to px - boltX]$ (`"="`), $[px - boltX \to px]$ (`nil`), $[px \to px + boltX]$ (`nil`), $[px + boltX \to px + hX]$ (`"="`).
   - **Lớp 2 ($Y_{\text{dim2}} = py - hY - 105.0$):** Dim tổng bề rộng bản mã từ $(px - hX)$ đến $(px + hX)$.

---

## 4. Leader Ghi Chú Bu Lông/Bản Mã & Quy Tắc Xoay Ký Hiệu Vết Mặt Cắt (`Section Cut`)

### A. Leader Ghi Chú (`AB <n>M<d>` / `PL-<t>mm`)
- Điểm mũi tên đặt tại mép trên của bu lông góc trên-phải: $P_1 = (px + boltX,\ py + boltY + 10.0)$.
- Điểm gãy đứng lên trên bản mã: $P_2 = (px + boltX,\ py + hY + 115.0)$.
- Điểm cuối đường gạch chân sang phải: $P_3 = (px + boltX + 165.0,\ py + hY + 115.0)$.
- Tạo `AcDbLeader` (layer `"6_Dim_GB"`, style `"GB 1-10"`) kèm 2 nét mũi tên `_Open30` từ $P_1$ đến $(P_{1x} \pm 4.53,\ P_{1y} + 16.90)$.
- Đặt 2 dòng Text (Height $= 22.0$, layer `"4_Text data_GB"`, màu 7):
  - Dòng trên tại $(P_{2x} + 25.0,\ P_{2y} + 8.0)$: `"AB <nBolts>M<boltDia>"` (ví dụ `"AB 4M20"`, `"AB 6M20"`).
  - Dòng dưới tại $(P_{2x} + 25.0,\ P_{2y} - 28.0)$: `"PL-<plT>mm"` (ví dụ `"PL-16mm"`).

### B. Quy Tắc Đặt Ký Hiệu Vết Mặt Cắt (`Section Cut` — Luôn Song Song Với Bụng Cột)
Hình chiếu đứng (`SECTION`) luôn là mặt cắt nhìn vuông góc vào **bản bụng của cột thép** (để thấy rõ chiều cao tiết diện cột $H_c$ và độ vát cánh cột). Do đó, ký hiệu Vết mặt cắt trên Hình chiếu bằng **BẮT BUỘC phải đặt song song với bản bụng cột**:
- **Trường hợp 1 (`isRot90 = true` — Bụng cột nằm ngang theo phương $X$):**
  - Đặt Block vết mặt cắt **nằm ngang ($\theta_{\text{sec}} = 0.0\text{ rad}$)** ở phía dưới hình chiếu bằng tại $(px - 491.7,\ py - hY - 220.0)$, hai mũi tên chỉ thẳng lên trên.
- **Trường hợp 2 (`isRot90 = false` — Bụng cột nằm dọc theo phương $Y$):**
  - Xoay Block vết mặt cắt **$90^\circ$ ($\theta_{\text{sec}} = \pi / 2\text{ rad}$)** đặt ở **bên phải** hình chiếu bằng tại $(px + hX + 205.0,\ py - 491.7)$, hai mũi tên chỉ sang trái nhìn vào bụng cột; đồng thời gán `vla-put-Rotation att 0.0` cho Attribute `"SYMBOL1"` để chữ tên mặt cắt luôn đứng thẳng.

---

## 5. Checklist Kiểm Tra Nghiệm Thu (`Verification`)
- [ ] Tất cả các khung View 1/10 căn bằng đáy theo `$Y_BASELINE` và hiển thị tỷ lệ `1/10` ở góc trái trên.
- [ ] Block chân cột trên từng ô `DETAIL` là Block chèn trực tiếp từ mặt bằng định vị và có góc xoay khớp 100% với mặt bằng.
- [ ] Đường tim trục kéo vượt qua 2 lớp Dim, không cắt vào chữ số kích thước; các khoảng Dim bìa hai đầu hiển thị `"="`.
- [ ] Ký hiệu vết mặt cắt luôn nằm song song với bản bụng của cột thép (nằm ngang bên dưới khi cột xoay $90^\circ$, nằm dọc bên phải khi cột xoay $0^\circ$).

---

## 6. Ví Dụ Minh Họa Tham Khảo (Từ Dự Án B01)
- Dự án B01 có $N = 11$ mã chi tiết được tự động dàn vào **3 Khung View 1/10** tại $X_1 = 444,000.0$ (`A1, A2, A2A, A3`), $X_2 = 451,317.0$ (`A3A, A4, A5, A5A`), $X_3 = 458,634.0$ (`A6, A7, A7A`, chừa ô `BR` cho khung tên), căn đáy tại $Y_{\text{BOTTOM}} = -12,607.6\text{ mm}$. Chi tiết `A2` xoay $0^\circ$ có vết mặt cắt đặt dọc bên phải; 10 chi tiết còn lại xoay $90^\circ$ có vết mặt cắt đặt ngang bên dưới.
