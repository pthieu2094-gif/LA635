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
│   ├── DRAFTING_RULES.md           # Bộ quy tắc vẽ AutoCAD chuẩn (layer, polyline, hatch, block)
│   └── AI_AUTOLISP_GUIDE.md        # Cẩm nang toàn diện hướng dẫn AI & Kỹ sư sử dụng 91 AutoLISP
├── scripts/                        # Bộ công cụ tự động hóa
│   ├── lisp/                       # Hệ thống 91 tiện ích AutoLISP phân loại thành 9 Module chuẩn:
│   │   ├── b01_standards/          # LISP trích xuất chuẩn mực, khung tên và lưới trục B01 (3 files)
│   │   ├── b02_implementation/     # LISP dựng hình, dọn hatch, mirror và fix lỗi B02 (9 files)
│   │   ├── architecture/           # Tiện ích Kiến trúc: cửa, thang, dốc mái, diện tích (5 files)
│   │   ├── structure/              # Tiện ích Kết cấu: cột, dầm, giằng, ti, bu lông, bản mã, portal (24 files)
│   │   ├── annotation/             # Kích thước, cao độ, dóng hàng dim, căn lề leader, khoanh mây (12 files)
│   │   ├── text_tables/            # Xử lý text, cộng trừ số, số tăng dần, trích xuất bảng/excel (12 files)
│   │   ├── blocks/                 # Đổi base point không xê dịch, nhân bản, đổi tên, thay thế block (5 files)
│   │   ├── cad_cleanup/            # Làm phẳng Z=0, nối nét kín, tính chiều dài, bẻ ngắt đường (10 files)
│   │   └── layers_views_print/     # Phím tắt layer, khóa viewport layout, in ấn hàng loạt, sửa font (11 files)
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

### C. Hệ thống 7 Module Thư viện Chuyên ngành (`scripts/lisp/`)
Toàn bộ 79 tiện ích CAD thực chiến từ kho dữ liệu kỹ sư được chuẩn hóa và phân vào 7 module chức năng:

1. **`architecture/` (Kiến trúc):** Cửa đi (`door`), cầu thang bộ (`cc`), độ dốc mái (`S1`, `s2`), diện tích phòng (`32`).
2. **`structure/` (Kết cấu & Thép tiền chế):** Đặt cột trục (`SCL1`), lưới trục (`VLT`, `DLT`), dầm cột MC6 (`fc`, `wc`), thép tổ hợp (`VI`), giằng X (`x1`), ti giằng (`TI`), bu lông neo (`BLN`, `BDT`), bản mã ngầm (`BMN`), endplate (`1E`), Portal frame (`PORTAL`).
3. **`annotation/` (Kích thước & Chú thích):** Tạo dim (`DS`), căn chỉnh dim (`TOP`, `HI`), đổi tỉ lệ dim (`TDTL`), dóng đều khoảng cách (`SD`), cắt/bẻ chân dim (`CD`, `BD`), ghi chú chân dim (`TD`), cao độ (`CAODO`), căn lề leader (`all`, `alr`), khoanh mây revision (`REV`).
4. **`text_tables/` (Văn bản & Bảng biểu):** Copy text (`d1`), sửa text (`TC`), cộng trừ số trong text (`RT`, `CTT`), số thứ tự tăng dần (`cot`), chuyển field sang text tĩnh (`f2t`), sửa attribute block (`edt`), thống kê bảng (`tkt`), xuất tọa độ ra CAD/Excel (`XTD`, `atx`), xuất danh mục bản vẽ (`eatt`, `EAT1`).
5. **`blocks/` (Quản lý Block):** Đổi base point không xê dịch (`CBP`), nhân bản & đổi tên block (`cb`, `rr`, `DTB`), thay block hàng loạt (`TTB`).
6. **`cad_cleanup/` (Làm sạch & Chuẩn hóa):** Làm phẳng Z=0 (`ZZZ`), nối nét kín (`nn`), đo tổng chiều dài (`TL`), bẻ ngắt đường 1 điểm (`brn`), rải đối tượng (`rdt`), đổi về ByLayer (`lc`), căn điểm đầu (`BLB`..`BLR`), bật Osnap chuẩn (`5`).
7. **`layers_views_print/` (Layer, Viewport & In ấn):** Phím tắt chuyển layer (`31`, `22`, `21`...), bật lại layer (`T5`), lọc đối tượng (`FF`, `ffd`, `fft`...), ẩn hiện nhanh (`InVis`, `Vis`), khóa viewport (`W`, `Z`), in ấn hàng loạt ra PDF (`IN`), sửa lỗi font tiếng Việt (`convertfont`).

> 📖 **Xem hướng dẫn chi tiết từng lệnh, workflow và lưu ý phòng tránh lỗi tại:** [docs/AI_AUTOLISP_GUIDE.md](file:///E:/02.%20PART%20TIME/LA635/docs/AI_AUTOLISP_GUIDE.md)

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
3. Đọc tài liệu chi tiết tại `docs/PROJECT_STATUS.md` và quy tắc vẽ tại `docs/DRAFTING_RULES.md`.
4. Tra cứu cách dùng 91 file AutoLISP trong `docs/AI_AUTOLISP_GUIDE.md` để triển khai tiếp các bản vẽ tầng 2, mặt đứng, mặt cắt và chi tiết liên kết.

---

## 5. Liên hệ & Phụ trách
- Kỹ sư phụ trách: `pthieu2094-gif`
- Email: `pthieu2094@gmail.com`
