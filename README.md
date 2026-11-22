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
├── 01. INPUT/                      # Hồ sơ thiết kế đầu vào
│   ├── LA635 - Laundry Building (B01) Comment 13.11.2026.pdf
│   ├── LA635 - Maintenance Building (B02) - Rev0.pdf
│   └── LA635 - Maintenance Building (B02) - Rev1 - Update Layout Plan.pdf
├── 02. OUTPUT/                     # Hình ảnh chụp nghiệm thu chi tiết và toàn cảnh
├── docs/                           # Tài liệu kỹ thuật
│   ├── PROJECT_STATUS.md           # Báo cáo chi tiết tiến độ B01 & B02, tọa độ then chốt
│   └── DRAFTING_RULES.md           # Bộ quy tắc vẽ AutoCAD chuẩn (layer, polyline, hatch, block)
├── scripts/                        # Bộ công cụ tự động hóa
│   ├── lisp/                       # Toàn bộ tiện ích AutoLISP (.lsp) phân loại chuyên nghiệp
│   │   ├── b01_standards/          # LISP trích xuất chuẩn mực, khung tên và lưới trục B01
│   │   ├── b02_implementation/     # LISP dựng hình, dọn hatch, mirror và fix lỗi B02
│   │   └── common_tools/           # Bộ thư viện AutoLISP vẽ kiến trúc dùng chung
│   └── python/                     # Các script Python điều khiển AutoCAD qua ActiveX COM
├── LA325.dwg                       # Bản vẽ AutoCAD chính (chứa cả B01 và B02)
└── .gitignore                      # Loại bỏ các file tạm của AutoCAD (*.bak, *.dwl, *.dwl2)
```

---

## 3. Danh mục & Hướng dẫn sử dụng Bộ công cụ AutoLISP (`scripts/lisp/`)

Để sử dụng trên thiết bị bất kỳ, gõ lệnh `APPLOAD` trong AutoCAD và load các file `.lsp` tương ứng:

### A. Nhóm LISP Chuẩn mực B01 (`scripts/lisp/b01_standards/`)
Dùng để khảo sát, trích xuất dữ liệu chuẩn mực từ công trình B01 làm căn cứ triển khai cho B02:

| File LISP | Lệnh gọi | Chức năng chính |
| :--- | :--- | :--- |
| `inspect_b01_standards.lsp` | `INSPECT_B01_STANDARDS` | Quét mẫu hatch tường, mẫu block cửa, layer chuẩn từ Nhà B01 |
| `dumpf.lsp` | `DUMPF` | Trích xuất tọa độ và thuộc tính khung tên B01 để gióng thẳng hàng B02 |
| `dumpg.lsp` | `DUMPG` | Trích xuất tọa độ hệ lưới trục Trục 1..8, A..C của B01 |

### B. Nhóm LISP Triển khai B02 (`scripts/lisp/b02_implementation/`)
Bộ công cụ dựng hình và hoàn thiện chi tiết Nhà B02 theo hồ sơ Rev01:

| File LISP | Lệnh gọi | Chức năng chính |
| :--- | :--- | :--- |
| `b02grid.lsp` | `B02GRID` | Dựng hệ trục tọa độ Trục 1..8, A, B, C cho Nhà B02 tại $Y < -42,000$ |
| `draw_b02_plan.lsp` | `DRAW_PLAN_LINES` | Dựng tim tường và polyline mặt bằng tầng 1 B02 |
| `draw_b02_elevs.lsp` | `DRAW_B02_ELEVS` | Dựng các nét cơ bản cho 4 mặt đứng B02 |
| `draw_b02_roof.lsp` | `DRAW_B02_ROOF` | Dựng mặt bằng mái B02 |
| `anno_b02_plan.lsp` | `ANNO_B02_PLAN` | Đặt tên phòng, cao độ và dim cơ bản trên mặt bằng B02 |
| `anno_b02_elevs.lsp` | `COMPLETE_B02_ELEVS` | Ghi chú trục và cao độ cho các mặt đứng B02 |
| `clean_all_exploded_hatch.lsp` | `SCAN_ALL_EXPLODED_HATCH` | Quét và xóa sạch các hatch bị rã (exploded lines) tránh nặng bản vẽ |
| `do_mirror.lsp` | `DO_MIRROR` | Đối xứng thiết bị vệ sinh, gạch lát, cửa đi WC trái theo WC phải |
| `fix_three_issues.lsp` | `FIX_ALL` | Bổ sung cột Trục 6-C, khép kín tường Trục C, chia đều bậc cầu thang 250mm |

### C. Nhóm Thư viện Dùng chung (`scripts/lisp/common_tools/`)
Bộ công cụ AutoCAD chuẩn hóa được tích hợp sẵn để vẽ nhanh trên bất kỳ thiết bị nào:

| File LISP | Lệnh gọi | Chức năng chính |
| :--- | :--- | :--- |
| `TT_STAIRCASE_V1.lsp` | `cc` | Vẽ và chia bậc cầu thang tự động nhanh chóng và chính xác |
| `TT_DOOR.lsp` | `door` | Chèn cửa đi kiến trúc tự động theo kích thước tùy chỉnh |
| `TT_DAT_COT_TRUC.lsp` | `SCL1` | Tự động đặt cột kết cấu tại các giao điểm lưới trục |
| `TT_TAO_DIM.lsp` | `DS` | Thiết lập và tạo kiểu đường kích thước (DimStyle) kiến trúc chuẩn |
| `TT_TDTL_LAYER_DIM.lsp` | `TDTL` | Thay đổi tỉ lệ và đồng bộ nhanh layer cho hệ thống kích thước |
| `TT_UPDATE_CAO_DO.lsp` | `CAODO` | Cập nhật tự động ký hiệu và giá trị cao độ trên mặt cắt/mặt đứng |
| `joinline.lsp` | `nn` | Nối các đoạn Line/Arc rời rạc thành Polyline khép kín (`Closed`) |
| `tl.lsp` | `TL` | Đo và tính tổng chiều dài hàng loạt đối tượng Curve/Line |
| `TONG_HOP_Chinh_Dim_Layer.lsp` | `DS`, `TOP`, `HI`, `Q1`, `Q2`... | Bộ lệnh tắt thao tác siêu tốc với Dimension (đưa về layer dim, canh lề) |
| `TONG_HOP_Chuyen_Layer.lsp` | `31`, `22`, `21`, `11`, `32`... | Bộ phím tắt gán nhanh đối tượng về layer tương ứng (31: Tường, 22: Hatch, 21: Dim...) |

---

## 4. Hướng dẫn tiếp tục làm việc trên máy khác

### A. Clone mã nguồn
```bash
git clone https://github.com/pthieu2094-gif/LA635.git
cd LA635
```

### B. Mở và kiểm tra bản vẽ
1. Mở file `LA325.dwg` bằng AutoCAD 2020 trở lên.
2. Kiểm tra B01 (ở trên) và B02 (ở dưới) được gióng thẳng hàng theo hệ lưới trục Trục 1 - 8.
3. Đọc tài liệu chi tiết tại `docs/PROJECT_STATUS.md` để nắm rõ các mốc tọa độ và các việc cần làm tiếp theo.
4. Tận dụng thư viện trong `scripts/lisp/common_tools/` và `scripts/lisp/b01_standards/` để tiếp tục hoàn thiện hồ sơ thiết kế.

---

## 5. Liên hệ & Phụ trách
- Kỹ sư phụ trách: `pthieu2094-gif`
- Email: `pthieu2094@gmail.com`
