import fs from "node:fs";

const SCRATCH = "C:/Users/OS/.gemini/antigravity/brain/303f920f-b9ed-4f10-846f-24fd474aca76/scratch";

// Tọa độ chuẩn căn đáy dự án
const Y_BOTTOM = -12607.6;
const FRAME_INSERT_Y = -8519.55; // Đảm bảo đáy Bounding Box đúng bằng Y_BOTTOM
const FRAME_WIDTH = 5817.0;
const FRAME_GAP = 1500.0;

// 3 View Frames X coordinates
const V1_X = 444000.0;
const V2_X = V1_X + FRAME_WIDTH + FRAME_GAP; // 451317.0
const V3_X = V2_X + FRAME_WIDTH + FRAME_GAP; // 458634.0

// Định nghĩa 10 chi tiết chuẩn xác - HƯỚNG XOAY KHỚP 100% VỚI MẶT BẰNG ĐỊNH VỊ
// Trên mặt bằng định vị: A2 có rot = 0 độ, các chi tiết còn lại (A1, A3, A3A, A4, A5, A5A, A6, A7, A7A) có rot = 90 độ!
const details = [
  // View 1 (4 chi tiết: A1, A2, A2A, A3)
  { view: 1, pos: "TL", tag: "A1",  rotDeg: 90, isTapered: false, secStr: "250.5-165.8",     blockName: "B01_250x165_PL286x185_4M20", colH: 250, colB: 165, plL: 286, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.100", yBubbles: ["1", "&", "8"], xBubbles: ["A"] },
  { view: 1, pos: "TR", tag: "A2",  rotDeg: 0,  isTapered: false, secStr: "250.5-150.6",     blockName: "B01_250x150_PL282x185_4M20", colH: 250, colB: 150, plL: 282, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.100", yBubbles: ["1", "&", "8"], xBubbles: ["B", "TO", "H"] },
  { view: 1, pos: "BL", tag: "A2A", rotDeg: 90, isTapered: false, secStr: "250.5-150.6",     blockName: "B01_250x150_PL282x185_4M20", colH: 250, colB: 150, plL: 282, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.100", yBubbles: ["1", "&", "8"], xBubbles: ["I"] },
  { view: 1, pos: "BR", tag: "A3",  rotDeg: 90, isTapered: true,  secStr: "(300-600).5-150.8", blockName: "B01_300x150_PL336x185_4M20", colH: 300, colB: 150, plL: 336, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.100", yBubbles: ["2", "TO", "4", "&", "7"], xBubbles: ["A"] },

  // View 2 (4 chi tiết: A3A, A4, A5, A5A)
  { view: 2, pos: "TL", tag: "A3A", rotDeg: 90, isTapered: true,  secStr: "(300-600).5-150.8", blockName: "B01_300x150_PL336x185_4M20", colH: 300, colB: 150, plL: 336, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.000", yBubbles: ["6"], xBubbles: ["A"] },
  { view: 2, pos: "TR", tag: "A4",  rotDeg: 90, isTapered: false, secStr: "400.5-185.8",     blockName: "B01_400x185_PL436x185_6M20", colH: 400, colB: 185, plL: 436, plW: 185, plT: 16, bolts: "6AB M20", nBolts: 6, ffl: "+0.100", yBubbles: ["2", "&", "3"], xBubbles: ["E"] },
  { view: 2, pos: "BL", tag: "A5",  rotDeg: 90, isTapered: true,  secStr: "(300-480-600).5.5-165.8.10", blockName: "B01_300x165_PL336x185_4M20", colH: 300, colB: 165, plL: 336, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.100", yBubbles: ["2", "&", "7"], xBubbles: ["I"] },
  { view: 2, pos: "BR", tag: "A5A", rotDeg: 90, isTapered: true,  secStr: "(300-480-600).5.5-165.8.10", blockName: "B01_300x165_PL336x185_4M20", colH: 300, colB: 165, plL: 336, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.000", yBubbles: ["3"], xBubbles: ["I"] },

  // View 3 (3 chi tiết: A6, A7, A7A)
  { view: 3, pos: "TL", tag: "A6",  rotDeg: 90, isTapered: false, secStr: "400.5-250.8",     blockName: "B01_400x250_PL436x250_6M20", colH: 400, colB: 250, plL: 436, plW: 250, plT: 16, bolts: "6AB M20", nBolts: 6, ffl: "+0.100", yBubbles: ["4", ",", "5", "&", "7"], xBubbles: ["E"] },
  { view: 3, pos: "TR", tag: "A7",  rotDeg: 90, isTapered: true,  secStr: "(300-480-600).5.5-185.8.10", blockName: "B01_300x185_PL336x185_4M20", colH: 300, colB: 185, plL: 336, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.100", yBubbles: ["6"], xBubbles: ["I"] },
  { view: 3, pos: "BL", tag: "A7A", rotDeg: 90, isTapered: true,  secStr: "(300-480-600).5.5-185.8.10", blockName: "B01_300x185_PL336x185_4M20", colH: 300, colB: 185, plL: 336, plW: 185, plT: 16, bolts: "4AB M20", nBolts: 4, ffl: "+0.000", yBubbles: ["4"], xBubbles: ["I"] }
];

// Hàm tính offset tọa độ các ô trong từng khung
function getSlotOffsets(pos) {
  if (pos === "TL") {
    return {
      planX: 867.0,  planY: 3127.0,
      secX: 2176.0,  secY: 3303.8,
      planTitleX: 785.0,  planTitleY: 2542.2,
      secTitleX: 2034.0, secTitleY: 2542.8
    };
  } else if (pos === "TR") {
    return {
      planX: 3830.0, planY: 3127.0,
      secX: 5138.0,  secY: 3303.8,
      planTitleX: 3748.0, planTitleY: 2542.2,
      secTitleX: 4997.0,  secTitleY: 2542.8
    };
  } else if (pos === "BL") {
    return {
      planX: 742.0,  planY: 977.9,
      secX: 1853.0,  secY: 1154.7,
      planTitleX: 660.0,  planTitleY: 393.0,
      secTitleX: 1712.0, secTitleY: 393.7
    };
  } else if (pos === "BR") {
    return {
      planX: 3210.0, planY: 977.9,
      secX: 4348.0,  secY: 1154.7,
      planTitleX: 3128.0, planTitleY: 393.0,
      secTitleX: 4207.0,  secTitleY: 393.7
    };
  }
}

let lsp = `;; ================================================================
;; DEPLOY 3 VIEWS CHI TIET BU LONG NEO 1/10
;; HUONG XOAY CHUAN KHOP 100% VOI MAT BANG DINH VI
;; ================================================================

(vl-load-com)

(defun c:DeployViews110 ( / acadObj doc mSpace ss i ent ed ins srcFrame fRef curIns)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (setq mSpace (vla-get-ModelSpace doc))

  (defun logMsg (msg)
    (princ (strcat "\\n[VIEWS 1/10] " msg "\\n"))
  )

  (defun safeSetLayer (obj lyr)
    (if (tblsearch "LAYER" lyr)
      (vl-catch-all-apply 'vla-put-Layer (list obj lyr))
      (vl-catch-all-apply 'vla-put-Layer (list obj "0"))
    )
  )

  (defun mkLine (p1 p2 lyr col lt / lObj)
    (setq lObj (vla-AddLine mSpace (vlax-3d-point p1) (vlax-3d-point p2)))
    (safeSetLayer lObj lyr)
    (if col (vla-put-Color lObj col))
    (if lt
      (if (tblsearch "LTYPE" lt)
        (vla-put-Linetype lObj lt)
      )
    )
    lObj
  )

  (defun mkRect (x1 y1 x2 y2 lyr col lt ltScale / pts sa plObj)
    (setq pts (list x1 y1 x2 y1 x2 y2 x1 y2))
    (setq sa (vlax-make-safearray vlax-vbDouble '(0 . 7)))
    (vlax-safearray-fill sa pts)
    (setq plObj (vla-AddLightWeightPolyline mSpace sa))
    (vla-put-Closed plObj :vlax-true)
    (safeSetLayer plObj lyr)
    (if col (vla-put-Color plObj col))
    (if lt
      (if (tblsearch "LTYPE" lt)
        (vla-put-Linetype plObj lt)
      )
    )
    (if ltScale (vla-put-LinetypeScale plObj ltScale))
    plObj
  )

  (defun mkQuad (x1 y1 x2 y2 x3 y3 x4 y4 lyr / pts sa plObj)
    (setq pts (list x1 y1 x2 y2 x3 y3 x4 y4))
    (setq sa (vlax-make-safearray vlax-vbDouble '(0 . 7)))
    (vlax-safearray-fill sa pts)
    (setq plObj (vla-AddLightWeightPolyline mSpace sa))
    (vla-put-Closed plObj :vlax-true)
    (safeSetLayer plObj lyr)
    plObj
  )

  (defun mkBreakLine10 (xLeft xMid xRight yTop / pts sa plObj)
    (setq pts (list
      xLeft yTop
      (- xMid 13.3) yTop
      (- xMid 6.65) (- yTop 22.17)
      (+ xMid 6.65) (+ yTop 22.17)
      (+ xMid 13.3) yTop
      xRight yTop
    ))
    (setq sa (vlax-make-safearray vlax-vbDouble '(0 . 11)))
    (vlax-safearray-fill sa pts)
    (setq plObj (vla-AddLightWeightPolyline mSpace sa))
    (vla-put-Closed plObj :vlax-false)
    (safeSetLayer plObj "21 Dim")
    plObj
  )

  (defun mkSikaHatch (rectObj / hObj loopArr)
    (setq hObj (vla-AddHatch mSpace 0 "NET" :vlax-true))
    (safeSetLayer hObj "25_Sikagrout_GB")
    (vla-put-PatternAngle hObj (/ pi 4.0))
    (vla-put-PatternScale hObj 5.0)
    (setq loopArr (vlax-make-safearray vlax-vbObject '(0 . 0)))
    (vlax-safearray-put-element loopArr 0 rectObj)
    (vla-AppendOuterLoop hObj loopArr)
    (vla-Evaluate hObj)
    hObj
  )

  (defun mkConcHatch (rectObj / hObj loopArr)
    (setq hObj (vla-AddHatch mSpace 0 "AR-CONC" :vlax-true))
    (safeSetLayer hObj "23_Rc_GB")
    (vla-put-PatternAngle hObj 0.0)
    (vla-put-PatternScale hObj 1.0)
    (setq loopArr (vlax-make-safearray vlax-vbObject '(0 . 0)))
    (vlax-safearray-put-element loopArr 0 rectObj)
    (vla-AppendOuterLoop hObj loopArr)
    (vl-catch-all-apply 'vla-Evaluate (list hObj))
    hObj
  )

  (defun mkPLine2Pts (p1 p2 lyr col lt / pts sa plObj)
    (setq pts (list (car p1) (cadr p1) (car p2) (cadr p2)))
    (setq sa (vlax-make-safearray vlax-vbDouble '(0 . 3)))
    (vlax-safearray-fill sa pts)
    (setq plObj (vla-AddLightWeightPolyline mSpace sa))
    (safeSetLayer plObj lyr)
    (if col (vla-put-Color plObj col))
    (if lt (if (tblsearch "LTYPE" lt) (vla-put-Linetype plObj lt)))
    plObj
  )

  (defun mkTxt (pt str h lyr col / tObj)
    (setq tObj (vla-AddText mSpace str (vlax-3d-point pt) h))
    (safeSetLayer tObj lyr)
    (if col (vla-put-Color tObj col))
    tObj
  )

  (defun insGridTag10 (pt tag / blkRef atts)
    (if (tblsearch "BLOCK" "GB_GRIDLINE_TAG_1")
      (progn
        (setq blkRef (vla-InsertBlock mSpace (vlax-3d-point pt) "GB_GRIDLINE_TAG_1" 10.0 10.0 10.0 0.0))
        (safeSetLayer blkRef "0")
        (if (and (= (vla-get-HasAttributes blkRef) :vlax-true)
                 (setq atts (vlax-invoke blkRef 'GetAttributes)))
          (vla-put-TextString (car atts) tag)
        )
        blkRef
      )
    )
  )

  (defun addHDim10 (x1 y1 x2 y2 dimY txtOvr / p1 p2 pLine dObj)
    (setq p1 (vlax-3d-point (list x1 y1 0.0)))
    (setq p2 (vlax-3d-point (list x2 y2 0.0)))
    (setq pLine (vlax-3d-point (list (/ (+ x1 x2) 2.0) dimY 0.0)))
    (setq dObj (vla-AddDimRotated mSpace p1 p2 pLine 0.0))
    (safeSetLayer dObj "8")
    (if (tblsearch "DIMSTYLE" "GB 1-10")
      (vla-put-StyleName dObj "GB 1-10")
    )
    (if txtOvr
      (vla-put-TextOverride dObj txtOvr)
    )
    dObj
  )

  (defun addVDim10 (x1 y1 x2 y2 dimX txtOvr / p1 p2 pLine dObj)
    (setq p1 (vlax-3d-point (list x1 y1 0.0)))
    (setq p2 (vlax-3d-point (list x2 y2 0.0)))
    (setq pLine (vlax-3d-point (list dimX (/ (+ y1 y2) 2.0) 0.0)))
    (setq dObj (vla-AddDimRotated mSpace p1 p2 pLine (/ pi 2.0)))
    (safeSetLayer dObj "8")
    (if (tblsearch "DIMSTYLE" "GB 1-10")
      (vla-put-StyleName dObj "GB 1-10")
    )
    (if txtOvr
      (vla-put-TextOverride dObj txtOvr)
    )
    dObj
  )

  (defun mkLeader10 (p1 p2 p3 / e obj x1 y1)
    (setq e
      (entmakex
        (list
          '(0 . "LEADER")
          '(100 . "AcDbEntity")
          '(8 . "6_Dim_GB")
          '(100 . "AcDbLeader")
          '(3 . "GB 1-10")
          '(71 . 1)
          '(72 . 0)
          '(73 . 3)
          '(74 . 1)
          '(75 . 0)
          '(40 . 0.0)
          '(41 . 0.0)
          '(76 . 3)
          (cons 10 p1)
          (cons 10 p2)
          (cons 10 p3)
        )
      )
    )
    (if e
      (progn
        (setq obj (vlax-ename->vla-object e))
        (if (tblsearch "DIMSTYLE" "GB 1-10")
          (vla-put-StyleName obj "GB 1-10")
        )
        (vla-Update obj)
      )
    )
    ;; Ve mui ten _Open30 (17.5mm, goc 30 do) trung khop 100% voi DimStyle GB 1-10
    (setq x1 (car p1) y1 (cadr p1))
    (mkLine p1 (list (- x1 4.53) (+ y1 16.90) 0.0) "6_Dim_GB" 251 nil)
    (mkLine p1 (list (+ x1 4.53) (+ y1 16.90) 0.0) "6_Dim_GB" 251 nil)
    e
  )

  (defun mkSecLeader (p1 p2 p3 / e obj)
    (setq e
      (entmakex
        (list
          '(0 . "LEADER")
          '(100 . "AcDbEntity")
          '(8 . "6_Dim_GB")
          '(100 . "AcDbLeader")
          '(3 . "GB 1-10")
          '(71 . 1)
          '(72 . 0)
          '(73 . 3)
          '(74 . 1)
          '(75 . 0)
          '(40 . 0.0)
          '(41 . 0.0)
          '(76 . 3)
          (cons 10 p1)
          (cons 10 p2)
          (cons 10 p3)
          '(211 -1.0 0.0 0.0)
          '(210 0.0 0.0 1.0)
        )
      )
    )
    (if e
      (progn
        (setq obj (vlax-ename->vla-object e))
        (if (tblsearch "DIMSTYLE" "GB 1-10")
          (vla-put-StyleName obj "GB 1-10")
        )
        (vla-Update obj)
      )
    )
    e
  )

  (defun insLevelTag10 (pt levelStr / bRef atts a tag)
    (if (tblsearch "BLOCK" "ATAD_LEVEL_TAG")
      (progn
        (setq bRef (vla-InsertBlock mSpace (vlax-3d-point pt) "ATAD_LEVEL_TAG" 10.0 10.0 10.0 0.0))
        (safeSetLayer bRef "31 Drawing")
        (if (and (= (vla-get-HasAttributes bRef) :vlax-true)
                 (setq atts (vlax-invoke bRef 'GetAttributes)))
          (foreach a atts
            (setq tag (strcase (vla-get-TagString a)))
            (cond
              ((= tag "LEVEL") (vla-put-TextString a levelStr))
              ((= tag "NOTE")  (vla-put-TextString a "FFL"))
            )
          )
        )
        bRef
      )
    )
  )



  ;; Tim block mat cat mau (handle 2CB348) de copy va cap nhat bien SYMBOL1
  (setq srcSecBlk (if (handent "2CB348") (vlax-ename->vla-object (handent "2CB348")) nil))

  ;; Tim block bu long neo mat dung ABM20 mau (handle 2CB358 - da chinh khe ban ma 16mm)
  (setq srcBoltBlk (if (handent "2CB358") (vlax-ename->vla-object (handent "2CB358")) nil))

  (defun insBoltSec10 (pt / bRef curIns)
    (if srcBoltBlk
      (progn
        (setq bRef (vla-Copy srcBoltBlk))
        (setq curIns (vla-get-InsertionPoint bRef))
        (vla-Move bRef curIns (vlax-3d-point pt))
        bRef
      )
      (vla-InsertBlock mSpace (vlax-3d-point pt) "ABM20" 1.0 1.0 1.0 0.0)
    )
  )

  (defun insSecCut10 (pt rotRad tag / bRef curIns atts)
    (if srcSecBlk
      (progn
        (setq bRef (vla-Copy srcSecBlk))
        (setq curIns (vla-get-InsertionPoint bRef))
        (vla-Move bRef curIns (vlax-3d-point pt))
        (if (/= rotRad 0.0)
          (vla-Rotate bRef (vlax-3d-point pt) rotRad)
        )
        (if (and (= (vla-get-HasAttributes bRef) :vlax-true)
                 (setq atts (vlax-invoke bRef 'GetAttributes)))
          (foreach att atts
            (if (= (strcase (vla-get-TagString att)) "SYMBOL1")
              (progn
                (vla-put-TextString att tag)
                (vla-put-Rotation att 0.0)
                (vla-put-TextAlignmentPoint att (vlax-3d-point pt))
              )
            )
          )
        )
        bRef
      )
    )
  )

  (defun add110Frame (insX / bRef atts a)
    (if (tblsearch "BLOCK" "A$Ce291ec07")
      (progn
        (setq bRef (vla-InsertBlock mSpace (vlax-3d-point (list insX ${FRAME_INSERT_Y} 0.0)) "A$Ce291ec07" 10.0 10.0 10.0 0.0))
        (safeSetLayer bRef "1.NVB-BLACK LINE")
        (if (and (= (vla-get-HasAttributes bRef) :vlax-true)
                 (setq atts (vlax-invoke bRef 'GetAttributes)))
          (foreach a atts
            (if (= (strcase (vla-get-TagString a)) "SCC")
              (vla-put-TextString a "1/10")
            )
          )
        )
        bRef
      )
    )
  )

  (logMsg "Creating 3 View Frames...")
  (add110Frame ${V1_X})
  (add110Frame ${V2_X})
  (add110Frame ${V3_X})
`;

// Thêm các đường phân cách nét đứt (HIDDEN) cho từng frame
[
  { vX: V1_X, isFull: true },
  { vX: V2_X, isFull: true },
  { vX: V3_X, isFull: true } // View 3 có đường dọc dưới chia ô BL cho A2A, chừa ô BR cho title block!
].forEach((vf, vIdx) => {
  const fX0 = vf.vX;
  const fY0 = Y_BOTTOM;
  const fX1 = fX0 + FRAME_WIDTH;
  const fY1 = FRAME_INSERT_Y;
  const fYmid = fY0 + 2044.0;
  const fXmid = fX0 + 2908.5;

  lsp += `\n  ;; Dividing dashed lines for View ${vIdx + 1}\n`;
  lsp += `  (mkPLine2Pts (list ${fX0} ${fYmid} 0.0) (list ${fX1} ${fYmid} 0.0) "HIDDEN" nil nil)\n`;
  lsp += `  (mkPLine2Pts (list ${fXmid} ${fYmid} 0.0) (list ${fXmid} ${fY1} 0.0) "HIDDEN" nil nil)\n`;

  if (vf.isFull) {
    const fXmidBottom = fX0 + 2398.0;
    lsp += `  (mkPLine2Pts (list ${fXmidBottom} ${fY0} 0.0) (list ${fXmidBottom} ${fYmid} 0.0) "HIDDEN" nil nil)\n`;
  }
});

// Triển khai từng chi tiết trong 10 chi tiết
details.forEach(dt => {
  const frameX = dt.view === 1 ? V1_X : (dt.view === 2 ? V2_X : V3_X);
  const frameY = Y_BOTTOM;
  const slot = getSlotOffsets(dt.pos);

  const px = frameX + slot.planX;
  const py = frameY + slot.planY;
  const sx = frameX + slot.secX;
  const sy = frameY + slot.secY;

  const isRot90 = dt.rotDeg === 90;
  const rotLisp = isRot90 ? "(/ pi 2.0)" : "0.0";
  // Kích thước phủ bì trên mặt bằng theo đúng hướng xoay
  const sizeX = isRot90 ? dt.plL : dt.plW;
  const sizeY = isRot90 ? dt.plW : dt.plL;
  const hX = sizeX / 2.0;
  const hY = sizeY / 2.0;

  // Tọa độ tim bu lông ngoài cùng so với tâm (px, py) sau khi xoay
  const boltLocalX = 50.0;
  const boltLocalY = dt.nBolts === 6 ? 100.0 : 50.0;
  const boltX = isRot90 ? boltLocalY : boltLocalX;
  const boltY = isRot90 ? boltLocalX : boltLocalY;

  // Trong Section view: chiều rộng tiết diện hiển thị là colH và plL
  const secHl = dt.plL / 2.0;
  const secCh = dt.colH / 2.0;

  lsp += `\n  ;; ---------------- CHI TIET ${dt.tag} (View ${dt.view} - ${dt.pos} - Rot: ${dt.rotDeg} deg) ----------------\n`;

  // === 1. PLAN VIEW (CHEN TRUC TIEP BLOCK CUA COT TU MAT BANG DINH VI VOI HUONG XOAY CHUAN) ===
  lsp += `  (vla-InsertBlock mSpace (vlax-3d-point (list ${px} ${py} 0.0)) "${dt.blockName}" 1.0 1.0 1.0 ${rotLisp})\n`;

  // Đường tim trục (Centerlines) mở rộng ra ngoài vùng Dim để không cắt chữ Dim
  lsp += `  (mkLine (list ${px - hX - 150.0} ${py} 0.0) (list ${px + hX + 120.0} ${py} 0.0) "32 Gridline" 251 "DASHED")\n`;
  lsp += `  (mkLine (list ${px} ${py - hY - 135.0} 0.0) (list ${px} ${py + hY + 120.0} 0.0) "32 Gridline" 251 "DASHED")\n`;
  // Tag bong bóng trục ngang bên trái (Scale 10.0, bán kính 42.5mm)
  const gxLeft = px - hX - 192.5;
  for (let i = 0; i < dt.yBubbles.length; i++) {
    const item = dt.yBubbles[i];
    if (i % 2 === 0) {
      const bIdx = i / 2;
      lsp += `  (insGridTag10 (list ${gxLeft} ${py + bIdx * 136.7} 0.0) "${item}")\n`;
    } else {
      const bIdx = (i - 1) / 2;
      const connX = item === "TO" ? gxLeft - 15.0 : gxLeft - 52.0;
      const connY = py + bIdx * 136.7 + 58.0;
      lsp += `  (mkTxt (list ${connX} ${connY} 0.0) "${item}" 22.0 "4_Text data_GB" 7)\n`;
    }
  }

  // Tag bong bóng trục dọc bên dưới Plan (Scale 10.0, bán kính 42.5mm)
  const gyBottom = py - hY - 177.5;
  if (dt.xBubbles.length === 1) {
    lsp += `  (insGridTag10 (list ${px} ${gyBottom} 0.0) "${dt.xBubbles[0]}")\n`;
  } else if (dt.xBubbles.length === 3) {
    lsp += `  (insGridTag10 (list ${px} ${gyBottom} 0.0) "${dt.xBubbles[0]}")\n`;
    lsp += `  (mkTxt (list ${px + 75.0} ${gyBottom - 11.0} 0.0) "${dt.xBubbles[1]}" 22.0 "4_Text data_GB" 7)\n`;
    lsp += `  (insGridTag10 (list ${px + 175.0} ${gyBottom} 0.0) "${dt.xBubbles[2]}")\n`;
  }

  // --- BỔ SUNG DIM BÊN TRÁI (VERTICAL DIMS) ---
  const dimX1 = px - hX - 50.0;
  const dimX2 = px - hX - 95.0;
  lsp += `  (addVDim10 ${px - hX} ${py - hY} ${px - boltX} ${py - boltY} ${dimX1} "=")\n`;
  lsp += `  (addVDim10 ${px - boltX} ${py - boltY} ${px - hX} ${py} ${dimX1} nil)\n`;
  lsp += `  (addVDim10 ${px - hX} ${py} ${px - boltX} ${py + boltY} ${dimX1} nil)\n`;
  lsp += `  (addVDim10 ${px - boltX} ${py + boltY} ${px - hX} ${py + hY} ${dimX1} "=")\n`;
  lsp += `  (addVDim10 ${px - hX} ${py - hY} ${px - hX} ${py + hY} ${dimX2} nil)\n`;

  // --- BỔ SUNG DIM BÊN DƯỚI (HORIZONTAL DIMS) ---
  const dimY1 = py - hY - 60.0;
  const dimY2 = py - hY - 105.0;
  lsp += `  (addHDim10 ${px - hX} ${py - hY} ${px - boltX} ${py - boltY} ${dimY1} "=")\n`;
  lsp += `  (addHDim10 ${px - boltX} ${py - boltY} ${px} ${py - hY} ${dimY1} nil)\n`;
  lsp += `  (addHDim10 ${px} ${py - hY} ${px + boltX} ${py - boltY} ${dimY1} nil)\n`;
  lsp += `  (addHDim10 ${px + boltX} ${py - boltY} ${px + hX} ${py - hY} ${dimY1} "=")\n`;
  lsp += `  (addHDim10 ${px - hX} ${py - hY} ${px + hX} ${py - hY} ${dimY2} nil)\n`;

  // --- LEADER GHI CHÚ BU LÔNG & BẢN MÃ (AB 4M20 / AB 6M20 & PL-16mm) ---
  const ldrX1 = px + boltX;
  const ldrY1 = py + boltY + 10.0;
  const ldrY2 = py + hY + 115.0;
  const ldrX2 = ldrX1 + 165.0;
  lsp += `  (mkLeader10 (list ${ldrX1} ${ldrY1} 0.0) (list ${ldrX1} ${ldrY2} 0.0) (list ${ldrX2} ${ldrY2} 0.0))\n`;
  lsp += `  (mkTxt (list ${ldrX1 + 25.0} ${ldrY2 + 8.0} 0.0) "AB ${dt.nBolts}M20" 22.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${ldrX1 + 25.0} ${ldrY2 - 28.0} 0.0) "PL-${dt.plT}mm" 22.0 "4_Text data_GB" 7)\n`;

  // --- BLOCK MẶT CẮT SONG SONG VỚI BỤNG CỘT (SYMBOL1 = TÊN CHI TIẾT) ---
  if (isRot90) {
    // Bụng cột nằm ngang -> đặt block mặt cắt nằm ngang ở phía dưới, mũi tên hướng lên
    lsp += `  (insSecCut10 (list ${px - 491.7} ${py - hY - 220.0} 0.0) 0.0 "${dt.tag}")\n`;
  } else {
    // Bụng cột nằm dọc (A2) -> xoay dọc 90 độ đặt ở bên phải, mũi tên hướng sang trái vào bụng cột
    lsp += `  (insSecCut10 (list ${px + hX + 205.0} ${py - 491.7} 0.0) (/ pi 2.0) "${dt.tag}")\n`;
  }

  // Tiêu đề Plan
  const pTitleX = frameX + slot.planTitleX;
  const pTitleY = frameY + slot.planTitleY;
  lsp += `  (mkTxt (list ${pTitleX} ${pTitleY} 0.0) "%%UDETAIL ${dt.tag}" 35.0 "3_Text title_GB" 1)\n`;

  // === 2. SECTION VIEW ===
  const sikH = 50.0;
  const plT = dt.plT;
  const colStubH = 560.0;
  const ftgW = 500.0;
  const ftgH = 340.0;
  const ftgHalfW = ftgW / 2.0;

  const ftgTop = sy;
  const ftgBottom = ftgTop - ftgH;
  const ftgLeft = sx - ftgHalfW;
  const ftgRight = sx + ftgHalfW;

  // Bê tông móng (Pedestal) - Hatch Concrete (AR-CONC, scale 1.0, layer 23_Rc_GB)
  lsp += `  (mkConcHatch (mkRect ${ftgLeft} ${ftgBottom} ${ftgRight} ${ftgTop} "23_Rc_GB" 8 nil nil))\n`;

  // Lớp vữa SikaGrout dày 50mm, chiều rộng bằng đúng kích thước bản mã, Hatch NET góc 45 độ
  const groutLeft = sx - secHl;
  const groutRight = sx + secHl;
  const groutTop = ftgTop + sikH;
  lsp += `  (mkSikaHatch (mkRect ${groutLeft} ${ftgTop} ${groutRight} ${groutTop} "31 Drawing" nil nil nil))\n`;

  // Bản mã chân cột (Base Plate - Layer "42 Steel plate", màu Cyan ByLayer, dày 16mm)
  const plateTop = groutTop + plT;
  lsp += `  (mkRect ${sx - secHl} ${groutTop} ${sx + secHl} ${plateTop} "42 Steel plate" nil nil nil)\n`;

  // Thân cột thép theo đúng loại tiết diện: Cột thẳng (Hình 1) hoặc Cột vát (Hình 2) + Ký hiệu nét cắt đỉnh cột
  // Công thức chuẩn: plL = W + 2*tf + 20 => xIn = W/2, xOut = W/2 + tf = plL/2 - 10
  const colTop = plateTop + colStubH;
  const xIn = secCh;
  const xOut = secHl - 10.0;
  const taperShift = dt.isTapered ? 50.0 : 0.0;
  const xTopLeftOut = sx - xOut - taperShift;
  const xTopLeftIn  = sx - xIn - taperShift;

  lsp += `  (mkQuad ${sx - xOut} ${plateTop} ${sx + xOut} ${plateTop} ${sx + xOut} ${colTop} ${xTopLeftOut} ${colTop} "31 Drawing")\n`;
  lsp += `  (mkLine (list ${sx - xIn} ${plateTop} 0.0) (list ${xTopLeftIn} ${colTop} 0.0) "33 Flange steel" nil nil)\n`;
  lsp += `  (mkLine (list ${sx + xIn} ${plateTop} 0.0) (list ${sx + xIn} ${colTop} 0.0) "33 Flange steel" nil nil)\n`;
  lsp += `  (mkBreakLine10 ${xTopLeftOut - 26.6} ${sx} ${sx + xOut + 26.6} ${colTop})\n`;

  // Bu lông neo mặt đứng dùng block chuẩn ABM20 (khớp khe bản mã 16mm)
  const boltXs = dt.nBolts === 6 ? [-100.0, 0.0, 100.0] : [-50.0, 50.0];
  boltXs.forEach(bx => {
    lsp += `  (insBoltSec10 (list ${sx + bx} ${groutTop - 3.0} 0.0))\n`;
  });

  // Đường tim trục móng & Bong bóng trục dọc đồng bộ với Plan
  const sgyBottom = ftgBottom - 142.5;
  lsp += `  (mkLine (list ${sx} ${ftgBottom - 100.0} 0.0) (list ${sx} ${plateTop} 0.0) "32 Gridline" 251 "DASHED")\n`;
  if (dt.xBubbles.length === 1) {
    lsp += `  (insGridTag10 (list ${sx} ${sgyBottom} 0.0) "${dt.xBubbles[0]}")\n`;
  } else if (dt.xBubbles.length === 3) {
    lsp += `  (insGridTag10 (list ${sx} ${sgyBottom} 0.0) "${dt.xBubbles[0]}")\n`;
    lsp += `  (mkTxt (list ${sx + 75.0} ${sgyBottom - 11.0} 0.0) "${dt.xBubbles[1]}" 22.0 "4_Text data_GB" 7)\n`;
    lsp += `  (insGridTag10 (list ${sx + 175.0} ${sgyBottom} 0.0) "${dt.xBubbles[2]}")\n`;
  }

  // === LEADERS & GHI CHÚ KỸ THUẬT SECTION (THEO HÌNH MẪU CHUẨN) ===
  const textBaseX = sx - 620.0;
  const doglegX = sx - 405.0;

  // 1. STEEL COLUMN:
  const leaderColY = plateTop + 330.0;
  const taperAtLeader = dt.isTapered ? (50.0 * 330.0 / colStubH) : 0.0;
  const xColLeft = sx - (xOut + taperAtLeader);

  lsp += `  ;; --- STEEL COLUMN LEADER ---\n`;
  lsp += `  (mkTxt (list ${textBaseX} ${leaderColY + 5.5} 0.0) "STEEL COLUMN" 22.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkSecLeader (list ${xColLeft} ${leaderColY} 0.0) (list ${doglegX} ${leaderColY} 0.0) (list ${textBaseX} ${leaderColY} 0.0))\n`;

  // 2. KÝ HIỆU CAO ĐỘ FFL (Dùng block ATAD_LEVEL_TAG, Scale 10.0, NOTE="FFL", LEVEL=dt.ffl):
  lsp += `  ;; --- FFL ELEVATION MARK (BLOCK ATAD_LEVEL_TAG) ---\n`;
  lsp += `  (insLevelTag10 (list ${sx - 440.0} ${ftgTop} 0.0) "${dt.ffl}")\n`;
  lsp += `  (mkPLine2Pts (list ${sx - 440.0} ${ftgTop} 0.0) (list ${sx - secHl} ${ftgTop} 0.0) "32 Gridline" nil nil)\n`;

  // 3. SIKAGROUT / (BY OTHERS):
  const sikaArrowX = sx - secHl + 40.0;
  const sikaArrowY = ftgTop + 25.0;
  const sikaLandingY = ftgTop - 86.8;
  lsp += `  ;; --- SIKAGROUT / (BY OTHERS) LEADER ---\n`;
  lsp += `  (mkTxt (list ${textBaseX} ${ftgTop - 80.0} 0.0) "SIKAGROUT" 22.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkTxt (list ${textBaseX} ${ftgTop - 119.3} 0.0) "(BY OTHERS)" 22.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkSecLeader (list ${sikaArrowX} ${sikaArrowY} 0.0) (list ${doglegX} ${sikaLandingY} 0.0) (list ${textBaseX} ${sikaLandingY} 0.0))\n`;

  // 4. ANCHOR BOLT (Trỏ vào bu lông gần nhất bên trái):
  const nearBoltX = dt.nBolts === 6 ? (sx - 100.0) : (sx - 50.0);
  const boltLandingY = ftgTop - 180.0;
  lsp += `  ;; --- ANCHOR BOLT LEADER ---\n`;
  lsp += `  (mkTxt (list ${textBaseX} ${boltLandingY + 5.5} 0.0) "ANCHOR BOLT" 22.0 "4_Text data_GB" 7)\n`;
  lsp += `  (mkSecLeader (list ${nearBoltX} ${boltLandingY} 0.0) (list ${doglegX} ${boltLandingY} 0.0) (list ${textBaseX} ${boltLandingY} 0.0))\n`;

  // Tiêu đề Section
  const sTitleX = frameX + slot.secTitleX;
  const sTitleY = frameY + slot.secTitleY;
  lsp += `  (mkTxt (list ${sTitleX} ${sTitleY} 0.0) "%%USECTION ${dt.tag}" 35.0 "3_Text title_GB" 1)\n`;
});

lsp += `
  (logMsg "Completed deploying 3 Views (10 Details 1/10) with exact column blocks & rotations!")
  (princ "\\n*** 3 VIEWS DEPLOYED SUCCESSFULLY ***\\n")
  (princ)
)

(c:DeployViews110)
`;

fs.writeFileSync(SCRATCH + "/deploy_views_1_10.lsp", lsp);
console.log("Successfully generated deploy_views_1_10.lsp with column blocks & exact rotations!");
