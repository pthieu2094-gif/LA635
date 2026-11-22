(defun c:ZZZ () ;;;;;;;;;;;;; chuyen toa do ve 0
(defun suadinhPl(thongtin / index doituong doituongmoi 
            toado)
(setq
doituong (assoc '38 thongtin) 
doituongmoi 
            (cons 38 0.)
)
(subst doituongmoi doituong 
            thongtin)
)
(defun suadinh (thongtin / index doituong 
            doituongmoi toado)
(setq thongtinmoi nil)
(foreach doituong 
            thongtin
(if (and (>= (car doituong) 10)
(<= (car 
            doituong) 36) 
)
(setq doituongmoi
(list (car 
            doituong)
(cadr doituong)
(caddr 
            doituong)
0.0
)
)
(setq doituongmoi 
            doituong)
)
(setq thongtinmoi (append thongtinmoi (list 
            doituongmoi)))
)
(setq thongtinmoi thongtinmoi)
)
(defun 
            tendoituong (ssdt /)
(cdr (assoc '0 (entget 
            ssdt)))
)
;;---------------------------------------------
(setq 
            tapdoituong (ssget)
sodt (sslength tapdoituong)
index 0
ta 
            (chr 8)
stxoa (strcat ta ta ta ta ta ta ta ta ta ta ta ta ta ta 
            ta ta ta ta ta ta)
stxuly "Xu ly duoc: "
ptcu 
            nil
)
(repeat sodt
(setq
ssdt (ssname tapdoituong 
            index)
pt (* (/ (* index 1.0) sodt) 100.0)
index (1+ 
            index)
)
(if (/= pt ptcu)
(progn
(princ (strcat stxoa 
            stxuly (rtos pt 2 0) "%"))
(setq ptcu pt)
)
) 
(if (or 
            (= (tendoituong ssdt) "SPLINE")
(= (tendoituong ssdt) "LINE") 
            
(= (tendoituong ssdt) "CIRCLE")
(= (tendoituong ssdt) 
            "ARC")
(= (tendoituong ssdt) "POLYLINE")
(= (tendoituong ssdt) 
            "ELLIPSE")
(= (tendoituong ssdt) "TEXT")
(= (tendoituong ssdt) 
            "DIMENSION")
(= (tendoituong ssdt) "ATTDEF")
(= (tendoituong 
            ssdt) "SOLID")
(= (tendoituong ssdt) "INSERT")
(= (tendoituong 
            ssdt) "ATTRIB")
(= (tendoituong ssdt) 
            "HATCH")
)
(progn
(setq thongtin (entget ssdt)
thongtin 
            (suadinh thongtin)
)
(entmod thongtin)
)
)
(if (= 
            (tendoituong ssdt) "LWPOLYLINE")
(progn
(setq thongtin (entget 
            ssdt)
thongtin (suadinhPL thongtin) 
)
(entmod 
            thongtin)
)
)
(princ)
)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;