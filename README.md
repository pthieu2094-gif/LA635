# DỰ ÁN LA635: NHÀ GIẶT ỦI (B01) & NHÀ BẢO DƯỠNG (B02)

Dự án triển khai và chuẩn hóa bản vẽ kiến trúc AutoCAD cho cả hai công trình **Nhà giặt ủi (B01 - Laundry Building)** và **Nhà bảo dưỡng (B02 - Maintenance Building)** thuộc gói thầu LA635, trong cùng file bản vẽ tổng thể `LA325.dwg`.

---

## 1. Bố cục tổng thể trong ModelSpace (`LA325.dwg`)

Bản vẽ được sắp xếp theo hệ trục dọc chung (Trục 1 đến Trục 8, dài $36.6\text{m}$):
- **Phía trên ($Y > -42,000$):** Công trình **B01 - Laundry Building**
  - Ground Floor Plan: $X \in [0, 36600]$, $Y \in [-6000, 30000]$
  - Roof Plan: $X \in [100000, 136000]$, $Y \in [-6200, 30000]$
  - Các mặt đứng (Elevations 1 - 4): $X \in [200000, 340000]$, $Y \in [-2500, 25000]$
- **Phía dưới ($Y < -42,000$):** Công trình **B02 - Maintenance Building**
  - Ground Floor Plan (Mặt bằng Tầng 1): $X \in [0, 36600]$, $Y \in [-59500, -45500]$
  - Roof Plan: $X \in [100000, 136000]$, $Y \in [-69000, -45500]$
  - Các mặt đứng (Elevations 1 - 4): $X \in [198000, 310000]$, $Y \in [-80000, -54000]$

---

## 2. Cấu trúc thư mục Repository

```text
.
├── 01. INPUT/               # Hồ sơ thiết kế đầu vào
│   ├── LA635 - Laundry Building (B01) Comment 13.11.2026.pdf
│   ├── LA635 - Maintenance Building (B02) - Rev0.pdf
│   └── LA635 - Maintenance Building (B02) - Rev1 - Update Layout Plan.pdf
├── 02. OUTPUT/              # Hình ảnh chụp nghiệm thu chi tiết và toàn cảnh
├── docs/                    # Tài liệu kỹ thuật
│   ├── PROJECT_STATUS.md    # Báo cáo chi tiết tiến độ B01 & B02, tọa độ then chốt
│   └── DRAFTING_RULES.md    # Bộ quy tắc vẽ AutoCAD chuẩn (layer, polyline, hatch, block)
├── scripts/                 # Bộ công cụ tự động hóa
│   ├── lisp/                # Các tiện ích AutoLISP (.lsp)
│   └── python/              # Các script Python điều khiển AutoCAD qua ActiveX COM
├── LA325.dwg                # Bản vẽ AutoCAD chính (chứa cả B01 và B02)
└── .gitignore               # Loại bỏ các file tạm của AutoCAD (*.bak, *.dwl, *.dwl2)
```

---

## 3. Hướng dẫn tiếp tục làm việc trên máy khác

### A. Clone mã nguồn
```bash
git clone https://github.com/pthieu2094-gif/LA635.git
cd LA635
```

### B. Mở và kiểm tra bản vẽ
1. Mở file `LA325.dwg` bằng AutoCAD 2020 trở lên.
2. Kiểm tra B01 (ở trên) và B02 (ở dưới) được gióng thẳng hàng theo hệ lưới trục Trục 1 - 8.
3. Đọc tài liệu chi tiết tại `docs/PROJECT_STATUS.md` để nắm rõ các mốc tọa độ và các việc cần làm tiếp theo.

### C. Sử dụng bộ công cụ LISP
Trong AutoCAD, gõ lệnh `APPLOAD` và chọn các file trong thư mục `scripts/lisp/`:
- `b02grid.lsp`: Dựng hệ lưới trục Nhà B02.
- `clean_all_exploded_hatch.lsp`: Dọn sạch hatch vỡ.
- `do_mirror.lsp`: Mirror thiết bị WC đối xứng.
- `fix_three_issues.lsp`: Xử lý cột Trục 6-C, tường Trục C và cầu thang.

---

## 4. Liên hệ & Phụ trách
- Kỹ sư phụ trách: `pthieu2094-gif`
- Email: `pthieu2094@gmail.com`
