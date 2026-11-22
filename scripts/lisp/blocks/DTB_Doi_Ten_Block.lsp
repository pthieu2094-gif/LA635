

(defun c:DTB (/ prefix siffix n usercmd)

	;; ignore xref, xref dependent and anonymous

  (defun GetBlkNames (/ data result)

	(while (setq data (tblnext "block" (null data)))

  	(if (zerop (logand 21 (cdr (assoc 70 data))))

    	(setq result (cons (cdr (assoc 2 data)) result))

  	)

	)

	(acad_strlsort result)

  )

 

  (if (and

    	(setq prefix (getstring t "\nTRUOC: "))

    	(setq suffix (getstring t "\nSAU: "))

  	)

	(progn

  	(setq usercmd (getvar "CMDECHO"))

  	(setvar "CMDECHO" 0)

  	(command "_undo" "_begin")

  	;;  Walk through the collection

  	(foreach n (GetBlkNames)

      	(if (vl-catch-all-error-p

            	(vl-catch-all-apply

              	'(lambda ()

                 	(command "_.-rename" "_b" n (strcat prefix n suffix))

                 	(princ (strcat "\n" n " --> " prefix n suffix))

               	)

            	)

          	)

        	(prompt (strcat "\nError for block name: " prefix n suffix))

      	)

  	)

  	(command "_undo" "_end")

  	(setvar "CMDECHO" usercmd)

	)

  )

  (princ)

)