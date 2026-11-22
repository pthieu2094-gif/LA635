# DỰ ÁN LA635 - NHÀ BẢO DƯỠNG (MAINTENANCE BUILDING - B02)

Dự án triển khai và chuẩn hóa bản vẽ kiến trúc AutoCAD Nhà bảo dưỡng (B02) thuộc gói thầu LA635, theo hồ sơ thiết kế Rev01 và bộ quy chuẩn Drafting Rules.

---

## 1. Cấu trúc thư mục

```text
.
├── 01. INPUT/               # Hồ sơ thiết kế PDF gốc (Rev0, Rev1)
├── 02. OUTPUT/              # Hình ảnh chụp nghiệm thu chi tiết và toàn cảnh
├── docs/                    # Tài liệu dự án
│   ├── PROJECT_STATUS.md    # Báo cáo tiến độ, lịch sử chỉnh sửa & tọa độ then chốt
│   └── DRAFTING_RULES.md    # Bộ quy tắc vẽ AutoCAD chuẩn (layer, polyline, hatch, block)
├── scripts/                 # Bộ công cụ tự động hóa
│   ├── lisp/                # Các tiện ích AutoLISP (.lsp)
│   └── python/              # Các script Python điều khiển AutoCAD qua ActiveX COM
├── LA325.dwg                # Bản vẽ AutoCAD chính của dự án (đã chuẩn hóa MB T1)
└── .gitignore               # Loại bỏ các file tạm của AutoCAD (*.bak, *.dwl, *.dwl2)
```

---

## 2. Hướng dẫn tiếp tục làm việc trên máy khác

### A. Mở và kiểm tra bản vẽ
1. Mở file `LA325.dwg` bằng AutoCAD 2020 trở lên.
2. Kiểm tra Mặt bằng Tầng 1 Nhà bảo dưỡng (B02) nằm ở hệ tọa độ:
   - $X \in [0, 36600]$
   - $Y \in [-59500, -45500]$
3. Toàn bộ tường bao, vách ngăn đã là Closed Polyline với Hatch LINE 45° scale 50.
4. Cụm 2 phòng vệ sinh đối xứng hoàn toàn qua tim vách ngăn $X_c = 28,700.8$.
5. Cột Trục 6 - Trục C ($300 \times 300\text{ mm}$) đã bổ sung đầy đủ và cầu thang đã chia đều bậc $250\text{ mm}$.

### B. Sử dụng bộ công cụ LISP
Trong AutoCAD, gõ lệnh `APPLOAD` và chọn các file trong thư mục `scripts/lisp/`:
- `b02grid.lsp`: Dựng hệ lưới trục Nhà B02.
- `clean_all_exploded_hatch.lsp`: Quét và dọn sạch các nét hatch bị vỡ.
- `do_mirror.lsp`: Mirror thiết bị đối xứng.
- `fix_three_issues.lsp`: Khắc phục cột, tường và bậc cầu thang.

### C. Sử dụng bộ script Python tự động hóa (nếu có Python)
Cần môi trường Python có cài đặt `pywin32`:
```bash
python scripts/python/capture_screen.py output.png <x1> <y1> <x2> <y2>
```

---

## 3. Liên hệ & Phụ trách
- Kỹ sư phụ trách: `pthieu2094-gif`
- Email: `pthieu2094@gmail.com`
