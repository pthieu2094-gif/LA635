;;; ==========================================================================
;;; ACADDOC.LSP - TU DONG LOAD BOKHOI TAO LA635 KHI MO BAN VE
;;; ==========================================================================
(vl-load-com)
(setq _la635_loader (strcat (getvar "DWGPREFIX") "scripts\\lisp\\load_all_lisps.lsp"))
(if (findfile _la635_loader)
  (load _la635_loader)
)
(princ)
