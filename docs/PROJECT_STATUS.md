# BÁO CÁO TỔNG THỂ DỰ ÁN LA635: NHÀ GIẶT ỦI (B01) & NHÀ BẢO DƯỠNG (B02)

- **Dự án:** LA635
- **Công trình gồm 2 hạng mục chính:**
  1. **B01 - Laundry Building (Nhà giặt ủi)**
  2. **B02 - Maintenance Building (Nhà bảo dưỡng)**
- **Bản vẽ tổng hợp AutoCAD:** `E:\02. PART TIME\LA635\LA325.dwg`
- **Hồ sơ thiết kế & phản hồi đầu vào:**
  - `01. INPUT/LA635 - Laundry Building (B01) Comment 13.11.2026.pdf` (Hồ sơ comment B01)
  - `01. INPUT/LA635 - Maintenance Building (B02) - Rev0.pdf` (Thiết kế ban đầu B02)
  - `01. INPUT/LA635 - Maintenance Building (B02) - Rev1 - Update Layout Plan.pdf` (Thiết kế cập nhật Rev01 B02)
- **Tài khoản phụ trách:** `pthieu2094-gif` (`pthieu2094@gmail.com`)
- **Repository GitHub:** [https://github.com/pthieu2094-gif/LA635](https://github.com/pthieu2094-gif/LA635)
- **Cập nhật ngày:** 2026-11-22

---

## 1. Tổng quan bố cục bản vẽ trong không gian Model (`LA325.dwg`)

Bản vẽ `LA325.dwg` được tổ chức đồng bộ theo cụm trục dọc (Trục 1 đến Trục 8, tổng chiều dài $36,600\text{ mm}$), trong đó **Kiến trúc B01 nằm ở phía trên** và **Kiến trúc B02 nằm ở phía dưới**:

```text
       Y (Cao độ)
        ▲
+40,000 │   [ B01 - Laundry Building ]
        │   - Ground Floor Plan:  X in [0, 36600],       Y in [-6000, 30000]
        │   - Roof Plan:          X in [100000, 136000], Y in [-6200, 30000]
        │   - Elevations 1 - 4:   X in [200000, 340000], Y in [-2500, 25000]
        │
 -6,000 ├──────────────────────────────────────────────────────────────────
        │   [ Khoảng cách đệm giữa 2 tòa nhà ]
-42,000 ├──────────────────────────────────────────────────────────────────
        │   [ B02 - Maintenance Building ]
        │   - Ground Floor Plan:  X in [0, 36600],       Y in [-59500, -45500]
        │   - Roof Plan:          X in [100000, 136000], Y in [-69000, -45500]
        │   - Elevations 1 - 4:   X in [198000, 310000], Y in [-80000, -54000]
-80,000 ▼
        └──────────────────────────────────────────────────────────────────► X (Trục 1 -> 8)
```

---

## 2. Thông tin chi tiết Hạng mục B01 - Laundry Building (Nhà giặt ủi)

### A. Phạm vi & Vị trí trong ModelSpace
- **Mặt bằng Tầng trệt (Ground Floor Plan):**
  - Tọa độ: $X \in [0, 36600]$, $Y \in [-6000, 30000]$.
  - Tiêu đề bản vẽ: `%%UGROUND FLOOR PLAN` tại $(17592.3, -5921.0)$.
- **Mặt bằng Mái (Roof Plan):**
  - Tọa độ: $X \in [100000, 136000]$, $Y \in [-6200, 30000]$.
  - Tiêu đề bản vẽ: `%%UROOF PLAN` tại $(113328.0, -6261.8)$.
- **Các Mặt đứng (Elevations):**
  - `DIRECTION OF ELEVATION 1` tại $(200829.0, 22763.2)$
  - `DIRECTION OF ELEVATION 2` tại $(200829.0, -2236.8)$
  - `DIRECTION OF ELEVATION 3` tại $(276280.0, -1681.6)$
  - `DIRECTION OF ELEVATION 4` tại $(325805.0, -1681.6)$

### B. Vai trò & Quy chuẩn từ B01
- B01 là bản vẽ chuẩn mực gốc (đã tiếp nhận ý kiến phản hồi ngày 13.11.2026).
- Mọi tiêu chuẩn triển khai cho B02 đều được đối chiếu và kế thừa từ B01:
  - Hệ thống layer: `11 Column`, `31 Drawing`, `22 Hatch`, `32 Gridline`, `21 Dim`, `41 Text`.
  - Quy cách tường: Polyline khép kín (`Closed = True`), hatch mặt cắt tường góc $45^\circ$, tỉ lệ $50.0$.
  - Cửa đi, cửa sổ đóng gói thành block đồng bộ.

---

## 3. Thông tin chi tiết Hạng mục B02 - Maintenance Building (Nhà bảo dưỡng)

### A. Quá trình triển khai theo Rev01
1. **Dựng hệ lưới trục:** Trục 1..8 ($X = 0, 6200, 12200, 18400, 23050, 27700, 30600, 36600$) và Trục A, B, C ($Y = -59500, -51500, -45500$) thẳng hàng bên dưới B01.
2. **Làm sạch bản vẽ:** Xóa các annotation rác, dọn toàn bộ hatch vỡ cũ bằng `clean_all_exploded_hatch.lsp`.
3. **Chuẩn hóa Block & Tường:**
   - Tạo block cửa cuốn Trục A (`B02_DOOR_ROLLING_A`), cửa sổ W1 Trục C (`B02_WINDOW_W1`), cửa đi D5 (`B02_DOOR_D5`), cửa kho (`B02_DOOR_700x2100`).
   - Tạo 43 phân đoạn tường khép kín (`31 Drawing`) và Hatch LINE 45° scale 50 (`22 Hatch`).
4. **Đối xứng 2 phòng vệ sinh (WC):**
   - Mở rộng WC trái thông thủy bằng WC phải (**$1,930.5\text{ mm}$**).
   - Mirror toàn bộ 500 đối tượng (thiết bị, gạch lát, cửa đi) qua trục tim $X_c = 28,700.8$.
5. **Khắc phục lỗi kiến trúc:**
   - Bổ sung Cột kết cấu Trục 6 - Trục C ($302.8 \times 302.5\text{ mm}$) tại $X \in [26651.1, 26953.9]$, $Y \in [-45647.5, -45345.0]$.
   - Kéo tường Trục C bên trái nối kín vào cột, làm phẳng tường Trục C trên WC trái.
   - Dịch vách thang về $X = 26,735.6\text{ mm}$ (thẳng hàng vách WC), chia đều các bậc thang rộng chuẩn **$250\text{ mm}$**, vẽ lại break line và đánh số bậc.

---

## 4. Bảng tra cứu tọa độ then chốt cả 2 tòa nhà (Key Benchmarks)

| Hạng mục | Vị trí / Cấu kiện | Tọa độ X (mm) | Tọa độ Y (mm) | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **B01** | Ground Floor Plan | `0` đến `36,600` | `-6,000` đến `30,000` | Mặt bằng Tầng trệt Nhà giặt ủi |
| **B01** | Roof Plan | `100,000` đến `136,000` | `-6,200` đến `30,000` | Mặt bằng Mái Nhà giặt ủi |
| **B01** | Elevations 1..4 | `200,000` đến `340,000` | `-2,500` đến `25,000` | Các mặt đứng Nhà giặt ủi |
| **B02** | Ground Floor Plan | `0` đến `36,600` | `-59,500` đến `-45,500` | Mặt bằng Tầng 1 Nhà bảo dưỡng |
| **B02** | Roof Plan | `100,000` đến `136,000` | `-69,000` đến `-45,500` | Mặt bằng Mái Nhà bảo dưỡng |
| **B02** | Elevations 1..4 | `198,000` đến `310,000` | `-80,000` đến `-54,000` | Các mặt đứng Nhà bảo dưỡng |
| **B02** | Cột Trục 6 - Trục C | `26,651.1` đến `26,953.9` | `-45,647.5` đến `-45,345.0` | Cột vuông $302.8 \times 302.5$ |
| **B02** | Cột Trục 7 - Trục C | `30,447.7` đến `30,750.5` | `-45,647.5` đến `-45,345.0` | Cột vuông $302.8 \times 302.5$ |
| **B02** | WC Trái & WC Phải | Rộng thông thủy $1,930.5\text{ mm}$ | Sâu thông thủy $2,397.2\text{ mm}$ | Đối xứng qua tim $X_c = 28,700.8$ |
| **B02** | Cầu thang bộ | Bắt đầu $X = 26,735.6$ | Chân thang $Y = -49,563.3$ | Bậc rộng chuẩn $250\text{ mm}$ |

---

## 5. Hướng dẫn cho thiết bị khác tiếp tục triển khai

1. **Clone repository:**
   ```bash
   git clone https://github.com/pthieu2094-gif/LA635.git
   ```
2. **Mở bản vẽ:** `LA325.dwg` chứa cả B01 (ở trên) và B02 (ở dưới).
3. **Các hạng mục tiếp theo cần triển khai:**
   - Đối chiếu các comment của B01 trong file `01. INPUT/LA635 - Laundry Building (B01) Comment 13.11.2026.pdf`.
   - Triển khai Mặt bằng Tầng 2 B02 (nếu có).
   - Triển khai Mặt cắt dọc và Mặt đứng B02 đồng bộ với các mặt đứng của B01.
   - Ghi kích thước (Dimension) chi tiết và tổng thể theo chuẩn layer `21 Dim`.
