# QUY TẮC TRIỂN KHAI BẢN VẼ AUTOCAD (DRAFTING RULES)

Tài liệu này tổng hợp toàn bộ các quy tắc, tiêu chuẩn và quy ước bắt buộc khi vẽ và chỉnh sửa bản vẽ AutoCAD cho dự án Nhà bảo dưỡng (B02) - LA635 cũng như các dự án liên quan.

---

## 1. Hệ thống Layer chuẩn

| Tên Layer | Màu (Color) | Kiểu nét (Linetype) | Chiều dày nét | Mục đích sử dụng |
| :--- | :--- | :--- | :--- | :--- |
| `11 Column` | White / 7 | Continuous | 0.35 mm | Nét cắt cột bê tông, cột thép kết cấu |
| `31 Drawing` | White / 7 | Continuous | 0.25 mm | Nét thấy, tường, vách ngăn, thiết bị vệ sinh, bậc thang |
| `22 Hatch` | 8 (Xám) / 252 | Continuous | 0.09 mm | Hatch mặt cắt tường, bê tông, vật liệu hoàn thiện |
| `32 Gridline` | Red / 1 | Center / DashDot | 0.15 mm | Đường tim trục định vị |
| `21 Dim` | Green / 3 | Continuous | 0.15 mm | Kích thước, đường gióng, text kích thước |
| `41 Text` | Yellow / 2 | Continuous | 0.20 mm | Chữ ghi chú, tên phòng, cao độ |

---

## 2. Quy chuẩn Tường & Vách ngăn

1. **Closed Polyline bắt buộc:**
   - Mọi phân đoạn tường (tường bao ngoài, vách ngăn trong, hộp kỹ thuật) phải được vẽ bằng `LWPOLYLINE` khép kín (`Closed = True`).
   - Tuyệt đối không để tường dạng các đoạn thẳng rời rạc (`LINE`), hở góc hoặc đè chồng lên nhau.
2. **Hatch mặt cắt tường:**
   - **Pattern:** `LINE` (hoặc `ANSI31` tương đương).
   - **Góc nghiêng (Angle):** $45^\circ$ ($0.785398\text{ rad}$).
   - **Tỉ lệ (Scale):** $50.0$.
   - **Layer:** Bắt buộc đặt trên layer `22 Hatch`.
   - **Associativity:** Khuyến khích Hatch liên kết (`Associative = True`) với đường bao Polyline để khi co kéo tường hatch tự cập nhật.

---

## 3. Quy chuẩn Cửa đi & Cửa sổ

1. **Bắt buộc đóng gói thành Block:**
   - Tất cả cửa đi, cửa sổ, cửa cuốn phải được tạo thành `BLOCK` (`AcDbBlockReference`), không để nét rời.
   - Điểm chèn (`Insertion Point`): Đặt tại góc tiếp giáp giữa khuôn cửa và mép tường hoặc tim cửa.
2. **Quy ước tên Block:**
   - Cửa đi: `B02_DOOR_<Loại/Kích_thước>` (Ví dụ: `B02_DOOR_D5`, `B02_DOOR_WC_RIGHT`, `B02_DOOR_700x2100`).
   - Cửa cuốn: `B02_DOOR_ROLLING_<Trục>` (Ví dụ: `B02_DOOR_ROLLING_A`).
   - Cửa sổ: `B02_WINDOW_<Ký_hiệu>` (Ví dụ: `B02_WINDOW_W1`).
3. **Quy ước nét vẽ trong Block:**
   - Các nét khuôn cửa, cánh cửa vẽ trên `Layer 0`, thuộc tính để `ByBlock` hoặc `ByLayer`.
   - Cung mở cửa vẽ bằng nét chấm đứt mảnh.

---

## 4. Quy chuẩn Cầu thang

1. **Bề rộng mặt bậc (Treads):**
   - Kích thước mặt bậc chuẩn: **$250\text{ mm}$** (hoặc $280\text{ mm}$ tùy theo thiết kế).
   - Khoảng cách giữa các đường nét bậc thang phải đều tăm tắp, không bị lệch hoặc nét trùng đúp.
2. **Vách biên cầu thang:**
   - Vách biên thang phải thẳng hàng với vách tường phòng vệ sinh bên trên ($X = 26,735.6\text{ mm}$, hoàn thiện $X = 26,651.1\text{ mm}$).
3. **Ký hiệu & Đánh số:**
   - Vòng tròn đánh số thứ tự bậc đặt chính giữa từng bậc thang ($X_{circ} = X_{tread} + 125\text{ mm}$).
   - Mũi tên chỉ hướng đi lên (UP) bắt đầu từ bậc 1, thân mũi tên chạy thẳng qua các bậc và đầu mũi tên chỉ rõ hướng di chuyển.
   - Đường cắt bậc zíc-zắc (Break line) thể hiện phần thang đi lên tầng trên.

---

## 5. Quy tắc thao tác AutoCAD tự động hóa

1. **Tuyệt đối không tự ý lưu đè bản vẽ:**
   - Khi chỉnh sửa tự động, chỉ lưu bản vẽ khi có sự xác nhận của người dùng.
2. **Tránh lỗi Command Line Prompt:**
   - Khi chạy lệnh AutoLISP có hatch, luôn dùng `_.-HATCH` (chế độ dòng lệnh có dấu gạch ngang `-`) hoặc tạo Hatch qua ActiveX COM (`AddHatch`) để tránh bị kẹt dialog/prompt.
3. **Quản lý Handle & Tránh Duplicate:**
   - Khi mirror hoặc copy đối tượng, kiểm tra kỹ để tránh tạo ra 2 lớp đối tượng trùng đè lên nhau (duplicate entities).

---

## 6. Quy tắc sử dụng Bộ công cụ AutoLISP cho AI & Kỹ sư

Để tối ưu hóa tốc độ và độ chính xác, AI và kỹ sư khi nhận tác vụ trên bản vẽ CAD phải tuân thủ các quy tắc sau:

### A. Chuẩn hóa hình học & Chống lỗi 2D
- **Làm phẳng bản vẽ ($Z = 0$):** Khi bắt đầu phiên làm việc hoặc trước khi đo đạc, bắt điểm, chạy lệnh `ZZZ` (`TT_CHUYEN_Z_VE_0.lsp`) để đưa toàn bộ tọa độ $Z$ về $0.0$, triệt tiêu hoàn toàn lỗi bắt điểm xiên trong không gian 3D.
- **Khép kín Polyline trước khi Hatch:** Mọi nét tường và vách vẽ bằng line rời phải chạy lệnh `nn` (`joinline.lsp`) để nối thành Polyline kín (`Closed`), tuyệt đối không hatch trên các đoạn hở.
- **Bắt điểm chuẩn:** Khi vẽ thủ công hoặc kiểm tra, gõ lệnh `5` (`TT_SNAP_ON.lsp`) để kích hoạt đầy đủ các chế độ Osnap thiết yếu (Endpoint, Midpoint, Center, Intersection, Perpendicular).

### B. Thao tác với Block & Thư viện
- **Đổi điểm đặt Block:** Khi cần thay đổi base point của Block mà không muốn các block đã đặt trong bản vẽ bị nhảy vị trí, dùng `CBP` hoặc `CBC` (`LM_ChangeBlockBasePoint.lsp`).
- **Nhân bản và đổi tên Block:** Khi tạo biến thể mới từ block có sẵn (ví dụ: tạo cửa WC trái từ cửa WC phải), dùng lệnh `cb` hoặc `rr` (`LM_CopyRenameBlock.lsp`).
- **Thay thế block hàng loạt:** Khi cập nhật mẫu thiết bị vệ sinh, đèn, cửa mới, dùng lệnh `TTB` (`TT_THAY_THE_BLOCK.lsp`).

### C. Triển khai Kích thước (Dimension) & Cao độ
- **Thiết lập DimStyle:** Gõ `DS` (`TT_TAO_DIM.lsp` hoặc `TONG_HOP_Chinh_Dim_Layer.lsp`) để thiết lập style dim kiến trúc chuẩn.
- **Đồng bộ layer & tỉ lệ dim:** Dùng lệnh `TDTL` (`TT_TDTL_LAYER_DIM.lsp`) để gán dim về layer `21 Dim` và scale chuẩn.
- **Dóng khoảng cách đều giữa các đường Dim:** Sau khi dim chi tiết và tổng thể, dùng lệnh `SD` (`TT_SPACE_DIM.lsp`) để các đường gióng cách đều nhau chuẩn xác.
- **Ghi chú text dưới chân dim:** Dùng lệnh `TD` (`TT_TEXT_DIM_BELOW.lsp`) khi cần thêm chữ phụ chú (như "KT", "THÔNG THỦY").
- **Cập nhật mốc cao độ:** Sử dụng lệnh `CAODO` (`TT_UPDATE_CAO_DO.lsp`) để cập nhật block mốc cao độ kiến trúc trên mặt cắt/mặt đứng.

### D. Triển khai Cầu thang, Cửa & Độ dốc
- **Cầu thang bộ:** Sử dụng lệnh `cc` (`TT_STAIRCASE_V1.lsp`) để tính toán số bậc và vẽ mặt cắt thang chuẩn bề rộng $250\text{ mm}$.
- **Cửa kiến trúc:** Sử dụng lệnh `door` (`TT_DOOR.lsp`) để vẽ nhanh block cửa theo kích thước lọt lòng.
- **Độ dốc mái (Slope):**
  - Dùng `S1` (`TT_VE_DO_DOC_SLOPE.lsp`) để vẽ tam giác độ dốc và ghi chú $i\%$.
  - Dùng `s2` (`TT_DRAW_SLOPE_XLINE.lsp`) để bắn đường dóng phụ trợ `XLINE` theo đúng góc dốc mái thoát nước.

### E. Ghi chú, Text & Quản lý sửa đổi (Revision)
- **Căn lề Leader & Text:** Dùng lệnh `all` (căn trái) hoặc `alr` (căn phải) (`TT_CANH_LEADER_TEXT.lsp`) để hệ thống ghi chú thẳng hàng, ngay ngắn.
- **Copy nội dung Text siêu tốc:** Dùng lệnh `d1` (`TT_COPY_TEXT.lsp`) để sao chép nội dung từ text mẫu sang text cần sửa.
- **Chuyển Field sang Text tĩnh:** Khi xuất bản vẽ nộp hoặc chuyển thiết bị khác, chạy lệnh `f2t` (`TT_CONVERT_FIELD_TO_TEXT.lsp`) để cố định nội dung, chống lỗi hiển thị `####`.
- **Khoanh mây sửa đổi (Revision):** Khi tiếp nhận comment và chỉnh sửa bản vẽ, dùng lệnh `REV` (`TT_KHOANH_MAY_REV.lsp`) để khoanh mây xung quanh vùng thay đổi.

### F. Thao tác Layer & Khung nhìn Viewport
- **Chuyển layer nhanh bằng phím tắt:**
  - Nhập `31`: Chuyển đối tượng sang layer tường (`31 Drawing`).
  - Nhập `22`: Chuyển đối tượng sang layer mặt cắt hatch (`22 Hatch`).
  - Nhập `21`: Chuyển đối tượng sang layer kích thước (`21 Dim`).
  - Nhập `11`: Chuyển đối tượng sang layer cột (`11 Column`).
  - Nhập `32`: Chuyển đối tượng sang layer trục định vị (`32 Gridline`).
- **Bật nhanh toàn bộ layer:** Gõ `T5` (`TT_LAYON_ALL.lsp`) để hiển thị lại toàn bộ các đối tượng đang bị ẩn.
- **Khóa khung nhìn Viewport:** Gõ `W` (`TT_KHOA_VIEWPORT.lsp`) trong Layout để khóa viewport, ngăn việc vô tình zoom làm sai lệch tỉ lệ bản vẽ in.
