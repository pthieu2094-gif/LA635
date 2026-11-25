---
name: cad-anchor-detail-section
description: >-
  Use this skill when deploying 1/10 scale Anchor Bolt Section Views and Technical Leaders (Mặt cắt đứng chi tiết chân cột & bu lông neo tỉ lệ 1/10) in AutoCAD for any project: drawing parameterized concrete pedestals with AR-CONC hatch on layer 23_Rc_GB, non-shrink SikaGrout layer with 45-degree NET hatch on layer 25_Sikagrout_GB, steel base plates, straight vs tapered column stubs with top break-lines, elevation anchor bolt blocks (ABM20/ABM24), and the left-aligned 4-group leader annotation system (STEEL COLUMN with linear taper interpolation, ATAD_LEVEL_TAG FFL elevation, SIKAGROUT / (BY OTHERS), and ANCHOR BOLT pointing to the leftmost bolt).
---

# Skill 7: Triển Khai Mặt Cắt Đứng Chân Cột & Ghi Chú Leader Tỉ Lệ 1/10 Tổng Quát (`cad-anchor-detail-section`)

Skill này cung cấp quy trình và công thức tham số hóa tổng quát để dựng **Hình chiếu đứng / Mặt cắt (`SECTION A1`..`SECTION An`)** ở tỉ lệ **1/10** cùng hệ thống **4 cụm ghi chú Leader kỹ thuật** cho mọi dự án kết cấu thép trên AutoCAD.

---

## 1. Hệ Tham Số Hình Học Mặt Cắt Chân Cột (Parameterized Section Model)

Mọi mặt cắt chân cột được định vị từ điểm gốc $(sx,\ sy = ftgTop)$, trong đó $sx$ là tọa độ $X$ của tim trục cột và $ftgTop$ là cao độ $Y$ của mặt trên cổ móng bê tông:

| Tham số | Ký hiệu | Giá trị Chuẩn / Mặc định | Ý nghĩa Kỹ thuật |
| :--- | :--- | :---: | :--- |
| **Chiều rộng & Cao cổ móng** | `ftgW`, `ftgH` | $500.0 \times 340.0\text{ mm}$ | Kích thước khối cổ cột/móng bê tông hiển thị trên mặt cắt |
| **Chiều dày lớp vữa** | `sikH` | $50.0\text{ mm}$ | Chiều dày lớp vữa không co ngót SikaGrout (rộng bằng bản mã `plL`) |
| **Chiều dài & Dày bản mã** | `plL`, `plT` | Theo từng cột (VD: $t_p = 16\text{ mm}$) | Kích thước bản mã thép chân cột trên mặt cắt |
| **Chiều cao tiết diện cột** | `colH` | Theo từng cột ($250 \div 600\text{ mm}$) | Khoảng cách giữa 2 mép trong bản cánh cột tại chân bản mã |
| **Chiều cao đoạn cột cắt** | `colStubH` | $560.0\text{ mm}$ | Chiều cao đoạn thân cột thép vẽ từ mặt trên bản mã tới đường cắt `Break line` |
| **Cờ cột vát & Độ mở vát** | `isTapered`, `taperShift` | `false`/`true`, $50.0\text{ mm}$ | Độ mở rộng nghiêng sang trái của bản cánh ngoài từ chân cột lên đỉnh `colStubH` |
| **Tọa độ các hàng bu lông** | `boltXs` | `[-50, 50]` hoặc `[-100, 0, 100]` | Danh sách khoảng cách từ tim cột $sx$ đến từng hàng bu lông trên mặt cắt |
| **Cao độ hoàn thiện chân cột** | `ffl` | `"+0.100"` hoặc `"+0.000"` | Giá trị cao độ ghi trong Block `"ATAD_LEVEL_TAG"` |

---

## 2. Công Thức Dựng 5 Lớp Cấu Tạo Mặt Cắt Chân Cột (Từ Dưới Lên Trên)

```text
                        ▲ Y
 colTop = ftgTop + 626  │        ╱───────────────╲======== (Đường cắt Break line - Layer: 21 Dim)
                        │       ╱ │             │ │
     Thân cột thép      │      ╱  │  Cột vát    │ │  isTapered = false: taperShift = 0
  (colStubH = 560mm)    │     ╱   │  hoặc thẳng │ │  isTapered = true : cánh trái vát taperShift (50mm)
                        │    ╱    │             │ │
plateTop = ftgTop + 66  ├───┴─────┴─────────────┴─┴───┐
     Bản mã (plT)       │     Layer: 42 Steel plate   │ (Rộng = plL = 2 * secHl)
groutTop = ftgTop + 50  ├─────────────────────────────┤
   SikaGrout (sikH)     │  Hatch: NET 45°, Scale 5.0  │ (Rộng = plL, Layer: 25_Sikagrout_GB)
     ftgTop = sy        ├───────┬─────────────┬───────┤
                        │       │   ║     ║   │       │
   Cổ móng Bê tông      │       │   ║     ║   │       │ (Block bu lông ABM20 tại sx + bx)
    (ftgW x ftgH)       │       │   ╚═   ═╝   │       │ (Hatch: AR-CONC, Scale 1.0, Layer: 23_Rc_GB)
ftgBottom = sy - ftgH   └───────┴──────┼──────┴───────┘
                                       │ (Tim trục DASHED + Bong bóng trục GB_GRIDLINE_TAG_1)
```

### Công thức Tọa độ Từng Thành Phần:
1. **Cổ móng bê tông (`Layer "23_Rc_GB"`, màu `8`):**
   - Hình chữ nhật `Closed LWPOLYLINE`: $[sx - \text{ftgW}/2,\ sx + \text{ftgW}/2] \times [\text{ftgTop} - \text{ftgH},\ \text{ftgTop}]$.
   - Hatch bê tông: Pattern **`"AR-CONC"`**, `PatternScale = 1.0`, `PatternAngle = 0.0`, layer `"23_Rc_GB"`.
2. **Lớp vữa SikaGrout (`sikH = 50.0 mm`):**
   - Gọi $\text{secHl} = \text{plL} / 2.0$.
   - Hình chữ nhật `Closed LWPOLYLINE` (layer `"31 Drawing"`): $[sx - \text{secHl},\ sx + \text{secHl}] \times [\text{ftgTop},\ \text{groutTop}]$ với $\text{groutTop} = \text{ftgTop} + \text{sikH}$.
   - Hatch vữa: Pattern **`"NET"`**, `PatternAngle = (/ pi 4.0)` ($45^\circ$), `PatternScale = 5.0`, layer `"25_Sikagrout_GB"`.
3. **Bản mã chân cột (`Layer "42 Steel plate"`):**
   - Hình chữ nhật `Closed LWPOLYLINE`: $[sx - \text{secHl},\ sx + \text{secHl}] \times [\text{groutTop},\ \text{plateTop}]$ với $\text{plateTop} = \text{groutTop} + \text{plT}$.
4. **Thân cột thép (Hỗ trợ Cột Thẳng & Cột Vát) + Đường cắt `Break line`:**
   - Tọa độ bản cánh tại mặt trên bản mã ($\text{plateTop}$):
     $$x_{\text{in}} = \frac{\text{colH}}{2.0}, \quad x_{\text{out}} = \text{secHl} - 10.0$$
   - Tọa độ bản cánh trái tại đỉnh đoạn cắt ($\text{colTop} = \text{plateTop} + \text{colStubH}$):
     $$\Delta_{\text{top}} = \begin{cases} \text{taperShift} & \text{nếu } \text{isTapered} = \text{true} \\ 0.0 & \text{nếu } \text{isTapered} = \text{false} \end{cases}$$
     $$X_{\text{topLeftOut}} = sx - x_{\text{out}} - \Delta_{\text{top}}, \quad X_{\text{topLeftIn}} = sx - x_{\text{in}} - \Delta_{\text{top}}$$
   - Vẽ tứ giác bao ngoài thân cột (`mkQuad` trên layer `"31 Drawing"`) qua 4 đỉnh:
     $$(sx - x_{\text{out}},\ \text{plateTop}) \to (sx + x_{\text{out}},\ \text{plateTop}) \to (sx + x_{\text{out}},\ \text{colTop}) \to (X_{\text{topLeftOut}},\ \text{colTop})$$
   - Vẽ 2 đường mép trong bản cánh trên layer `"33 Flange steel"`:
     - Cánh trái: $(sx - x_{\text{in}},\ \text{plateTop}) \to (X_{\text{topLeftIn}},\ \text{colTop})$.
     - Cánh phải: $(sx + x_{\text{in}},\ \text{plateTop}) \to (sx + x_{\text{in}},\ \text{colTop})$.
   - Vẽ đường cắt zíc-zắc `mkBreakLine10` trên layer `"21 Dim"` từ $X_{\text{topLeftOut}} - 26.6$ đến $sx + x_{\text{out}} + 26.6$ tại cao độ $\text{colTop}$.
5. **Block Bu lông neo Mặt đứng (`"ABM20"` / `"ABM24"`) & Tim trục móng:**
   - Với mỗi tọa độ $b_x \in \text{boltXs}$: Chèn block bu lông mặt đứng tại $(sx + b_x,\ \text{groutTop} - 3.0)$.
   - Vẽ đường tim trục đứng nét `"DASHED"` trên layer `"32 Gridline"` từ $(\text{ftgBottom} - 100.0)$ tới $\text{plateTop}$, kèm bong bóng trục `"GB_GRIDLINE_TAG_1"` (`Scale = 10.0`) tại $Y = \text{ftgBottom} - 142.5$ đồng bộ với trục dọc của Hình chiếu bằng.

---

## 3. Công Thức Tổng Quát Cho Hệ Thống 4 Cụm Ghi Chú Leader Căn Thẳng Hàng Bên Trái

Toàn bộ 4 cụm ghi chú kỹ thuật của mặt cắt đặt ở phía bên trái cột, **căn lề trái thẳng hàng tuyệt đối**:
- **Đường gióng lề trái của chữ (`textBaseX`):** $X_{\text{textBase}} = sx - 620.0\text{ mm}$.
- **Đường gióng điểm gãy Leader (`doglegX`):** $X_{\text{dogleg}} = sx - 405.0\text{ mm}$ (chiều dài đường gạch chân landing line $= 215.0\text{ mm}$).

```text
[sx - 620.0]            [sx - 405.0]                   [Cột / Móng tại sx]
     |                       |                                  |
     STEEL COLUMN            |                                  |
     ------------------------+--------------------------------->| Mép cánh trái cột (tự động nội suy góc vát)
     
                        [sx - 440.0]
     FFL <dt.ffl>            |
     ----------------------- ▼ (Block ATAD_LEVEL_TAG Scale 10)
                             ==================================>| Mặt trên móng bê tông (ftgTop)
     
     SIKAGROUT               |
     ------------------------+
     (BY OTHERS)              \
                               `------------------------------->| Giữa lớp vữa SikaGrout (ftgTop + sikH/2)
     
     ANCHOR BOLT             |
     ------------------------+--------------------------------->| Thân bu lông ngoài cùng bên trái
```

### Công Thức Tọa Độ Chính Xác Của 4 Cụm Ghi Chú:

1. **Cụm 1 — `STEEL COLUMN` (Tự động nội suy tọa độ theo góc vát cánh cột):**
   - Cao độ đặt đường Leader: $Y_{\text{colLeader}} = \text{plateTop} + \Delta Y_{\text{leader}}$ (chuẩn $\Delta Y_{\text{leader}} = 330.0\text{ mm}$).
   - **Công thức nội suy tuyến tính tọa độ $X$ của mép ngoài cánh trái cột tại cao độ $Y_{\text{colLeader}}$:**
     $$\Delta_{\text{taperAtLeader}} = \begin{cases} \text{taperShift} \times \dfrac{\Delta Y_{\text{leader}}}{\text{colStubH}} & \text{nếu } \text{isTapered} = \text{true} \\ 0.0 & \text{nếu } \text{isTapered} = \text{false} \end{cases}$$
     $$X_{\text{colLeft}} = sx - \left(x_{\text{out}} + \Delta_{\text{taperAtLeader}}\right)$$
   - Vẽ Leader ngang: $(X_{\text{colLeft}},\ Y_{\text{colLeader}}) \to (sx - 405.0,\ Y_{\text{colLeader}}) \to (sx - 620.0,\ Y_{\text{colLeader}})$.
   - Đặt Text `"STEEL COLUMN"` (Height $= 22.0$, layer `"4_Text data_GB"`, màu 7) tại $(sx - 620.0,\ Y_{\text{colLeader}} + 5.5)$.

2. **Cụm 2 — Ký hiệu Cao độ `FFL` (`Block "ATAD_LEVEL_TAG"`, `Scale = 10.0`):**
   - Chèn Block `"ATAD_LEVEL_TAG"` (`Scale = 10.0`, layer `"31 Drawing"`) tại $(sx - 440.0,\ \text{ftgTop})$.
   - Gán Attribute `"NOTE" = "FFL"` và `"LEVEL" = dt.ffl` (ví dụ `"+0.100"` hoặc `"+0.000"`).
   - Vẽ đường gióng mặt móng trên layer `"32 Gridline"` từ $(sx - 440.0,\ \text{ftgTop})$ đến $(sx - \text{secHl},\ \text{ftgTop})$.

3. **Cụm 3 — `SIKAGROUT / (BY OTHERS)` (2 dòng chữ kẹp landing line ở giữa):**
   - Đầu mũi tên đặt trong lòng lớp vữa: $P_{\text{sika}} = (sx - \text{secHl} + 40.0,\ \text{ftgTop} + \text{sikH}/2.0)$.
   - Cao độ đường gạch chân: $Y_{\text{sikaLanding}} = \text{ftgTop} - 86.8\text{ mm}$.
   - Vẽ Leader xiên: $P_{\text{sika}} \to (sx - 405.0,\ \text{ftgTop} - 86.8) \to (sx - 620.0,\ \text{ftgTop} - 86.8)$.
   - Đặt dòng 1 `"SIKAGROUT"` tại $(sx - 620.0,\ \text{ftgTop} - 80.0)$ và dòng 2 `"(BY OTHERS)"` tại $(sx - 620.0,\ \text{ftgTop} - 119.3)$.

4. **Cụm 4 — `ANCHOR BOLT` (Trỏ thẳng vào bu lông ngoài cùng bên trái):**
   - Tọa độ $X$ của bu lông gần nhất bên trái:
     $$X_{\text{leftmostBolt}} = sx + \min(\text{boltXs}) \quad (\text{Ví dụ: } sx - 50.0 \text{ hoặc } sx - 100.0)$$
   - Cao độ đường Leader: $Y_{\text{boltLanding}} = \text{ftgTop} - 180.0\text{ mm}$.
   - Vẽ Leader ngang: $(X_{\text{leftmostBolt}},\ \text{ftgTop} - 180.0) \to (sx - 405.0,\ \text{ftgTop} - 180.0) \to (sx - 620.0,\ \text{ftgTop} - 180.0)$.
   - Đặt Text `"ANCHOR BOLT"` tại $(sx - 620.0,\ \text{ftgTop} - 174.5)$.

---

## 4. Checklist Kiểm Tra Nghiệm Thu (`Verification`)
- [ ] Cột thẳng (`isTapered = false`) có 2 cánh đứng song song; cột vát (`isTapered = true`) có cánh trái mở rộng sang trái và đầu mũi tên `STEEL COLUMN` chạm khít mép cánh vát (nhờ công thức nội suy $\Delta_{\text{taperAtLeader}}$).
- [ ] Cổ móng bê tông có Hatch `"AR-CONC"` trên layer `"23_Rc_GB"`; lớp vữa SikaGrout có Hatch `"NET"` $45^\circ$ trên layer `"25_Sikagrout_GB"`.
- [ ] Block `"ATAD_LEVEL_TAG"` hiển thị đúng cốt cao độ thực tế của từng chi tiết (`+0.100`, `+0.000`...).
- [ ] Mũi tên `ANCHOR BOLT` trỏ đúng vào thân bu lông ngoài cùng bên trái ($sx + \min(\text{boltXs})$).
- [ ] Toàn bộ 4 cụm chữ bên trái Mặt cắt căn lề trái thẳng hàng tuyệt đối tại $X = sx - 620.0\text{ mm}$.

---

## 5. Ví Dụ Minh Họa Tham Khảo (Từ Dự Án B01)
- Trong 11 chi tiết của dự án B01:
  - Nhóm **Cột thẳng (`isTapered = false`)**: `A1` ($250\times 165$), `A2` & `A2A` ($250\times 150$), `A4` ($400\times 185$, 6 bu lông `boltXs = [-100, 0, 100]`), `A6` ($400\times 250$, 6 bu lông).
  - Nhóm **Cột vát thu đáy (`isTapered = true`, `taperShift = 50.0 mm`)**: `A3` & `A3A` ($(300-600)\times 150$), `A5` & `A5A` ($(300-480-600)\times 165$), `A7` & `A7A` ($(300-480-600)\times 185$).
  - Nhóm **Hạ cos `FFL +0.000`**: `A3A` (Trục `A/6`), `A5A` (Trục `I/3`), `A7A` (Trục `I/4`).
