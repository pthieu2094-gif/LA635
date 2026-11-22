# GEMINI WORKSPACE INSTRUCTIONS: DỰ ÁN LA635 (B01 & B02)

## 1. Tổng quan & Vai trò
- **Dự án:** LA635 gồm Nhà giặt ủi (B01) và Nhà bảo dưỡng (B02) chung file `LA325.dwg`.
- **Hệ tọa độ:**
  - B01 nằm phía trên: $Y > -42,000$ (Mặt bằng $X \in [0, 36600]$, $Y \in [-6000, 30000]$).
  - B02 nằm phía dưới: $Y < -42,000$ (Mặt bằng $X \in [0, 36600]$, $Y \in [-59500, -45500]$).
  - Trục định vị 1..8 dài $36.6\text{ m}$ gióng thẳng hàng từ trên xuống dưới.
- **Cẩm nang tra cứu AutoLISP cho AI:** Đọc chi tiết tại `docs/AI_AUTOLISP_GUIDE.md`.

## 2. Cấu trúc 9 Module AutoLISP (`scripts/lisp/`)
Toàn bộ 91 file AutoLISP đã được tuyển chọn và tổ chức thành 9 thư mục chuyên biệt:
1. `architecture/`: Cửa (`door`), cầu thang (`cc`), độ dốc mái (`S1`, `s2`), diện tích phòng (`32`).
2. `structure/`: Đặt cột (`SCL1`), lưới trục (`VLT`, `DLT`, `R1`..`R4`), dầm cột MC6 (`fc`, `wc`), thép tổ hợp (`VI`), giằng X (`x1`), ti giằng (`TI`), bu lông (`BLN`, `BDT`), bản mã (`BMN`, `BM`, `1E`), Portal frame (`PORTAL`).
3. `annotation/`: Tạo dim (`DS`), căn chỉnh dim (`TOP`, `HI`), đổi tỉ lệ dim (`TDTL`), dóng đều khoảng cách (`SD`), cắt/bẻ chân dim (`CD`, `BD`), ghi chú chân dim (`TD`), cao độ (`CAODO`), căn lề leader (`all`, `alr`), khoanh mây (`REV`).
4. `text_tables/`: Copy text (`d1`), sửa text (`TC`), tính toán số trong text (`RT`, `CTT`), số thứ tự tăng dần (`cot`), chuyển field sang text tĩnh (`f2t`), sửa attribute block (`edt`), thống kê bảng (`tkt`), xuất tọa độ ra CAD/Excel (`XTD`, `atx`), xuất danh mục bản vẽ (`eatt`, `EAT1`).
5. `blocks/`: Đổi base point không xê dịch (`CBP`), nhân bản & đổi tên block (`cb`, `rr`, `DTB`), thay block hàng loạt (`TTB`).
6. `cad_cleanup/`: Làm phẳng $Z=0$ (`ZZZ`), nối polyline kín (`nn`), đo tổng chiều dài (`TL`), bẻ ngắt đường 1 điểm (`brn`), rải đối tượng (`rdt`), đổi về ByLayer (`lc`), căn điểm đầu (`BLB`..`BLR`), bật Osnap chuẩn (`5`), tra cứu DXF (`show`).
7. `layers_views_print/`: Phím tắt chuyển layer (`31`, `22`, `21`...), bật lại layer (`T5`), lọc đối tượng (`FF`, `ffd`, `fft`...), ẩn hiện nhanh (`InVis`, `Vis`), khóa viewport (`W`, `Z`), in ấn hàng loạt (`IN`), sửa font (`convertfont`).
8. `b01_standards/`: Bộ trích xuất chuẩn mực B01 (`inspect_b01_standards.lsp`, `dumpf.lsp`, `dumpg.lsp`).
9. `b02_implementation/`: Bộ dựng hình & hiệu chỉnh B02 (`b02grid.lsp`, `draw_b02_plan.lsp`, `draw_b02_elevs.lsp`, `draw_b02_roof.lsp`, `anno_b02_plan.lsp`, `anno_b02_elevs.lsp`, `clean_all_exploded_hatch.lsp`, `do_mirror.lsp`, `fix_three_issues.lsp`).

## 3. Quy tắc bắt buộc khi thao tác AutoCAD & LISP
- **TUYỆT ĐỐI KHÔNG TỰ Ý LƯU BẢN VẼ khi đang chỉnh sửa dở dang.** Chỉ lưu khi có sự xác nhận của người dùng hoặc sau khi hoàn thiện kiểm tra.
- **Làm phẳng bản vẽ 2D ($Z=0$):** Luôn dùng `scripts/lisp/cad_cleanup/TT_CHUYEN_Z_VE_0.lsp` (Lệnh: `ZZZ`) trước khi bắt điểm / dựng hình.
- **Tường & Hatch:**
  - Nối nét thành Polyline khép kín bằng `joinline.lsp` (Lệnh: `nn`) trước khi hatch.
  - Tường đặt layer `31 Drawing`, Hatch đặt layer `22 Hatch` (mẫu `LINE`, góc $45^\circ$, scale $50.0$).
  - Không hatch qua command line raw để tránh kẹt prompt; ưu tiên ActiveX COM `AddHatch` hoặc `_.-HATCH`.
- **Block:**
  - Cửa đi, cửa sổ, thiết bị đóng gói thành block chuẩn (`B02_DOOR_*`, `B02_WINDOW_*`).
  - Đổi base point dùng `LM_ChangeBlockBasePoint.lsp` (Lệnh: `CBP` / `CBC`).
  - Nhân bản/đổi tên block dùng `LM_CopyRenameBlock.lsp` (Lệnh: `cb`, `rr`).
  - Thay thế block hàng loạt dùng `TT_THAY_THE_BLOCK.lsp` (Lệnh: `TTB`).
- **Kích thước & Cao độ:**
  - Dim đặt trên layer `21 Dim`. Dóng đều dim bằng `TT_SPACE_DIM.lsp` (Lệnh: `SD`).
  - Cắt ngắn chân dim thừa bằng `Auto_Cut_Dimension_CD_BD.lsp` (Lệnh: `CD`).
  - Ghi chú chân dim dùng `TT_TEXT_DIM_BELOW.lsp` (Lệnh: `TD`).
  - Cập nhật cao độ dùng `TT_UPDATE_CAO_DO.lsp` (Lệnh: `CAODO`).
- **Thang & Mái:**
  - Bậc thang rộng chuẩn $250\text{ mm}$ chia tự động bằng `TT_STAIRCASE_V1.lsp` (Lệnh: `cc`).
  - Dốc mái dùng `TT_VE_DO_DOC_SLOPE.lsp` (Lệnh: `S1`) và `TT_DRAW_SLOPE_XLINE.lsp` (Lệnh: `s2`).
- **Ghi chú & Revision:**
  - Căn lề leader & text bằng `TT_CANH_LEADER_TEXT.lsp` (Lệnh: `all`, `alr`).
  - Sao chép nội dung text bằng `TT_COPY_TEXT.lsp` (Lệnh: `d1`).
  - Chuyển field sang text tĩnh bằng `TT_CONVERT_FIELD_TO_TEXT.lsp` (Lệnh: `f2t`).
  - Khoanh mây revision sửa đổi bằng `TT_KHOANH_MAY_REV.lsp` (Lệnh: `REV`).
- **Layout & Viewport:**
  - Khóa khung nhìn Viewport trong layout bằng `TT_KHOA_VIEWPORT.lsp` (Lệnh: `W`).
