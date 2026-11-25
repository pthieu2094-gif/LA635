# MASTER RULE: QUY CHUẨN TỔNG QUÁT TRIỂN KHAI KIẾN TRÚC & BU LÔNG NEO TRÊN AUTOCAD

Bộ quy tắc tổng quát (Universal CAD Deployment Standard) này áp dụng cho **tất cả các dự án nhà công nghiệp, nhà xưởng tiền chế và nhà phụ trợ** khi triển khai hồ sơ **Kiến trúc (Architecture)** và **Bu lông neo chân cột (Anchor Bolt Plan & Details)** trên AutoCAD thông qua Antigravity AI.

Khi tiếp nhận bất kỳ dự án mới nào, AI **BẮT BUỘC** tuân thủ quy trình tham số hóa dưới đây và kích hoạt đúng các **Skill chuyên biệt** trong `.agents/skills/`.

---

## 1. Bảng Điều phối Tự động 7 Skills Chuyên ngành (`.agents/skills/`)

Trước khi viết mã AutoLISP (`.lsp`), Python COM (`.py`) hoặc Node.js Generator (`.mjs`) cho bất kỳ hạng mục nào, AI **BẮT BUỘC** đọc file `SKILL.md` tương ứng:

### A. Nhóm 4 Skills Triển khai Kiến trúc (Architecture Deployment)
| STT | Tên Skill | Đường dẫn | Khi nào kích hoạt (Trigger)? |
| :-- | :--- | :--- | :--- |
| **1** | `cad-arch-grid-frame` | `.agents/skills/cad-arch-grid-frame/SKILL.md` | Khởi tạo dự án/hạng mục mới: Tự động quét thông số bản vẽ mẫu (`Auto-Discovery`), làm phẳng $Z=0$ (`ZZZ`), dọn hatch vỡ, dựng hệ lưới trục theo mảng `$X_GRIDS`, `$Y_GRIDS` và chèn/copy khung bản vẽ căn thẳng hàng theo `$Y_BASELINE`. |
| **2** | `cad-arch-ground-plan` | `.agents/skills/cad-arch-ground-plan/SKILL.md` | Vẽ Mặt bằng tầng (Ground / 1st / 2nd Floor Plan): Đặt cột kết cấu, dựng tường `Closed LWPOLYLINE` + Hatch `LINE` $45^\circ$ (scale $= 0.5 \times \$SCALE$), tạo Block cửa đi/cửa sổ/cửa cuốn, chia bậc cầu thang chuẩn ($250\text{ mm}$), mirror các khu chức năng đối xứng (WC) và đánh Dim 2 lớp. |
| **3** | `cad-arch-roof-plan` | `.agents/skills/cad-arch-roof-plan/SKILL.md` | Vẽ Mặt bằng mái (Roof Plan): Dựng đường bao mái chính/mái phụ/canopy theo độ đua mái `$OVERHANG`, viền trong diềm mái (Fascia $150\text{ mm}$), máng xối `WIPEOUT` (`$GUTTER_W`), phễu thu nước mưa $\varnothing 100$, tag độ dốc xoay theo vector thu nước và Hatch tôn mái `STEEL`. |
| **4** | `cad-arch-elevations` | `.agents/skills/cad-arch-elevations/SKILL.md` | Vẽ các Mặt đứng 1–4 (Elevations): Ánh xạ thứ tự trục theo 4 hướng nhìn (Chính, Sau, Trái, Phải), rải đường gióng cao độ theo mảng `$LEVELS` (`DRAWORDER _B`), đặt mốc cao độ (tự động flip âm ở cốt $\pm 0.000$ chống đè chữ), dựng tôn vách/mái dốc/cửa và Dynamic Block ống thoát nước đứng (`DRAWORDER _F`). |

### B. Nhóm 3 Skills Triển khai Bu lông neo (Anchor Bolt Deployment)
| STT | Tên Skill | Đường dẫn | Khi nào kích hoạt (Trigger)? |
| :-- | :--- | :--- | :--- |
| **5** | `cad-anchor-bolt-plan` | `.agents/skills/cad-anchor-bolt-plan/SKILL.md` | Vẽ Mặt bằng định vị Bu lông neo (Tỉ lệ `$SCALE` = 1/150 hoặc 1/100): Khung view căn theo `$Y_BASELINE`, lưới trục & Dim 2 lớp ở Trên & Trái (**không có text below dim**), đặt Block chân cột đúng góc xoay $\theta$, phân nhóm tự động mã chi tiết `A1..An` theo bộ 3 khóa `(BlockType, Rotation, ElevationFFL)`, khoanh vùng nét đứt bo góc **đa màu ACI**, gắn tag lục giác (`Scale = $SCALE`) và mốc cao độ. |
| **6** | `cad-anchor-detail-plan` | `.agents/skills/cad-anchor-detail-plan/SKILL.md` | Vẽ Hình chiếu bằng Chi tiết Bản mã & Bu lông (Tỉ lệ 1/10): Tự động dàn $N$ mã chi tiết vào các khung View 1/10 theo lưới 2x2 (`TL, TR, BL, BR`), chèn trực tiếp Block chân cột từ mặt bằng định vị với **góc xoay khớp 100%**, kéo tim trục + bong bóng trục ghép (`"&"`, `"TO"`, `","`), Dim 2 lớp `"GB 1-10"` có ký hiệu đối xứng `"="`, Leader mũi tên `_Open30` và đặt ký hiệu vết mặt cắt **song song với phương bụng cột**. |
| **7** | `cad-anchor-detail-section` | `.agents/skills/cad-anchor-detail-section/SKILL.md` | Vẽ Mặt cắt đứng Chân cột & Ghi chú Leader (Tỉ lệ 1/10): Cổ móng bê tông (`ftgW x ftgH`, hatch `"AR-CONC"`), lớp vữa SikaGrout (`plL x sikH`, hatch `"NET"` $45^\circ$), bản mã (`plL x plT`), thân cột thép hỗ trợ cả **Cột thẳng** lẫn **Cột vát thu đáy** + đường cắt `Break line`, chèn block bu lông mặt đứng, và dựng 4 cụm ghi chú Leader + cao độ `FFL` căn thẳng hàng bên trái tại $X = sx - 620.0$. |

---

## 2. Quy Trình 4 Giai Đoạn Bắt Buộc Cho Mọi Dự Án Mới

Khi mở bất kỳ file `.dwg` nào để triển khai Kiến trúc hoặc Bu lông neo, AI không được dùng số liệu cứng từ dự án cũ mà phải thực hiện tuần tự 4 giai đoạn:

```mermaid
flowchart LR
    G1["Giai đoạn 1: Auto-Discovery\n(Quét bản vẽ DWG hiện hành)"] --> G2["Giai đoạn 2: Parameterize\n(Thiết lập Biến Tham Số dự án)"]
    G2 --> G3["Giai đoạn 3: Code Generation\n(Node.js / Python sinh LISP)"]
    G3 --> G4["Giai đoạn 4: Visual QA\n(Zoom chụp ảnh nghiệm thu)"]
```

### Bảng Biến Tham Số Tổng Quát Của Dự Án (Project Parameters):
| Tên Biến | Mô tả Kỹ thuật | Quy tắc Tự động Xác định / Mặc định |
| :--- | :--- | :--- |
| `$Y_BASELINE` | Tọa độ $Y$ chuẩn để gióng thẳng hàng tất cả các khung bản vẽ trên cùng 1 hàng | Quét `vla-GetBoundingBox` của khung bản vẽ mẫu đầu tiên: lấy `minPt.Y` (nếu căn đáy) hoặc `maxPt.Y` (nếu căn đỉnh). |
| `$FRAME_BLOCK` | Tên Block khung bản vẽ và tên Attribute tỉ lệ | Quét `INSERT` khung tên có sẵn trong bản vẽ (mặc định chuẩn ATAD/GB: Block `"A$Ce291ec07"`, Attribute `"SCC"` hoặc Dynamic Field `Scale X`). |
| `$SCALE` (`sc`) | Hệ số tỉ lệ khung bản vẽ tổng thể (`150.0`, `120.0`, `100.0`, `60.0`...) | Đọc từ `XScaleFactor` của khung mẫu hoặc theo yêu cầu thiết kế. Chi tiết bu lông neo luôn dùng `$DETAIL_SCALE = 10.0` (`1/10`). |
| `$X_GRIDS` | Mảng các trục đứng `[{name, off}]` tính từ trục đầu tiên (`off = 0.0`) | Đọc từ hồ sơ thiết kế hoặc quét tọa độ $X$ các đường trên layer Gridline. Tổng chiều dài $L_{\text{total}} = \max(\text{off})$. |
| `$Y_GRIDS` | Mảng các trục ngang `[{name, off}]` tính từ trục đầu tiên (`off = 0.0`) | Đọc từ hồ sơ thiết kế hoặc quét tọa độ $Y$ các đường trên layer Gridline. Tổng chiều rộng $W_{\text{total}} = \max(\text{off})$. |
| `$LEVELS` | Mảng các mốc cao độ mặt đứng `[{elev, text, note, flip}]` | Ví dụ: `[{elev: 0, text: "%%P0.000", note: "(G.FL)", flip: true}, {elev: 500, text: "+0.500", note: "(1.FL)", flip: false}, ...]`. |
| `$ORIGIN` $(P_X, P_Y)$ | Tọa độ thế giới của giao điểm Trục gốc $(0, 0)$ trong từng khung View | $P_X = X_{\text{frame}} + \Delta X_{\text{margin}}$, $P_Y = Y_{\text{grid0}}$ (gióng thẳng hàng theo phương $X$ hoặc $Y$ với các View kế cận). |

---

## 3. Hệ Thống Layer, Màu Sắc & DimStyle Tiêu Chuẩn (Có Ánh Xạ Tự Động)

Nếu bản vẽ `.dwg` của dự án mới sử dụng hệ Layer tiêu chuẩn dưới đây thì gán trực tiếp; nếu dự án có bảng Layer riêng, AI tự động ánh xạ (`Layer Mapping`) theo đúng chức năng từng nhóm:

### A. Nhóm Layer Kiến Trúc (Architecture Standard Layers)
| Chức năng | Tên Layer Chuẩn | Màu (ACI) | Kiểu nét | Chiều dày | Quy chuẩn đối tượng |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Cột kết cấu** | `11 Column` | 7 (White) | Continuous | 0.35 mm | `LWPOLYLINE` kín hoặc Block cột tại giao điểm trục |
| **Nét cắt / Nét thấy** | `31 Drawing` | 7 (White) | Continuous | 0.25 mm | Tường (`Closed Polyline`), cầu thang, cửa, thiết bị, nét mặt đứng/mái |
| **Hatch tường & nền** | `22 Hatch` | 8 / 252 | Continuous | 0.09 mm | Hatch tường: Pattern `"LINE"`, góc $45^\circ$, `Scale = 0.5 * $SCALE` |
| **Hatch tôn mái/vách** | `23 Tole Hatch` | 8 / ByLayer | Continuous | 0.09 mm | Hatch mái: Pattern `"STEEL"`, góc $0^\circ$, `Scale = 0.5 * $SCALE` |
| **Máng xối (Wipeout)** | `41 Steel section` | ByLayer | Continuous | 0.15 mm | Đối tượng `WIPEOUT` che nền máng xối trên mặt bằng mái |
| **Lưới trục & Cao độ** | `32 Gridline` | 1 (Red) / 251 | Center / Dashed | 0.15 mm | Đường lưới trục định vị và đường gióng cao độ mặt đứng |
| **Kích thước & Ký hiệu** | `21 Dim` | 3 (Green) | Continuous | 0.15 mm | Đường kích thước, block độ dốc mái, đường cắt `Break line` |
| **Chữ ghi chú** | `41 Text` | 2 (Yellow) | Continuous | 0.20 mm | Tên phòng, ghi chú vật liệu, thông số kỹ thuật |
| **Tiêu đề bản vẽ** | `12 Text-title` | 1 (Red) | Continuous | 0.30 mm | Tiêu đề gạch chân: `%%UGROUND FLOOR PLAN`, `%%UROOF PLAN`... |
| **Khung bản vẽ** | `1.NVB-BLACK LINE` | ByLayer | Continuous | 0.25 mm | Layer đặt Block khung bản vẽ `$FRAME_BLOCK` |

### B. Nhóm Layer Chi Tiết Bu Lông Neo & Liên Kết Thép (Anchor Bolt Standard Layers)
| Chức năng | Tên Layer Chuẩn | Màu (ACI) | Quy chuẩn đối tượng ở Tỉ lệ 1/10 |
| :--- | :--- | :--- | :--- |
| **Bản mã thép** | `42 Steel plate` | 141 / Cyan | Đường bao bản mã (Base Plate) trên cả hình chiếu bằng và mặt cắt |
| **Tiết diện cột thép** | `33 Flange steel` | 3 (Green) | Bản cánh và bản bụng cột thép chữ H/I |
| **Bu lông neo** | `43 Bolt` | 2 (Yellow) | Bu lông neo, đai ốc, vòng đệm hoặc block `"ABM20"` / `"ABM24"` |
| **Cổ móng bê tông** | `23_Rc_GB` | 8 (Gray) | Đường bao cổ móng bê tông và Hatch `"AR-CONC"` (`Scale = 1.0`) |
| **Lớp vữa không co ngót** | `25_Sikagrout_GB` | 252 | Hatch lớp vữa SikaGrout (`"NET"`, góc $45^\circ$, `Scale = 5.0`) |
| **Kích thước 1/10** | `8` | ByLayer | Các đường kích thước chi tiết dùng DimStyle `"GB 1-10"` |
| **Đường dẫn Leader 1/10** | `6_Dim_GB` | 251 | Đối tượng `AcDbLeader` dùng DimStyle `"GB 1-10"`, mũi tên `_Open30` |
| **Chữ ghi chú 1/10** | `4_Text data_GB` | 7 (White) | Chữ ghi chú kỹ thuật (Height = $22.0\text{ mm}$ ở khung `Scale = 10.0`) |
| **Tiêu đề chi tiết 1/10** | `3_Text title_GB` | 1 (Red) | Tiêu đề `%%UDETAIL A1`, `%%USECTION A1` (Height = $35.0\text{ mm}$) |
| **Đường chia ô khung** | `HIDDEN` | ByLayer | Đường nét đứt phân chia lưới 2x2 bên trong khung View 1/10 |

### C. Quy tắc Chọn DimStyle Theo Tỉ Lệ `$SCALE`
- **Tỉ lệ tổng thể (`$SCALE = 150, 120, 100, 80, 60...`):** Dùng DimStyle `"ATAD1-<$SCALE>"` (ví dụ: `"ATAD1-150"`, `"ATAD1-100"`, `"ATAD1-120"`) và gán `vla-put-ScaleFactor` bằng đúng `$SCALE`.
- **Tỉ lệ chi tiết (`$DETAIL_SCALE = 10`):** Dùng DimStyle `"GB 1-10"` (vẽ kích thước thật $1:1$ trong ModelSpace bên trong khung `Scale = 10.0`).

---

## 4. Năm Nguyên Tắc Sắt Khi Tự Động Hóa AutoCAD (Golden Rules)

1. **Không tự ý lưu đè (`No Unconfirmed _QSAVE`):** Chỉ lưu bản vẽ khi đã hoàn tất kiểm tra hình ảnh hoặc có yêu cầu từ người dùng.
2. **Làm phẳng $Z = 0$ & Khép kín Polyline trước khi Hatch:**
   - Luôn đưa toàn bộ đối tượng về $Z = 0.0$ (`ZZZ`) trước khi bắt điểm.
   - Mọi phân đoạn tường/cổ móng/lớp vữa phải là `LWPOLYLINE` có `Closed = :vlax-true`.
3. **Không gọi lệnh mở hộp thoại GUI (`No Dialog Freeze`):**
   - Tuyệt đối không gửi lệnh `HATCH`, `INSERT`, `LAYER` mở hộp thoại qua `SendCommand`. Luôn dùng ActiveX COM (`vla-AddHatch` + `AppendOuterLoop` + `Evaluate`, `vla-InsertBlock`, `entmakex`) hoặc tiền tố `_.-`.
4. **Dùng Script Generator (`.mjs` / `.py`) sinh file `.lsp` cho các hạng mục lặp lại:**
   - Với bản vẽ có nhiều cấu kiện (như Mặt bằng bu lông neo hoặc hàng chục ô Chi tiết 1/10), luôn viết script Node.js (`.mjs`) hoặc Python đọc mảng dữ liệu cấu kiện để sinh ra file `.lsp` tự động xóa sạch vùng cũ (`Clean Target Zone`) và vẽ lại mới 100%, chống rác và chống trùng đè (`No Duplicate Entities`).
5. **Đồng bộ Tuyệt đối giữa Mặt bằng Định vị và Chi tiết 1/10:**
   - Mọi sự khác biệt về **(1) Tiết diện cột/bản mã**, **(2) Góc xoay cột trên mặt bằng ($0^\circ$ vs $90^\circ$)**, hoặc **(3) Cos cao độ đặt chân cột (`FFL`)** đều phải được tách mã chi tiết riêng, khoanh màu riêng trên Mặt bằng định vị và vẽ khớp 100% trên Chi tiết 1/10.
