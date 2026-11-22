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
