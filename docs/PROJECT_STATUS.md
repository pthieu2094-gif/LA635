# BÁO CÁO TIẾN ĐỘ DỰ ÁN LA635 - NHÀ BẢO DƯỠNG (B02)

- **Dự án:** LA635 - Maintenance Building (B02)
- **Bản vẽ chính:** `E:\02. PART TIME\LA635\LA325.dwg`
- **Phiên bản thiết kế tham chiếu:** Rev01 (`LA635_-_Maintenance_Building_(B02)_-_Rev1_-_Update_Layout_Plan.pdf`)
- **Tài khoản phụ trách:** `pthieu2094-gif` (`pthieu2094@gmail.com`)
- **Thời điểm cập nhật:** 2026-11-22

---

## 1. Tóm tắt lịch sử trò chuyện & Yêu cầu đã thực hiện

### Yêu cầu 1: Triển khai kiến trúc B02 theo Rev01 & Drafting Rules
- Bố trí mặt bằng kiến trúc B02 nằm ngay bên dưới kiến trúc B01 theo hệ tọa độ chuẩn.
- Dựng hệ lưới trục Trục 1..8 và Trục A, B, C bằng công cụ LISP `b02grid.lsp`.
- Lưới trục dọc:
  - Trục 1: $X = 0$
  - Trục 2: $X = 6,200$
  - Trục 3: $X = 12,200$
  - Trục 4: $X = 18,400$
  - Trục 5: $X = 23,050$
  - Trục 6: $X = 27,700$
  - Trục 7: $X = 30,600$
  - Trục 8: $X = 36,600$
- Lưới trục ngang:
  - Trục A: $Y = -59,500$
  - Trục B: $Y = -51,500$
  - Trục C: $Y = -45,500$

### Yêu cầu 2: Dọn sạch Text & Annotation không cần thiết
- Xóa bỏ các ký hiệu cao độ $F1 +0.50$, $C1 +3.40$, các tam giác ký hiệu hoàn thiện $P1$, ký hiệu cửa sổ $W1$, cửa đi $D5$ dạng annotation rời rạc trên mặt bằng tầng 1.
- Dọn sạch các nét hatch vỡ (exploded hatch lines) bị phân rã từ trước bằng LISP `clean_all_exploded_hatch.lsp`.

### Yêu cầu 3: Chuẩn hóa Block, Closed Polyline & Hatch LINE 45 độ
- **Cửa đi & Cửa sổ thành Block:**
  - 5 bộ cửa cuốn Trục A tạo thành block `B02_DOOR_ROLLING_A` (kích thước $5,700 \times 4,500\text{ mm}$).
  - 4 bộ cửa sổ Trục C tạo thành block `B02_WINDOW_W1` (kích thước $2,000 \times 1,500\text{ mm}$).
  - Cửa đi 2 cánh D5 Trục C tạo thành block `B02_DOOR_D5` ($1,800 \times 2,400\text{ mm}$).
  - Cửa phòng kho tạo thành block `B02_DOOR_700x2100`.
- **Tường khép kín & Hatch chuẩn:**
  - Toàn bộ 43 phân đoạn tường bao và vách ngăn được chuyển thành Closed Polylines trên layer `31 Drawing`.
  - Toàn bộ mặt cắt tường được Hatch pattern `LINE`, góc `45 độ`, scale `50.0` trên layer `22 Hatch`.

### Yêu cầu 4: Điều chỉnh 2 phòng WC đối xứng 100%
- Mở rộng phòng WC trái để chiều rộng thông thủy bằng chính xác WC phải (**$1,930.5\text{ mm}$**), dịch vách tường biên trái từ $X = 27,077.9$ sang $X = 26,735.6$.
- Dọn dẹp sạch thiết bị cũ trong WC trái, vẽ lại vách trái và vách dưới bằng Closed Polyline & Hatch LINE 45°.
- Mirror toàn bộ 500 đối tượng (bồn cầu, lavabo, phễu thu sàn vuông/tròn, gạch lát sàn và block cửa đi) từ WC phải sang WC trái qua trục tim đối xứng $X_c = 28,700.8$.

### Yêu cầu 5: Khắc phục các vị trí lỗi (Cột Trục 6-C, Tường Trục C & Bậc Thang)
- **Cột Trục 6 - Trục C:** Bổ sung cột kết cấu vuông $302.8 \times 302.5\text{ mm}$ tại tim Trục 6 - Trục C ($X \in [26651.1, 26953.9]$, $Y \in [-45647.5, -45345.0]$) đồng bộ với Cột Trục 7 - Trục C.
- **Tường Trục C bên trái:** Kéo dài tường Trục C bên trái nối kín khít vào mặt tây của Cột Trục 6 ($X = 26651.1$), hatch LINE 45° kín hoàn toàn, chấm dứt tình trạng hở tường.
- **Tường Trục C trên WC trái:** Xóa sạch hốc giật cấp thừa, làm phẳng tường Trục C thẳng hàng và đối xứng 100% với WC phải.
- **Cầu thang:**
  - Dịch vách biên trái thang sang $X = 26,735.6\text{ mm}$ (thẳng hàng tuyệt đối với vách WC bên trên), có Polyline và Hatch LINE 45°.
  - Chia đều các bậc thang rộng chuẩn **$250\text{ mm}$** mỗi bậc (thay cho các bậc cũ bị lệch $162\text{ mm}$, $235\text{ mm}$ và nét trùng).
  - Vẽ lại đường cắt thang zíc-zắc (Break line), căn chỉnh 7 vòng tròn số thứ tự bậc (1 đến 7) nằm chính giữa từng bậc và mũi tên chỉ hướng UP thẳng hàng.

---

## 2. Tọa độ tham chiếu then chốt (Key Benchmarks)

| Cấu kiện / Vị trí | Tọa độ X (mm) | Tọa độ Y (mm) | Ghi chú |
| :--- | :--- | :--- | :--- |
| **Hệ trục Trục 1 - 8** | `0`, `6200`, `12200`, `18400`, `23050`, `27700`, `30600`, `36600` | — | Layer `32 Gridline` |
| **Hệ trục Trục A, B, C** | — | `-59500`, `-51500`, `-45500` | Layer `32 Gridline` |
| **Cột Trục 6 - Trục C** | `26651.1` đến `26953.9` | `-45647.5` đến `-45345.0` | Cột vuông $302.8 \times 302.5$ |
| **Cột Trục 7 - Trục C** | `30447.7` đến `30750.5` | `-45647.5` đến `-45345.0` | Cột vuông $302.8 \times 302.5$ |
| **WC Trái (thông thủy)**| `26735.6` đến `28666.1` ($W = 1930.5$) | `-47846.2` đến `-45449.0` ($H = 2397.2$) | Đối xứng 100% WC phải |
| **WC Phải (thông thủy)**| `28735.5` đến `30666.0` ($W = 1930.5$) | `-47846.2` đến `-45449.0` ($H = 2397.2$) | Cửa sát Cột Trục 7 |
| **Trục tim đối xứng WC**| $X_c = 28,700.8$ | — | Tim vách ngăn giữa |
| **Vách biên trái thang**| $X = 26,735.6$ (hoàn thiện: $26,651.1$) | `-49637.8` đến `-47930.6` | Thẳng hàng vách WC |
| **Chân cầu thang** | `26735.6` đến `28507.2` | $Y = -49,563.3$ | Bậc rộng $250\text{ mm}$ |

---

## 3. Các bước tiếp theo để triển khai trên thiết bị khác

1. **Mở bản vẽ:** Mở file `LA325.dwg` bằng AutoCAD 2020 - 2026.
2. **Nạp LISP tiện ích:** Dùng lệnh `APPLOAD` để nạp các file trong thư mục `scripts/lisp/` khi cần chỉnh sửa.
3. **Các hạng mục tiếp theo của Nhà B02:**
   - Triển khai Mặt bằng Tầng 2 (nếu có).
   - Triển khai Mặt đứng Trục A, Trục C, Trục 1, Trục 8.
   - Triển khai Mặt cắt dọc qua cầu thang và qua xưởng bảo dưỡng.
   - Bố trí kích thước (Dimension) tổng thể và chi tiết theo layer `21 Dim`.
