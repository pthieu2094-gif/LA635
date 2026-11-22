(defun C:` () 
(setq list_lay (list
"11 Text-content"
"12 Text-title"
"13 Text-name & frame drawing"
"14 Text in notation" 
"21 Dim"
"22 Hatch"
"23 Tole Hatch"
"24 Skylight Hatch"
"31 Drawing"
"32 Gridline"
"33 Flange steel"
"34 Border (bold wide)_Bracing_Flashing"
"35 Border (light wide)"
"36 Tole"
"37 Purlin"
"38 Solid rod"
"39 Light wide"
"41 Steel section"
"42 Steel plate"
"43 Bolt"
"A1 Door"
"A2 Louver in plane"
"A3 Louver in elevation"
"A4 Canopy in elevation"
"B1 Frame border note"
"B2 Frame border drawing"
"R1 Center"
"R2 Hide"
"R3 Viewport"
))  
(setq sym (STRCASE(getstring "Tu khoa: ")))
(setq n 0)(repeat (length list_lay)
(if (equal sym (substr (nth n list_lay) 1 2))
(progn
(setq name_layer (nth n list_lay))
(setq sset (ssget))  
(if (null sset)
(progn
(ALERT "\nERROR: Nothing selected.")
(exit)))
(command "_.change" sset "" "P" "LA" name_layer "s" "1" "c" "ByLayer" "lt" "ByLayer" "lw" "ByLayer" "")(exit)))
(setq n (+ n 1)))
(princ))