;HAM TAO LAYER
(defun TT:LTYPE()
  (ENTMAKE (LIST
	'(0 . "LTYPE")'(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLinetypeTableRecord") '(2 . "HIDDEN")'(70 . 0) '(3 . "Hidden __ __ __ __ __ __ __ __ __ __ __ __ __ _") '(72 . 65) '(73 . 2) '(40 . 0.375) '(49 . 0.25) '(74 . 0) '(49 . -0.125) '(74 . 0)))
  (ENTMAKE (LIST
	'(0 . "LTYPE")'(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLinetypeTableRecord") '(2 . "CENTER") '(70 . 0) '(3 . "Center ____ _ ____ _ ____ _ ____ _ ____ _ ____") '(72 . 65) '(73 . 4) '(40 . 2.0) '(49 . 1.25) '(74 . 0) '(49 . -0.25) '(74 . 0) '(49 . 0.25) '(74 . 0) '(49 . -0.25) '(74 . 0)))
  (ENTMAKE (LIST
	'(0 . "LTYPE")'(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLinetypeTableRecord") '(2 . "DASHED") '(70 . 0) '(3 . "Dashed __ __ __ __ __ __ __ __ __ __ __ __ __ _") '(72 . 65) '(73 . 2) '(40 . 0.75) '(49 . 0.5) '(74 . 0) '(49 . -0.25) '(74 . 0))))

(defun TT:LAYER()
    	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "31 Drawing") 		 '(70 . 0) '(62 . 7) 	'(6 . "Continuous")))
    	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "11 Text-content") 	 '(70 . 0) '(62 . 255) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "12 Text-title") 		 '(70 . 0) '(62 . 10) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "13 Text-name & frame drawing")'(70 . 0) '(62 . 255) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "14 Text in notation") 	 '(70 . 0) '(62 . 10) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "21 Dim") 		 '(70 . 0) '(62 . 251) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "22 Hatch") 		 '(70 . 0) '(62 . 8) '(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "23 Tole Hatch") 		 '(70 . 0) '(62 . 146) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "24 Skylight Hatch") 	 '(70 . 0) '(62 . 142) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "25TEXT") 		 '(70 . 0) '(62 . 2) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "32 Gridline") 		 '(70 . 0) '(62 . 251) 	'(6 . "CENTER")))
	(ENTMAKE (LIST 
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "33 Flange steel") 	 '(70 . 0) '(62 . 3) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "34 Border (bold wide)_Bracing_Flashing") '(70 . 0) '(62 . 4) '(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "35 Border (light wide)") '(70 . 0) '(62 . 5) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "36 Tole") 		 '(70 . 0) '(62 . 1) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "37 Purlin") 		 '(70 . 0) '(62 . 33) 	'(6 . "DASHED")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "38 Solid rod") 		 '(70 . 0) '(62 . 252) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "39 Light wide") 		 '(70 . 0) '(62 . 8) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "41 Steel section") 	 '(70 . 0) '(62 . 210) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "42 Steel plate") 	 '(70 . 0) '(62 . 140) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "43 Bolt") 		 '(70 . 0) '(62 . 2) 	'(6 . "Continuous")))
	(ENTMAKE (LIST
	'(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord") '(2 . "HIDDEN") 		 '(70 . 0) '(62 . 251) 	'(6 . "HIDDEN"))))
 ;HAM GAN DIM HIEN HUU
(defun _SetDimStyleCurrent (dim / acdoc)
 	(vl-load-com)
 	(setq acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
 	(if (tblsearch "DIMSTYLE" dim)
   	(vla-put-activeDimstyle    acdoc
     	(vla-item (vla-get-Dimstyles acdoc) dim)   ) )
 	(princ)
	);DONG HAM

;LENH TAO DIM TEXT LAYER
(defun C:TDTL()  
  (entmake (list
	   	'(0 . "STYLE")'(100 . "AcDbSymbolTableRecord") '(100 . "AcDbTextStyleTableRecord") '(2 . "VNI")
		'(70 . 0) '(40 . 0.0) '(41 . 0.8) '(50 . 0.0) '(71 . 0) '(42 . 1.46)'(3 . "vn_vni.shx") '(4 . "")))
  (entmake (list
		'(0 . "DIMSTYLE")'(100 . "AcDbSymbolTableRecord")'(100 . "AcDbDimStyleTableRecord") '(2 . "ATAD1-1") '(70 . 0) '(3 . "") '(4 . "") '(5 . "") '(6 . "") '(7 . "")
		'(40 . 1.0) '(41 . 1.75) '(42 . 1.0) '(43 . 8.5) '(44 . 1.0)'(45 . 0.0) '(46 . 1.0) '(47 . 0.0) '(48 . 0.0) '(140 . 2.2) '(141 . 4.0) '(142 . 0.0) '(143 . 25.4)
		'(144 . 1.0) '(145 . 0.0) '(146 . 1.0) '(147 . 0.5)'(71 . 0)'(72 . 0) '(73 . 0) '(74 . 0) '(75 . 0) '(76 . 0) '(77 . 1) '(78 . 0) '(170 . 0) '(171 . 2) '(172 . 1)
		'(173 . 0) '(174 . 1) '(175 . 0) '(176 . 251)'(177 . 251) '(178 . 255) '(270 . 2) '(271 . 0) '(272 . 0) '(273 . 2) '(274 . 2)'(275 . 0) '(280 . 0) '(281 . 0) '(282 . 0)
  		'(283 . 1) '(284 . 0)'(285 . 0) '(286 . 0) '(287 . 5) '(288 . 0)(cons 340 (tblobjname "style" "VNI"))))		
  
  (_SetDimStyleCurrent "ATAD1-1")
  (setvar "DIMLDRBLK" "Open30")
  (command "dimstyle"  "save"    "ATAD1-1" "Y")	
  (TT:LTYPE)
  (TT:LAYER)	
  (PRINC)
  )

