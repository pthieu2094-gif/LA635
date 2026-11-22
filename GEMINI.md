# GEMINI WORKSPACE INSTRUCTIONS: DỰ ÁN LA635 (B01 & B02)

## 1. Tổng quan & Vai trò
- **Dự án:** LA635 gồm Nhà giặt ủi (B01) và Nhà bảo dưỡng (B02) chung file `LA325.dwg`.
- **Hệ tọa độ:**
  - B01 nằm phía trên: $Y > -42,000$ (Mặt bằng $X \in [0, 36600]$, $Y \in [-6000, 30000]$).
  - B02 nằm phía dưới: $Y < -42,000$ (Mặt bằng $X \in [0, 36600]$, $Y \in [-59500, -45500]$).
  - Trục định vị 1..8 dài $36.6\text{ m}$ gióng thẳng hàng từ trên xuống dưới.

## 2. Quy tắc bắt buộc khi thao tác AutoCAD & LISP
- **TUYỆT ĐỐI KHÔNG TỰ Ý LƯU BẢN VẼ khi đang chỉnh sửa dở dang.** Chỉ lưu khi có sự xác nhận của người dùng hoặc sau khi hoàn thiện kiểm tra.
- **Làm phẳng bản vẽ 2D ($Z=0$):** Luôn dùng `scripts/lisp/common_tools/TT_CHUYEN_Z_VE_0.lsp` (Lệnh: `ZZZ`) trước khi bắt điểm / dựng hình.
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
  - Đổi tỉ lệ/layer dim dùng `TT_TDTL_LAYER_DIM.lsp` (Lệnh: `TDTL`).
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
