# GEMINI WORKSPACE INSTRUCTIONS: HỆ THỐNG TRIỂN KHAI KIẾN TRÚC & BU LÔNG NEO TỔNG QUÁT

## 1. Quy tắc Master Rule & Khả năng Tái sử dụng cho Mọi Dự Án
- Thư mục `.agents/` chứa **Bộ Quy Chuẩn Tổng Quát (Universal CAD Deployment Standard)** có thể copy sang bất kỳ dự án AutoCAD mới nào để triển khai **Kiến trúc (Mặt bằng trệt, Mặt bằng mái, Mặt đứng 1–4)** và **Bu lông neo (Mặt bằng định vị & Chi tiết 1/10)**.
- **Đọc Master Rule bắt buộc tại:** `.agents/rules/cad-deployment-master-rule.md`.
- **Cẩm nang 91 công cụ AutoLISP thực chiến:** `docs/AI_AUTOLISP_GUIDE.md`.

## 2. Hệ thống 7 Skills Tổng Quát (`.agents/skills/`)
Khi triển khai bất kỳ hạng mục nào thuộc Kiến trúc hoặc Bu lông neo, AI **BẮT BUỘC** kích hoạt và đọc `SKILL.md` tương ứng:

### A. Nhóm 4 Skills Triển khai Kiến trúc Tổng quát
1. **`cad-arch-grid-frame`** (`.agents/skills/cad-arch-grid-frame/SKILL.md`): Tự động khảo sát thông số bản vẽ mẫu (`Auto-Discovery`), làm phẳng $Z=0$ (`ZZZ`), dọn hatch vỡ, dựng hệ lưới trục theo mảng `$X_GRIDS`, `$Y_GRIDS` bất kỳ và chèn khung bản vẽ căn thẳng hàng theo `$Y_BASELINE`.
2. **`cad-arch-ground-plan`** (`.agents/skills/cad-arch-ground-plan/SKILL.md`): Vẽ Mặt bằng tầng (Cột kết cấu, tường Closed Polyline + Hatch `LINE` $45^\circ$ theo `$SCALE`, đóng gói Block cửa đi/cửa sổ/cửa cuốn, thuật toán chia bậc cầu thang chuẩn $250\text{ mm}$, mirror các khu chức năng đối xứng như WC và đánh Dim 2 lớp).
3. **`cad-arch-roof-plan`** (`.agents/skills/cad-arch-roof-plan/SKILL.md`): Vẽ Mặt bằng mái (Đường bao mái chính/mái phụ/canopy theo độ đua `$OVERHANG`, diềm mái fascia $150\text{ mm}$, máng xối `WIPEOUT`, phễu thu nước $\varnothing 100$ tại giao điểm trục, tag độ dốc xoay theo vector thoát nước và Hatch tôn `STEEL`).
4. **`cad-arch-elevations`** (`.agents/skills/cad-arch-elevations/SKILL.md`): Vẽ Mặt đứng 1–4 (Ánh xạ thứ tự trục theo 4 hướng nhìn, đường gióng cao độ `DRAWORDER _B`, mốc cao độ tự động flip âm ở cốt $\pm 0.000$ chống đè chữ, sóng tôn/mái dốc/cửa và Dynamic Block ống thoát nước đứng `DRAWORDER _F`).

### B. Nhóm 3 Skills Triển khai Bu lông neo Tổng quát
5. **`cad-anchor-bolt-plan`** (`.agents/skills/cad-anchor-bolt-plan/SKILL.md`): Vẽ Mặt bằng định vị Bu lông neo (Khung view căn theo `$Y_BASELINE`, lưới trục & Dim ở Trên & Trái không text below dim, đặt Block chân cột đúng góc xoay $\theta$, thuật toán phân nhóm mã chi tiết `A1..An` theo bộ 3 khóa `(BlockType, Rotation, ElevationFFL)`, khoanh vùng nét đứt bo góc đa màu ACI, gắn tag lục giác `Scale = $SCALE` và mốc cao độ).
6. **`cad-anchor-detail-plan`** (`.agents/skills/cad-anchor-detail-plan/SKILL.md`): Vẽ Hình chiếu bằng Chi tiết Bản mã & Bu lông tỉ lệ 1/10 (Tự động dàn $N$ chi tiết vào các khung View 1/10 lưới 2x2 nét đứt `HIDDEN`, chèn trực tiếp Block chân cột đúng góc xoay trên mặt bằng, bong bóng trục ghép `"&"`, `"TO"`, Dim 2 lớp `"GB 1-10"` đối xứng `"="`, Leader mũi tên `_Open30` và tự động đặt ký hiệu vết mặt cắt song song bụng cột).
7. **`cad-anchor-detail-section`** (`.agents/skills/cad-anchor-detail-section/SKILL.md`): Vẽ Mặt cắt đứng Chân cột & Ghi chú Leader tỉ lệ 1/10 (Móng bê tông `23_Rc_GB` hatch `AR-CONC`, lớp vữa SikaGrout hatch `NET` $45^\circ$, bản mã thép, thân cột thép thẳng hoặc vát thu đáy + `Break line`, block bu lông mặt đứng, và 4 cụm ghi chú Leader + cao độ `FFL` căn thẳng hàng bên trái tại $X = sx - 620.0$ có nội suy tọa độ theo góc vát cánh cột).

## 3. Thông tin Riêng của Workspace Dự án Hiện tại (`LA635`)
- **File bản vẽ chính:** `LA325.dwg`
  - **Hàng trên ($Y > -42,000$):** Nhà giặt ủi **B01** (Tỉ lệ mặt bằng `1/150`, Chi tiết bu lông neo `1/10`, căn bằng đáy tại `$Y_BASELINE = -12,607.6 mm`).
  - **Hàng dưới ($Y < -42,000$):** Nhà bảo dưỡng **B02** (Tỉ lệ mặt bằng/mái `1/100`, Mặt đứng `1/120` & `1/60`, căn đỉnh khung tại `$Y_BASELINE = -32,608.0 mm`).
- **Thư viện 91 công cụ AutoLISP:** Đặt tại `scripts/lisp/` (gồm 9 module: `architecture/`, `structure/`, `annotation/`, `text_tables/`, `blocks/`, `cad_cleanup/`, `layers_views_print/`, `b01_standards/`, `b02_implementation/`).
