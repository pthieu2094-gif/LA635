import fs from "node:fs";

const SCRATCH = "C:/Users/OS/.gemini/antigravity/brain/303f920f-b9ed-4f10-846f-24fd474aca76/scratch";

// ================================================================
// QUY CHUẨN ĐÁY BẰNG NHAU TOÀN BỘ DỰ ÁN (KIẾN TRÚC + BU LÔNG NEO)
// Toàn bộ dự án: Ground Floor, Roof Plan, Elevations đều có Y_min = -12607.6
// Khung A$Ce291ec07 (scale 150): Insertion Y = 48712.42
// Bounding box: Y from -12607.6 to 52878.7 (Height = 65486.3 mm)
// ================================================================
const Y_BOTTOM = -12607.6;
const FRAME_INSERT_Y = 48712.42;
const FRAME_WIDTH = 87255.5;

// Sheet 1 (Mặt bằng Bu lông neo 1/150)
const FRAME1_X = 353000.0;
const PX = FRAME1_X + 16692.16; // = 369692.16 (Grid A)
const PY = 0.0;                 // Grid 1 ở Y = 0.0 (giống Ground Floor Plan 100%!)

// Sheet 2 (Chi tiết Bu lông neo 1/10)
const FRAME2_X = FRAME1_X + FRAME_WIDTH + 3744.5; // = 444000.0

// Load column instances
const cols = fs.readFileSync(SCRATCH + "/b01_col_instances.txt", "utf8")
  .trim().split("\n")
  .map(l => {
    const [bname, rx, ry, rot] = l.trim().split("|");
    return { bname, rx: parseFloat(rx), ry: parseFloat(ry), rot: parseFloat(rot) };
  });

// 7 Column types mapped to A1..A7 (giữ nguyên cho Sheet 2)
const typeMap = {
  "B01_250x165_PL286x185_4M20": { tag: "A1", name: "250x165", pl: "PL-16x185x286", bolts: "4AB M20", plW: 185, plL: 286, colH: 250, colB: 165 },
  "B01_250x150_PL282x185_4M20": { tag: "A2", name: "250x150", pl: "PL-16x185x282", bolts: "4AB M20", plW: 185, plL: 282, colH: 250, colB: 150 },
  "B01_300x150_PL336x185_4M20": { tag: "A3", name: "300x150", pl: "PL-16x185x336", bolts: "4AB M20", plW: 185, plL: 336, colH: 300, colB: 150 },
  "B01_400x185_PL436x185_6M20": { tag: "A4", name: "400x185", pl: "PL-16x185x436", bolts: "6AB M20", plW: 185, plL: 436, colH: 400, colB: 185 },
  "B01_300x165_PL336x185_4M20": { tag: "A5", name: "300x165", pl: "PL-16x185x336", bolts: "4AB M20", plW: 185, plL: 336, colH: 300, colB: 165 },
  "B01_400x250_PL436x250_6M20": { tag: "A6", name: "400x250", pl: "PL-16x250x436", bolts: "6AB M20", plW: 250, plL: 436, colH: 400, colB: 250 },
  "B01_300x185_PL336x185_4M20": { tag: "A7", name: "300x185", pl: "PL-16x185x336", bolts: "4AB M20", plW: 185, plL: 336, colH: 300, colB: 185 }
};

// Grids definition chuẩn 100% từ B01 Ground Floor Plan
const xGrids = [
  { name: "A",  off: 0.0 },
  { name: "A'", off: 1930.0 },
  { name: "B",  off: 5000.0 },
  { name: "C",  off: 11250.0 },
  { name: "D",  off: 17500.0 },
  { name: "E",  off: 23750.0 },
  { name: "F",  off: 30000.0 },
  { name: "G",  off: 36250.0 },
  { name: "H",  off: 42500.0 },
  { name: "H'", off: 45970.0 },
  { name: "I",  off: 50000.0 }
];

const yGrids = [
  { name: "1",  off: 0.0 },
  { name: "2",  off: 5830.0 },
  { name: "2'", off: 9830.0 },
  { name: "3",  off: 11830.0 },
  { name: "4",  off: 17830.0 },
  { name: "5",  off: 20580.0 },
  { name: "6",  off: 26580.0 },
  { name: "7",  off: 32580.0 },
  { name: "8",  off: 36400.0 }
];

let lsp = `;; ================================================================
;; DEPLOY_PROJECT_ALIGNED.LSP
;; - Quy chuẩn ĐÁY BẰNG NHAU TOÀN BỘ DỰ ÁN KIẾN TRÚC + BU LÔNG NEO: Y = ${Y_BOTTOM}
;; - Cả Sheet 1 và Sheet 2 đều dùng khung A$Ce291ec07 nhân bản từ mẫu có Field động Scale X
;; - 10 cụm chi tiết có 10 MÀU KHÁC NHAU: A1, A2, A3, A3A, A4, A5, A5A, A6, A7, A7A
;; - Ký hiệu Hex Tag QHP_AnchorBolt_Tag_2022 có Scale X = 150 (bằng đúng tỷ lệ khung view 1/150)
;; - Không có text below dim
;; - Sử dụng block ATAD_LEVEL_TAG đặt thoáng tại khoang C-D (không clash)
;; ================================================================
(vl-load-com)

(defun c:DEPLOY_PROJECT_ALIGNED (/ acadDoc mSpace logF)
  (setq logF (open "C:/Users/OS/.gemini/antigravity/brain/303f920f-b9ed-4f10-846f-24fd474aca76/scratch/deploy_project_aligned_log.txt" "w"))
  (defun logMsg (msg)
    (write-line msg logF)
    (princ (strcat "\\n" msg))
  )
  (defun *error* (msg)
    (if logF (progn (write-line (strcat "ERROR: " msg) logF) (close logF)))
    (princ (strcat "\\nERROR: " msg))
  )

  (logMsg "=== DEPLOY PROJECT ALIGNED START ===")
  (setq acadDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq mSpace (vla-get-ModelSpace acadDoc))

  ;; Ensure DASHED linetype exists
  (if (not (tblsearch "LTYPE" "DASHED"))
    (vl-catch-all-apply 'vla-load (list (vla-get-Linetypes acadDoc) "DASHED" "acad.lin"))
  )

  ;; ---------------- HELPERS ----------------
  (defun safeSetLayer (obj lyr)
    (if (and lyr (tblsearch "LAYER" lyr))
      (vl-catch-all-apply 'vla-put-Layer (list obj lyr))
    )
  )

  (defun mkTxt (pt txt h lyr c / tObj)
    (setq tObj (vla-AddText mSpace txt (vlax-3d-point pt) h))
    (safeSetLayer tObj lyr)
    (if c (vla-put-Color tObj c))
    tObj
  )

  (defun mkLine (p1 p2 lyr c lt / lObj)
    (setq lObj (vla-AddLine mSpace (vlax-3d-point p1) (vlax-3d-point p2)))
    (safeSetLayer lObj lyr)
    (if c (vla-put-Color lObj c))
    (if lt (vla-put-Linetype lObj lt))
    lObj
  )

  (defun mkCircle (pt r lyr c / cObj)
    (setq cObj (vla-AddCircle mSpace (vlax-3d-point pt) r))
    (safeSetLayer cObj lyr)
    (if c (vla-put-Color cObj c))
    cObj
  )

  (defun mkRect (minx miny maxx maxy lyr c lt lts / pts arr pObj)
    (setq pts (list minx miny maxx miny maxx maxy minx maxy))
    (setq arr (vlax-make-safearray vlax-vbDouble '(0 . 7)))
    (vlax-safearray-fill arr pts)
    (setq pObj (vla-AddLightWeightPolyline mSpace arr))
    (vla-put-Closed pObj :vlax-true)
    (safeSetLayer pObj lyr)
    (if c (vla-put-Color pObj c))
    (if lt (vla-put-Linetype pObj lt))
    (if lts (vla-put-LinetypeScale pObj lts))
    pObj
  )

  (defun mkRoundRect (minx miny maxx maxy r lyr c lt lts / pts arr pObj)
    (setq pts (list
      (+ minx r) miny
      (- maxx r) miny
      maxx (+ miny r)
      maxx (- maxy r)
      (- maxx r) maxy
      (+ minx r) maxy
      minx (- maxy r)
      minx (+ miny r)
    ))
    (setq arr (vlax-make-safearray vlax-vbDouble '(0 . 15)))
    (vlax-safearray-fill arr pts)
    (setq pObj (vla-AddLightWeightPolyline mSpace arr))
    (vla-put-Closed pObj :vlax-true)
    (vla-SetBulge pObj 1 0.41421356)
    (vla-SetBulge pObj 3 0.41421356)
    (vla-SetBulge pObj 5 0.41421356)
    (vla-SetBulge pObj 7 0.41421356)
    (safeSetLayer pObj lyr)
    (if c (vla-put-Color pObj c))
    (if lt (vla-put-Linetype pObj lt))
    (if lts (vla-put-LinetypeScale pObj lts))
    pObj
  )

  ;; Clone view frame block A$Ce291ec07 from original to preserve dynamic Scale X field
  (defun addViewFrame (insX / fRef ssSrc srcObj i ent obj insP)
    (setq ssSrc (ssget "X" '((0 . "INSERT") (2 . "*A$Ce291ec07*"))))
    (setq srcObj nil i 0)
    (if ssSrc
      (while (and (< i (sslength ssSrc)) (not srcObj))
        (setq ent (ssname ssSrc i))
        (setq obj (vlax-ename->vla-object ent))
        (setq insP (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
        (if (< (car insP) 0.0)
          (setq srcObj obj)
        )
        (setq i (1+ i))
      )
    )
    (if srcObj
      (progn
        (setq fRef (vla-Copy srcObj))
        (vla-Move fRef (vlax-3d-point (list -16692.16 48712.42 0.0)) (vlax-3d-point (list insX ${FRAME_INSERT_Y} 0.0)))
        (safeSetLayer fRef "1.NVB-BLACK LINE")
        fRef
      )
    )
  )

  ;; Dimension helper using ATAD1-150 DimStyle & 150 scale factor
  (defun addHDim (x1 x2 y dimY lyr / p1 p2 pLine dObj)
    (setq p1 (vlax-3d-point (list x1 y 0.0)))
    (setq p2 (vlax-3d-point (list x2 y 0.0)))
    (setq pLine (vlax-3d-point (list (/ (+ x1 x2) 2.0) dimY 0.0)))
    (setq dObj (vla-AddDimRotated mSpace p1 p2 pLine 0.0))
    (safeSetLayer dObj lyr)
    (if (tblsearch "DIMSTYLE" "ATAD1-150")
      (vl-catch-all-apply 'vla-put-StyleName (list dObj "ATAD1-150"))
    )
    (vl-catch-all-apply 'vla-put-ScaleFactor (list dObj 150.0))
    dObj
  )

  (defun addVDim (y1 y2 x dimX lyr / p1 p2 pLine dObj)
    (setq p1 (vlax-3d-point (list x y1 0.0)))
    (setq p2 (vlax-3d-point (list x y2 0.0)))
    (setq pLine (vlax-3d-point (list dimX (/ (+ y1 y2) 2.0) 0.0)))
    (setq dObj (vla-AddDimRotated mSpace p1 p2 pLine (/ pi 2.0)))
    (safeSetLayer dObj lyr)
    (if (tblsearch "DIMSTYLE" "ATAD1-150")
      (vl-catch-all-apply 'vla-put-StyleName (list dObj "ATAD1-150"))
    )
    (vl-catch-all-apply 'vla-put-ScaleFactor (list dObj 150.0))
    dObj
  )

  (defun insGridTag (pt tag / blkRef atts)
    (setq blkRef (vla-InsertBlock mSpace (vlax-3d-point pt) "ATAD_GRIDLINE_TAG" 150.0 150.0 150.0 0.0))
    (safeSetLayer blkRef "31 Drawing")
    (if (and (= (vla-get-HasAttributes blkRef) :vlax-true)
             (setq atts (vlax-invoke blkRef 'GetAttributes)))
      (vla-put-TextString (car atts) tag)
    )
    blkRef
  )

  ;; Scale X = 150.0, đúng bằng tỷ lệ khung view 1/150!
  (defun insHexTag (pt tag / blkRef atts)
    (setq blkRef (vla-InsertBlock mSpace (vlax-3d-point pt) "QHP_AnchorBolt_Tag_2022" 150.0 150.0 150.0 0.0))
    (safeSetLayer blkRef "0")
    (if (and (= (vla-get-HasAttributes blkRef) :vlax-true)
             (setq atts (vlax-invoke blkRef 'GetAttributes)))
      (vla-put-TextString (car atts) tag)
    )
    blkRef
  )

  ;; Insert ATAD_LEVEL_TAG at scale 150 with NOTE and LEVEL attributes
  (defun insLevelTag (pt note lvl / blkRef atts)
    (setq blkRef (vla-InsertBlock mSpace (vlax-3d-point pt) "ATAD_LEVEL_TAG" 150.0 150.0 150.0 0.0))
    (safeSetLayer blkRef "31 Drawing")
    (if (and (= (vla-get-HasAttributes blkRef) :vlax-true)
             (setq atts (vlax-invoke blkRef 'GetAttributes)))
      (foreach att atts
        (cond
          ((= (strcase (vla-get-TagString att)) "NOTE")
           (vla-put-TextString att note))
          ((= (strcase (vla-get-TagString att)) "LEVEL")
           (vla-put-TextString att lvl))
        )
      )
    )
    blkRef
  )

  ;; ---------------- STEP 1: CLEANUP TARGET AREA ----------------
  (logMsg "Step 1: Cleaning up previous entities...")
  (setq ssDel (ssget "X"))
  (if ssDel
    (progn
      (setq iDel 0 nDel 0)
      (while (< iDel (sslength ssDel))
        (setq eItem (ssname ssDel iDel))
        (setq dItem (entget eItem))
        (setq ptDel (cdr (assoc 10 dItem)))
        (if ptDel
          (cond
            ;; Lower row cleanup
            ((and (>= (car ptDel) 320000.0) (<= (car ptDel) 550000.0)
                  (>= (cadr ptDel) -100000.0) (<= (cadr ptDel) -15000.0))
             (vl-catch-all-apply 'vla-delete (list (vlax-ename->vla-object eItem)))
             (setq nDel (1+ nDel)))
            ;; Right zone cleanup (beyond elevation 4 at 349536)
            ((and (> (car ptDel) 350000.0) (<= (car ptDel) 550000.0)
                  (>= (cadr ptDel) -15000.0) (<= (cadr ptDel) 60000.0))
             (vl-catch-all-apply 'vla-delete (list (vlax-ename->vla-object eItem)))
             (setq nDel (1+ nDel)))
          )
        )
        (setq iDel (1+ iDel))
      )
      (logMsg (strcat "Cleaned " (itoa nDel) " entities."))
    )
  )

  ;; ---------------- STEP 2: SHEET 1 (ANCHOR BOLT PLAN 1/150) ----------------
  (logMsg "Step 2: Building Sheet 1 (Anchor Bolt Plan 1/150, Project Bottom = ${Y_BOTTOM})...")
  (addViewFrame ${FRAME1_X})

  ;; Grid lines
`;

// X Grids (Vertical lines, bubbles on Top only)
xGrids.forEach(g => {
  const gx = PX + g.off;
  const yBottom = PY - 3000.0;
  const yTop = PY + 42416.9;
  const yTag = PY + 43054.4;
  lsp += `  (mkLine (list ${gx} ${yBottom} 0.0) (list ${gx} ${yTop} 0.0) "32 Gridline" 251 nil)\n`;
  lsp += `  (insGridTag (list ${gx} ${yTag} 0.0) "${g.name}")\n`;
});

// Y Grids (Horizontal lines, bubbles on Left only)
yGrids.forEach(g => {
  const gy = PY + g.off;
  const xLeft = PX - 9468.4;
  const xRight = PX + 53000.0;
  const xTag = PX - 10105.9;
  lsp += `  (mkLine (list ${xLeft} ${gy} 0.0) (list ${xRight} ${gy} 0.0) "32 Gridline" 251 nil)\n`;
  lsp += `  (insGridTag (list ${xTag} ${gy} 0.0) "${g.name}")\n`;
});

// Dimensions (Top and Left only) using ATAD1-150 DimStyle - KHÔNG CÓ TEXT BELOW DIM
lsp += `\n  ;; Dimensions on Sheet 1 (DimStyle ATAD1-150) - No text below dim\n`;
for (let i = 0; i < xGrids.length - 1; i++) {
  const x1 = PX + xGrids[i].off;
  const x2 = PX + xGrids[i+1].off;
  lsp += `  (addHDim ${x1} ${x2} ${PY + 36400.0} ${PY + 40340.0} "21 Dim")\n`;
}
// Dim tổng trên: KHÔNG text below dim
lsp += `  (addHDim ${PX} ${PX + 50000.0} ${PY + 36400.0} ${PY + 41540.0} "21 Dim")\n`;

for (let i = 0; i < yGrids.length - 1; i++) {
  const y1 = PY + yGrids[i].off;
  const y2 = PY + yGrids[i+1].off;
  lsp += `  (addVDim ${y1} ${y2} ${PX} ${PX - 7540.0} "21 Dim")\n`;
}
// Dim tổng trái: KHÔNG text below dim
lsp += `  (addVDim ${PY} ${PY + 36400.0} ${PX} ${PX - 8740.0} "21 Dim")\n`;

// 33 Columns
lsp += `\n  ;; Placing 33 Column Blocks\n`;
cols.forEach(c => {
  const cx = PX + c.rx;
  const cy = PY + c.ry;
  const rotRad = (c.rot * Math.PI / 180.0).toFixed(4);
  lsp += `  (vla-InsertBlock mSpace (vlax-3d-point (list ${cx} ${cy} 0.0)) "${c.bname}" 1.0 1.0 1.0 ${rotRad})\n`;
});

// ================================================================
// 10 CỤM CHI TIẾT VỚI 10 MÀU KHÁC NHAU 100%
// Scale của Tag = 150 (bằng đúng Scale X của khung view!)
// ================================================================
lsp += `
  ;; ---------------- CÁC CỤM KHOANH MÀU KHÁC NHAU ----------------
  
  ;; --- CỤM A1 (Color 1 - Red): Cột góc A/1 và A/8 ---
  (mkRoundRect ${PX + 0.0 - 800.0} ${PY + 0.0 - 800.0} ${PX + 0.0 + 800.0} ${PY + 0.0 + 800.0} 300.0 nil 1 "DASHED" 300.0)
  (insHexTag (list ${PX + 0.0 - 2000.0} ${PY + 0.0} 0.0) "A1")
  (mkRoundRect ${PX + 0.0 - 800.0} ${PY + 36400.0 - 800.0} ${PX + 0.0 + 800.0} ${PY + 36400.0 + 800.0} 300.0 nil 1 "DASHED" 300.0)
  (insHexTag (list ${PX + 0.0 - 2000.0} ${PY + 36400.0} 0.0) "A1")

  ;; --- CỤM A2 (Color 3 - Green): Cột biên Trục 1 (B..H) và Trục 8 (B..H), cộng cột góc I/1, I/8 ---
  (mkRoundRect ${PX + 5000.0 - 800.0} ${PY + 0.0 - 800.0} ${PX + 42500.0 + 800.0} ${PY + 0.0 + 800.0} 400.0 nil 3 "DASHED" 300.0)
  (insHexTag (list ${PX + 23750.0} ${PY + 0.0 - 2000.0} 0.0) "A2")
  (mkRoundRect ${PX + 5000.0 - 800.0} ${PY + 36400.0 - 800.0} ${PX + 42500.0 + 800.0} ${PY + 36400.0 + 800.0} 400.0 nil 3 "DASHED" 300.0)
  (insHexTag (list ${PX + 23750.0} ${PY + 36400.0 + 2000.0} 0.0) "A2")
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 0.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 0.0 + 800.0} 300.0 nil 3 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 0.0} 0.0) "A2")
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 36400.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 36400.0 + 800.0} 300.0 nil 3 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 36400.0} 0.0) "A2")

  ;; --- CỤM A3 (Color 4 - Cyan): Cột biên Trục A trừ cột A/6 ---
  ;; Phần A/2 đến A/5:
  (mkRoundRect ${PX + 0.0 - 800.0} ${PY + 5830.0 - 800.0} ${PX + 0.0 + 800.0} ${PY + 20580.0 + 800.0} 400.0 nil 4 "DASHED" 300.0)
  (insHexTag (list ${PX + 0.0 - 2000.0} ${PY + 13205.0} 0.0) "A3")
  ;; Phần A/7:
  (mkRoundRect ${PX + 0.0 - 800.0} ${PY + 32580.0 - 800.0} ${PX + 0.0 + 800.0} ${PY + 32580.0 + 800.0} 300.0 nil 4 "DASHED" 300.0)
  (insHexTag (list ${PX + 0.0 - 2000.0} ${PY + 32580.0} 0.0) "A3")

  ;; --- CỤM A3A (Color 30 - Orange): Cột cos +0.00 tại Trục A/6 ---
  (mkRoundRect ${PX + 0.0 - 800.0} ${PY + 26580.0 - 800.0} ${PX + 0.0 + 800.0} ${PY + 26580.0 + 800.0} 300.0 nil 30 "DASHED" 300.0)
  (insHexTag (list ${PX + 0.0 - 2000.0} ${PY + 26580.0} 0.0) "A3A")

  ;; --- CỤM A4 (Color 6 - Magenta): Cột giữa Trục E/2 và E/3 ---
  (mkRoundRect ${PX + 23750.0 - 800.0} ${PY + 5830.0 - 800.0} ${PX + 23750.0 + 800.0} ${PY + 11830.0 + 800.0} 400.0 nil 6 "DASHED" 300.0)
  (insHexTag (list ${PX + 23750.0 + 2000.0} ${PY + 8830.0} 0.0) "A4")

  ;; --- CỤM A5 (Color 2 - Yellow): Cột biên Trục I tại I/2 và I/7 (trừ I/3) ---
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 5830.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 5830.0 + 800.0} 300.0 nil 2 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 5830.0} 0.0) "A5")
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 32580.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 32580.0 + 800.0} 300.0 nil 2 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 32580.0} 0.0) "A5")

  ;; --- CỤM A5A (Color 140 - Light Blue): Cột cos +0.00 tại Trục I/3 ---
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 11830.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 11830.0 + 800.0} 300.0 nil 140 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 11830.0} 0.0) "A5A")

  ;; --- CỤM A6 (Color 5 - Blue): Cột giữa Trục E/4, E/5, E/7 ---
  (mkRoundRect ${PX + 23750.0 - 900.0} ${PY + 17830.0 - 900.0} ${PX + 23750.0 + 900.0} ${PY + 32580.0 + 900.0} 400.0 nil 5 "DASHED" 300.0)
  (insHexTag (list ${PX + 23750.0 + 2000.0} ${PY + 25205.0} 0.0) "A6")

  ;; --- CỤM A7 (Color 210 - Violet): Cột biên Trục I tại I/6 (trừ I/4) ---
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 26580.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 26580.0 + 800.0} 300.0 nil 210 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 26580.0} 0.0) "A7")

  ;; --- CỤM A7A (Color 10 - Red/Orange): Cột cos +0.00 tại Trục I/4 ---
  (mkRoundRect ${PX + 50000.0 - 800.0} ${PY + 17830.0 - 800.0} ${PX + 50000.0 + 800.0} ${PY + 17830.0 + 800.0} 300.0 nil 10 "DASHED" 300.0)
  (insHexTag (list ${PX + 50000.0 + 2000.0} ${PY + 17830.0} 0.0) "A7A")

  ;; --- Title & Level Block ATAD_LEVEL_TAG (NO CLASH, giữa khoang C-D) ---
  (insLevelTag (list ${PX + 16000.0} ${PY + 15000.0} 0.0) "FFL" "+0.100")
  (mkTxt (list ${PX + 17592.3} ${PY - 5921.0} 0.0) "%%UANCHOR BOLT PLAN" 700.0 "12 Text-title" 1)
  (mkTxt (list ${PX + 21500.0} ${PY - 7421.0} 0.0) "SCALE: 1/150" 450.0 "4_Text data_GB" 7)

  ;; ---------------- STEP 3: SHEET 2 (DETAILS 1/10) - ALIGNED TO PROJECT BASELINE ----------------
  (logMsg "Step 3: Building Sheet 2 (Details 1/10, Project Bottom = ${Y_BOTTOM})...")
  (addViewFrame ${FRAME2_X})
`;

// Detail layout inside Sheet 2 (giữ nguyên):
const detailList = Object.values(typeMap);
detailList.forEach((dt, idx) => {
  const isCol1 = idx < 4;
  const colX = isCol1 ? FRAME2_X + 6000.0 : FRAME2_X + 47000.0;
  const rowIdx = isCol1 ? idx : (idx - 4);
  const rowY = 39000.0 - rowIdx * 14000.0;

  const dX = colX + 4000.0;
  const dY = rowY;
  const sX = colX + 16000.0;
  const sY = rowY;

  const hl = dt.plL / 2.0;
  const hw = dt.plW / 2.0;
  const ch = dt.colH / 2.0;
  const cb = dt.colB / 2.0;
  const tf = 10.0;
  const tw = 6.0;

  const sc = 10.0;
  const sHL = hl * sc;
  const sHW = hw * sc;
  const sCH = ch * sc;
  const sCB = cb * sc;
  const sTF = tf * sc;
  const sTW = tw * sc;

  lsp += `  ;; Detail ${dt.tag} (${dt.name})\n`;

  // --- DETAIL PLAN VIEW ---
  lsp += `  (mkRect ${dX - sHL} ${dY - sHW} ${dX + sHL} ${dY + sHW} "42 Steel plate" 141 nil nil)\n`;
  lsp += `  (mkRect ${dX - sCH} ${dY - sCB} ${dX - sCH + sTF} ${dY + sCB} "33 Flange steel" 3 nil nil)\n`;
  lsp += `  (mkRect ${dX + sCH - sTF} ${dY - sCB} ${dX + sCH} ${dY + sCB} "33 Flange steel" 3 nil nil)\n`;
  lsp += `  (mkRect ${dX - sCH + sTF} ${dY - sTW/2.0} ${dX + sCH - sTF} ${dY + sTW/2.0} "33 Flange steel" 3 nil nil)\n`;

  // Bolts
  const boltY = sHW - 35.0 * sc;
  if (dt.bolts.startsWith('4')) {
    const boltX = 50.0 * sc;
    [-boltX, boltX].forEach(bx => {
      [-boltY, boltY].forEach(by => {
        lsp += `  (mkCircle (list ${dX + bx} ${dY + by} 0.0) ${12.0 * sc} "43 Bolt" 2)\n`;
      });
    });
  } else {
    const boltX = 70.0 * sc;
    [-boltX, 0.0, boltX].forEach(bx => {
      [-boltY, boltY].forEach(by => {
        lsp += `  (mkCircle (list ${dX + bx} ${dY + by} 0.0) ${12.0 * sc} "43 Bolt" 2)\n`;
      });
    });
  }

  // OUT SIDE / IN SIDE text
  lsp += `  (mkTxt (list ${dX - sHL} ${dY + sHW + 300.0} 0.0) "OUT SIDE" 200.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${dX + sHL/3.0} ${dY + sHW + 300.0} 0.0) "IN SIDE" 200.0 "4_Text data_GB" 7)\n`;

  // Specification text: PL and Bolts
  lsp += `  (mkTxt (list ${dX + sHL + 300.0} ${dY - 200.0} 0.0) "${dt.bolts}" 220.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${dX + sHL + 300.0} ${dY - 500.0} 0.0) "${dt.pl}" 220.0 "4_Text data_GB" 7)\n`;

  // Mirror line and tag
  lsp += `  (mkLine (list ${dX - sHL - 1500.0} ${dY} 0.0) (list ${dX + sHL + 1500.0} ${dY} 0.0) "32 Gridline" 251 "DASHED")\n`;
  lsp += `  (mkTxt (list ${dX - 1200.0} ${dY - sHW - 1200.0} 0.0) "%%CA     MIRROR     %%CE" 180.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${dX - 1200.0} ${dY - sHW - 2000.0} 0.0) "%%UDETAIL ${dt.tag}" 350.0 "3_Text title_GB" 10)\n`;

  // --- SECTION VIEW ---
  const secBase = sY;
  const ftgW = sHL + 100.0 * sc;
  const ftgH = 450.0 * sc;
  const sikH = 50.0 * sc;
  const plH = 16.0 * sc;
  const colStubH = 800.0 * sc;
  const boltEmbed = 350.0 * sc;

  // Concrete Footing
  const ftgLeft = sX - ftgW;
  const ftgRight = sX + ftgW;
  const ftgTop = secBase - sikH;
  const ftgBottom = ftgTop - ftgH;
  lsp += `  (mkRect ${ftgLeft} ${ftgBottom} ${ftgRight} ${ftgTop} "27 Concrete structure" 8 nil nil)\n`;

  // Footing Hatch lines
  for (let hy = ftgBottom + 600.0; hy < ftgTop; hy += 600.0) {
    lsp += `  (mkLine (list ${ftgLeft} ${hy} 0.0) (list ${ftgRight} ${hy} 0.0) "42 Steel plate" 253 nil)\n`;
  }

  // Sikagrout layer
  const sikTop = secBase;
  const sikBottom = ftgTop;
  const sikLeft = sX - sHL - 40.0 * sc;
  const sikRight = sX + sHL + 40.0 * sc;
  lsp += `  (mkRect ${sikLeft} ${sikBottom} ${sikRight} ${sikTop} "25_Sikagrout_GB" 252 nil nil)\n`;

  // Baseplate PL
  const plTop = sikTop + plH;
  const plBottom = sikTop;
  lsp += `  (mkRect ${sX - sHL} ${plBottom} ${sX + sHL} ${plTop} "42 Steel plate" 141 nil nil)\n`;

  // Steel Column stub with cut line
  const colTop = plTop + colStubH;
  lsp += `  (mkRect ${sX - sCH} ${plTop} ${sX + sCH} ${colTop} "33 Flange steel" 3 nil nil)\n`;
  lsp += `  (mkLine (list ${sX - sCH - 200.0} ${colTop} 0.0) (list ${sX + sCH + 200.0} ${colTop} 0.0) "33 Flange steel" 3 nil)\n`;

  // Anchor bolts (2 bolts embedded with nut and hook)
  const bOff = sHL - 40.0 * sc;
  [-bOff, bOff].forEach(bx => {
    const bCenter = sX + bx;
    const bTop = plTop + 100.0;
    const bBot = ftgTop - boltEmbed;
    lsp += `  (mkLine (list ${bCenter} ${bTop} 0.0) (list ${bCenter} ${bBot} 0.0) "43 Bolt" 2 nil)\n`;
    lsp += `  (mkRect ${bCenter - 120.0} ${plTop} ${bCenter + 120.0} ${plTop + 200.0} "43 Bolt" 2 nil nil)\n`;
    lsp += `  (mkLine (list ${bCenter} ${bBot} 0.0) (list ${bCenter + 200.0} ${bBot - 150.0} 0.0) "43 Bolt" 2 nil)\n`;
  });

  // Section Annotations & Leaders
  lsp += `  (mkTxt (list ${sX - ftgW - 2500.0} ${secBase + 100.0} 0.0) "FFL +0.100" 200.0 "12 Text-title" 1)\n`;
  lsp += `  (mkTxt (list ${sX + sCH + 400.0} ${colTop - 1000.0} 0.0) "STEEL COLUMN" 200.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${sX + sHL + 400.0} ${plTop} 0.0) "PL-16mm" 200.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${sX - ftgW - 2500.0} ${sikBottom - 250.0} 0.0) "SIKAGROUT 50mm" 180.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${sX - ftgW - 2500.0} ${sikBottom - 500.0} 0.0) "(BY OTHERS)" 180.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${sX - ftgW - 2500.0} ${ftgTop - 1750.0} 0.0) "ANCHOR BOLT" 180.0 "4_Text data_GB" 7)\n`;

  // Section Mirror & Title
  lsp += `  (mkTxt (list ${sX - 1200.0} ${ftgBottom - 1200.0} 0.0) "%%CA     MIRROR     %%CE" 180.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${sX - 1200.0} ${ftgBottom - 2000.0} 0.0) "%%USECTION ${dt.tag}" 350.0 "3_Text title_GB" 10)\n`;
});

// Title for Sheet 2 at Y = -5921
lsp += `
  (mkTxt (list ${FRAME2_X + 35000.0} ${PY - 5921.0} 0.0) "%%UANCHOR BOLT DETAILS" 700.0 "12 Text-title" 1)
  (mkTxt (list ${FRAME2_X + 39000.0} ${PY - 7421.0} 0.0) "SCALE: 1/10" 450.0 "4_Text data_GB" 7)

  (logMsg "=== DEPLOY PROJECT ALIGNED COMPLETED SUCCESSFULLY! ===")
  (if logF (close logF))
  (princ "\\nDEPLOY PROJECT ALIGNED COMPLETED!")
  (princ)
)

(c:DEPLOY_PROJECT_ALIGNED)
`;

fs.writeFileSync(SCRATCH + "/deploy_project_aligned.lsp", lsp);
console.log("Successfully generated deploy_project_aligned.lsp with HexTag Scale 150! Size: " + lsp.length);
