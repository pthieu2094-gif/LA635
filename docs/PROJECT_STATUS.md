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

## 5. Hệ thống công cụ AutoLISP kế thừa và tự động hóa (`scripts/lisp/`)

Để đảm bảo dự án có thể tiếp tục triển khai trơn tru trên bất kỳ thiết bị nào mà không bị phụ thuộc vào môi trường máy cũ, toàn bộ công cụ AutoLISP đã được gom về và phân loại thành 3 nhóm chuyên trách trong repository:

### A. Nhóm LISP Chuẩn mực B01 (`scripts/lisp/b01_standards/`)
Lấy mẫu và kiểm tra đối chiếu trực tiếp từ khối công trình B01:
- `inspect_b01_standards.lsp` (Lệnh: `INSPECT_B01_STANDARDS`): Trích xuất thông số kỹ thuật mẫu (tên layer, góc xoay hatch mặt cắt tường $45^\circ$, scale $50$, quy cách block cửa).
- `dumpf.lsp` (Lệnh: `DUMPF`): Quét tọa độ và thuộc tính khung tên của B01 để nhân bản cho B02.
- `dumpg.lsp` (Lệnh: `DUMPG`): Quét tọa độ hệ trục và dim mẫu của B01.

### B. Nhóm LISP Triển khai B02 (`scripts/lisp/b02_implementation/`)
Toàn bộ mã nguồn dựng hình và hiệu chỉnh Nhà bảo dưỡng B02 theo hồ sơ Rev01:
- `b02grid.lsp` (Lệnh: `B02GRID`): Tự động phát sinh hệ lưới trục Trục 1..8 và Trục A, B, C cho B02.
- `draw_b02_plan.lsp` (Lệnh: `DRAW_PLAN_LINES`): Dựng tim tường và polyline bao che mặt bằng tầng 1.
- `draw_b02_elevs.lsp` (Lệnh: `DRAW_B02_ELEVS`): Dựng nét bao cho 4 mặt đứng của B02.
- `draw_b02_roof.lsp` (Lệnh: `DRAW_B02_ROOF`): Dựng mặt bằng mái B02.
- `anno_b02_plan.lsp` (Lệnh: `ANNO_B02_PLAN`): Ghi chú tên phòng, cao độ hoàn thiện và dim mặt bằng.
- `anno_b02_elevs.lsp` (Lệnh: `COMPLETE_B02_ELEVS`): Hoàn thiện ghi chú cao độ và trục mặt đứng.
- `clean_all_exploded_hatch.lsp` (Lệnh: `SCAN_ALL_EXPLODED_HATCH`): Quét và xóa toàn bộ các đoạn line vụn do hatch bị rã trước đó, giải phóng tài nguyên bản vẽ.
- `do_mirror.lsp` (Lệnh: `DO_MIRROR`): Mirror thiết bị WC trái đối xứng hoàn hảo qua tim $X_c = 28,700.8$.
- `fix_three_issues.lsp` (Lệnh: `FIX_ALL`): Xử lý dứt điểm 3 lỗi kiến trúc (cột Trục 6-C, khép kín tường Trục C, chia đều bậc thang $250\text{ mm}$).

### C. Nhóm Thư viện Dùng chung (`scripts/lisp/common_tools/`)
Bộ công cụ CAD chuyên nghiệp kế thừa từ kho dữ liệu chuẩn của kỹ sư (`E:\00. DATA\01. CAD\00. AUTOLISP\`), giúp vẽ và hiệu chỉnh siêu tốc:
- `TT_CHUYEN_Z_VE_0.lsp` (Lệnh: `ZZZ`): Đưa toàn bộ đối tượng về $Z = 0$ (làm phẳng bản vẽ 2D, chống lỗi lệch cao độ).
- `joinline.lsp` (Lệnh: `nn`): Nối các đoạn Line/Arc rời rạc thành Polyline kín (`Closed`).
- `TT_SNAP_ON.lsp` (Lệnh: `5`): Bật đầy đủ chế độ Osnap bắt điểm chuẩn.
- `LM_ChangeBlockBasePoint.lsp` (Lệnh: `CBP`, `CBC`): Đổi điểm đặt block mà không làm lệch vị trí chèn.
- `LM_CopyRenameBlock.lsp` (Lệnh: `cb`, `rr`): Nhân bản và đổi tên block trực tiếp.
- `TT_THAY_THE_BLOCK.lsp` (Lệnh: `TTB`): Thay thế hàng loạt block cũ bằng block mới.
- `TT_STAIRCASE_V1.lsp` (Lệnh: `cc`): Tự động tính toán và chia bậc thang theo kích thước yêu cầu.
- `TT_DOOR.lsp` (Lệnh: `door`): Tiện ích vẽ và chèn cửa kiến trúc theo kích thước linh hoạt.
- `TT_DAT_COT_TRUC.lsp` (Lệnh: `SCL1`): Đặt cột hàng loạt tại các giao điểm lưới trục.
- `TT_TAO_DIM.lsp` (Lệnh: `DS`): Khởi tạo hệ thống DimStyle kiến trúc chuẩn mực.
- `TT_TDTL_LAYER_DIM.lsp` (Lệnh: `TDTL`): Thay đổi tỉ lệ và chuyển layer cho Dimension.
- `TT_SPACE_DIM.lsp` (Lệnh: `SD`): Dóng đều khoảng cách giữa các hàng Dimension.
- `TT_TEXT_DIM_BELOW.lsp` (Lệnh: `TD`): Thêm text ghi chú bên dưới đường dim.
- `TT_UPDATE_CAO_DO.lsp` (Lệnh: `CAODO`): Cập nhật ký hiệu và giá trị cao độ trên mặt cắt/mặt đứng.
- `TT_VE_DO_DOC_SLOPE.lsp` (Lệnh: `S1`): Vẽ mũi tên và ký hiệu độ dốc mái (Slope $i\%$).
- `TT_DRAW_SLOPE_XLINE.lsp` (Lệnh: `s2`): Bắn đường dóng XLINE vô tận theo góc dốc mái.
- `TT_CANH_LEADER_TEXT.lsp` (Lệnh: `all`, `alr`): Căn lề trái/phải cho Leader và Text thẳng hàng.
- `TT_COPY_TEXT.lsp` (Lệnh: `d1`): Sao chép nội dung text này sang text khác bằng 1 click.
- `TT_CONVERT_FIELD_TO_TEXT.lsp` (Lệnh: `f2t`): Chuyển Field thành Text tĩnh chống lỗi nhảy chữ.
- `TT_KHOANH_MAY_REV.lsp` (Lệnh: `REV`): Khoanh mây Revision đánh dấu thay đổi theo comment.
- `TT_KHOA_VIEWPORT.lsp` (Lệnh: `W`): Khóa và mở khóa Viewport trong Layout chống zoom lệch tỉ lệ.
- `TT_LAYON_ALL.lsp` (Lệnh: `T5`): Bật nhanh toàn bộ layer đang bị ẩn.
- `tl.lsp` (Lệnh: `TL`): Tính tổng chiều dài danh sách đường nét được chọn.
- `TONG_HOP_Chinh_Dim_Layer.lsp` (Các lệnh: `DS`, `TOP`, `HI`, `Q1`, `Q2`...): Tinh chỉnh và chuẩn hóa kích thước.
- `TONG_HOP_Chuyen_Layer.lsp` (Các phím số tắt: `31`, `22`, `21`, `11`, `32`...): Chuyển nhanh layer đối tượng chỉ bằng 1 thao tác bấm phím.
- `TONG_HOP_Chinh_Sua_Text.lsp` (Các lệnh: `TC`, `tv`, `yu`, `YY`, `XO`...): Bộ công cụ căn chỉnh, đổi font, nối text.
- `TT_CANH_DIEM_DAU_LINE.lsp` (Lệnh: `BLB`, `BLT`, `BLL`, `BLR`): Căn dóng điểm đầu của các line/polyline.
- `TT_XUAT_DANH_SACH_BAN_VE.lsp` (Lệnh: `eatt`): Tự động trích xuất danh mục bản vẽ từ khung tên.
- `TT_TIEN_ICH_KHAC.lsp` (Lệnh: `InVis`, `Vis`, `SF`, `EE`...): Ẩn hiện đối tượng chọn lọc, lọc tìm nhanh.

---

## 6. Hướng dẫn cho thiết bị khác tiếp tục triển khai

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
4. **Quy trình phối hợp LISP khi vẽ:**
   - Dùng `scripts/lisp/common_tools/TONG_HOP_Chuyen_Layer.lsp` để gán nhanh layer chuẩn (`31` cho tường, `22` cho hatch, `21` cho dim).
   - Dùng `joinline.lsp` (`nn`) để đảm bảo toàn bộ nét tường thành Polyline kín trước khi Hatch.
   - Dùng `TT_TAO_DIM.lsp` và `TT_TDTL_LAYER_DIM.lsp` để đánh kích thước chuẩn tỉ lệ.
