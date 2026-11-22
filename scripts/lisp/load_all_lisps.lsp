;;; ==========================================================================
;;; MASTER LOADER: NẠP TOÀN BỘ 9 MODULE AUTOLISP CHO DỰ ÁN LA635
;;; Lệnh gọi nạp lại bất cứ lúc nào: LA635_LOAD
;;; ==========================================================================
(vl-load-com)

(defun c:LA635_LOAD ( / baseDir modules mod count fList fPath fullPath )
  (setq baseDir (vl-filename-directory (findfile "load_all_lisps.lsp")))
  (if (not baseDir)
    (setq baseDir (getvar "DWGPREFIX"))
  )
  
  (setq modules '(
    "cad_cleanup"
    "layers_views_print"
    "blocks"
    "architecture"
    "structure"
    "annotation"
    "text_tables"
    "b01_standards"
    "b02_implementation"
  ))
  
  (setq count 0)
  (princ "\n--- DANG NAP HE THONG AUTOLISP LA635 ---")
  
  (foreach mod modules
    (setq modPath (strcat baseDir "\\" mod))
    (if (vl-file-directory-p modPath)
      (progn
        ;; Load tat ca file .lsp
        (setq fList (vl-directory-files modPath "*.lsp" 1))
        (foreach f fList
          (setq fullPath (strcat modPath "\\" f))
          (if (vl-catch-all-error-p (vl-catch-all-apply 'load (list fullPath)))
            (princ (strcat "\n  [LOI] Khong nap duoc: " f))
            (setq count (1+ count))
          )
        )
        ;; Load tat ca file .vlx
        (setq fList (vl-directory-files modPath "*.vlx" 1))
        (foreach f fList
          (setq fullPath (strcat modPath "\\" f))
          (if (vl-catch-all-error-p (vl-catch-all-apply 'load (list fullPath)))
            (princ (strcat "\n  [LOI] Khong nap duoc: " f))
            (setq count (1+ count))
          )
        )
      )
    )
  )
  (princ (strcat "\n=== [LA635] HOAN TAT NAP " (itoa count) " CONG CU AUTOLISP SAN SANG SU DUNG ==="))
  (princ "\nGo lenh LA635_LOAD de nap lai bat cu luc nao.\n")
  (princ)
)

;; Tu dong nap ngay khi file load_all_lisps.lsp duoc goi
(c:LA635_LOAD)
(princ)
