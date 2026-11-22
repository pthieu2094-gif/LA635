(defun C:atx ( / ELST ENT FILE_NAME FILE_WRITE LST_PT LST_WRITE MODE OPT PT STR X)
  (if (and
	(setq mode (listbox (list "Insert" "Circle" "Point" "Text" "MText") "Chon kieu doi tuong" 7 7 1))
	(setq str (apply 'strcat (mapcar '(lambda (x) (strcat x ",")) mode)))
	(setq str (substr str 1 (1- (strlen str))))
	(setq elst (vl-remove-if 'listp (mapcar 'cadr (if (ssget (list (cons 0 str))) (ssnamex (ssget "_P"))))))
	(setq opt (get_key (list "Yes" "No") "Yes" "Dao nguoc X/Y ?"))
	)
    (progn
      (setq lst_pt (mapcar '(lambda (ent) (cdr (assoc 10 (entget ent)))) elst))
      (if (= opt "Yes")
	(setq lst_write (mapcar '(lambda (pt) (strcat (rtos (cadr pt) 2 4) "\t" (rtos (car pt) 2 4) "\t" (rtos (caddr pt) 2 4))) lst_pt))
	(setq lst_write (mapcar '(lambda (pt) (strcat (rtos (car pt) 2 4) "\t" (rtos (cadr pt) 2 4) "\t" (rtos (caddr pt) 2 4))) lst_pt))
	)
      (if (setq file_name (getfiled "Xuat du lieu" "Toa do doi tuong" "txt" 1))
	(progn
	  (setq file_write (open file_name "W"))
	  (foreach str lst_write (write-line str file_write))
	  (close file_write)
	  )
	)
      )
    )
  (princ)
  )

(defun get_key (key default promp / key_fix str1 str2 str3 str4)
  (setq key_fix key)
  (foreach str1 (list " " "_")
    (setq key_fix (mapcar '(lambda (str) (while (vl-string-search str1 str) (setq str (vl-string-subst "" str1 str))) str) key_fix))
    )
  (setq str1 (apply 'strcat (mapcar (function (lambda (x) (strcat x " "))) key_fix)))
  (setq str2 (apply 'strcat (mapcar (function (lambda (x) (strcat x "/"))) key_fix)))
  (setq str1 (substr str1 1 (1- (strlen str1))))
  (setq str2 (substr str2 1 (1- (strlen str2))))
  (if (not (assoc default (mapcar 'list key_fix))) (setq default (car key_fix)))
  (initget str1)
  (setq str3 (strcat "\n" promp " [" str2 "] <" default "> "))
  (if (not (setq str4 (getkword str3)))
    (nth (vl-position default key_fix) key)
    (nth (vl-position str4 key_fix) key)
    )
  )

(defun listbox (lst msg wid hei bit / dch des tmp rtn)
  (if (> (length lst) 1)
    (progn
      (cond
	((not
	   (and
	     (setq tmp (vl-filename-mktemp nil nil ".dcl"))
	     (setq des (open tmp "w"))
	     (write-line
	       (strcat
		 "listbox:dialog{label=\""
		 msg
		 "\";spacer;:list_box{key=\"list\";multiple_select="
		 (if (= 1 (logand 1 bit))
		   "true"
		   "false"
		 )
		 (strcat ";width="
			 (rtos wid 2 0)
			 ";height="
			 (rtos hei 2 0)
			 ";}spacer;ok_cancel;}"
		 )
	       )
	       des
	     )
	     (not (close des))
	     (< 0 (setq dch (load_dialog tmp)))
	     (new_dialog "listbox" dch)
	   )
	 )
	 (prompt "\nError Loading List Box Dialog.")
	)
	(t
	 (start_list "list")
	 (foreach itm lst (add_list itm))
	 (end_list)
	 (setq rtn (set_tile "list" "0"))
	 (action_tile "list" "(setq rtn $value)")
	 (setq rtn
		(if (= 1 (start_dialog))
		  (if (= 2 (logand 2 bit))
		    (read (strcat "(" rtn ")"))
		    (mapcar '(lambda (x) (nth x lst))
			    (read (strcat "(" rtn ")"))
		    )
		  )
		)
	 )
	)
      )
      (if (< 0 dch)
	(unload_dialog dch)
      )
      (if (and tmp (setq tmp (findfile tmp)))
	(vl-file-delete tmp)
      )
      rtn
    )
    lst
    )
  )