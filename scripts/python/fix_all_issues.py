import threading, ctypes, win32service, win32con, math

hdesk = win32service.OpenDesktop('Default', 0, False, win32con.MAXIMUM_ALLOWED)

def run():
    ctypes.windll.user32.SetThreadDesktop(int(hdesk))
    import pythoncom, win32com.client
    pythoncom.CoInitialize()
    acad = win32com.client.GetActiveObject('AutoCAD.Application')
    doc = acad.ActiveDocument
    ms = doc.ModelSpace

    def to_variant_points(coords):
        return win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, coords)

    def to_variant_dispatch(objs):
        return win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, objs)

    # ==========================================================
    # BƯỚC 1: CỘT KẾT CẤU TRỤC 6-C & NỐI KÍN TƯỜNG TRỤC C
    # ==========================================================
    print("--- Step 1: Column Axis 6-C & Wall Axis C ---")
    
    # 1.1 Xóa polyline cũ 2C8644 và hatch 2C8645 nếu còn
    for h in ['2C8644', '2C8645']:
        try:
            doc.HandleToObject(h).Delete()
        except:
            pass

    # 1.2 Polyline & Hatch tường Trục C bên trái: X in [25638.1, 26651.1], Y in [-45434.2, -45359.8]
    p_c_left = [25638.1, -45434.2, 26651.1, -45434.2, 26651.1, -45359.8, 25638.1, -45359.8]
    pl_c = ms.AddLightWeightPolyline(to_variant_points(p_c_left))
    pl_c.Closed = True
    pl_c.Layer = '31 Drawing'

    h_c = ms.AddHatch(0, 'LINE', True)
    h_c.Layer = '22 Hatch'
    h_c.PatternScale = 50.0
    h_c.PatternAngle = math.radians(45.0)
    h_c.AppendOuterLoop(to_variant_dispatch([pl_c]))
    h_c.Evaluate()

    # 1.3 Cột kết cấu tại Trục 6 - C (góc ngoài WC trái):
    # X in [26651.1, 26953.9], Y in [-45647.5, -45345.0]
    p_col = [26651.1, -45345.0, 26953.9, -45345.0, 26953.9, -45647.5, 26651.1, -45647.5]
    pl_col = ms.AddLightWeightPolyline(to_variant_points(p_col))
    pl_col.Closed = True
    pl_col.Layer = '31 Drawing'

    # Đường trát hoàn thiện tường Trục C bên trái nối vào cột
    l_c1 = ms.AddLine(to_variant_points([25638.1, -45345.0, 0.0]), to_variant_points([26651.1, -45345.0, 0.0]))
    l_c1.Layer = '31 Drawing'
    l_c2 = ms.AddLine(to_variant_points([25638.1, -45449.0, 0.0]), to_variant_points([26651.1, -45449.0, 0.0]))
    l_c2.Layer = '31 Drawing'

    # ==========================================================
    # BƯỚC 2: LÀM PHẲNG TƯỜNG TRỤC C PHÍA TRÊN WC TRÁI
    # ==========================================================
    print("--- Step 2: Flatten Axis C wall above left WC ---")
    for h in ['2C8A05', '2C8A06', '2C8A07', '2C8A08', '2C8A09', '2C8A0A', '2C8A01']:
        try:
            doc.HandleToObject(h).Delete()
        except:
            pass

    # Đường hoàn thiện trát trên (Y = -45345.0) từ cửa sang vách giữa
    l_top1 = ms.AddLine(to_variant_points([27753.0, -45345.0, 0.0]), to_variant_points([28651.3, -45345.0, 0.0]))
    l_top1.Layer = '31 Drawing'
    # Đường hoàn thiện trát dưới (Y = -45449.0)
    l_top2 = ms.AddLine(to_variant_points([27852.2, -45449.0, 0.0]), to_variant_points([28651.3, -45449.0, 0.0]))
    l_top2.Layer = '31 Drawing'

    # ==========================================================
    # BƯỚC 3: DỌN DẸP & VẼ LẠI CẦU THANG ĐỀU ĐẶN 250MM
    # ==========================================================
    print("--- Step 3: Rebuild stairs with 250mm treads ---")
    
    # 3.1 Đọc danh sách handles thang cũ từ acad_stair_entities.txt và xóa các entity dưới Y = -47946
    with open('C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/acad_stair_entities.txt') as f:
        for line in f:
            parts = line.strip().split()
            if not parts: continue
            h = parts[0]
            try:
                obj = doc.HandleToObject(h)
                minp, maxp = obj.GetBoundingBox()
                # Chỉ xóa các entity nằm bên dưới Y = -47945.5
                if maxp[1] <= -47945.5:
                    obj.Delete()
            except:
                pass

    # 3.2 Vách tường biên trái thang mới: X in [26665.9, 26735.6], Y in [-49637.8, -47930.6]
    p_stair_wall = [26665.9, -47930.6, 26735.6, -47930.6, 26735.6, -49637.8, 26665.9, -49637.8]
    pl_sw = ms.AddLightWeightPolyline(to_variant_points(p_stair_wall))
    pl_sw.Closed = True
    pl_sw.Layer = '31 Drawing'

    h_sw = ms.AddHatch(0, 'LINE', True)
    h_sw.Layer = '22 Hatch'
    h_sw.PatternScale = 50.0
    h_sw.PatternAngle = math.radians(45.0)
    h_sw.AppendOuterLoop(to_variant_dispatch([pl_sw]))
    h_sw.Evaluate()

    # Đường hoàn thiện trát tường biên trái thang:
    l_sw1 = ms.AddLine(to_variant_points([26651.1, -47945.4, 0.0]), to_variant_points([26651.1, -49637.8, 0.0]))
    l_sw1.Layer = '31 Drawing'
    l_sw2 = ms.AddLine(to_variant_points([26735.6, -47945.4, 0.0]), to_variant_points([26735.6, -49563.3, 0.0]))
    l_sw2.Layer = '31 Drawing'

    # Đường biên chân thang: Y = -49563.3
    l_bot = ms.AddLine(to_variant_points([26735.6, -49563.3, 0.0]), to_variant_points([28507.2, -49563.3, 0.0]))
    l_bot.Layer = '31 Drawing'

    # Gờ chân tường dưới: Y = -49637.8
    l_base = ms.AddLine(to_variant_points([26651.1, -49637.8, 0.0]), to_variant_points([28542.0, -49637.8, 0.0]))
    l_base.Layer = '31 Drawing'
    l_join = ms.AddLine(to_variant_points([28507.2, -49563.3, 0.0]), to_variant_points([28542.0, -49637.8, 0.0]))
    l_join.Layer = '31 Drawing'

    # 3.3 Vẽ các bậc thang đều đặn 250mm
    x0 = 26735.6
    step = 250.0
    y_bot = -49563.3
    y_wc = -47945.4

    for k in range(1, 10):
        cur_x = x0 + k * step
        if cur_x < 27750.0:
            cur_ytop = y_wc
        else:
            cur_ytop = y_wc - (cur_x - 27750.0) * (1617.9 / 750.0)

        if cur_ytop > y_bot:
            tread = ms.AddLine(to_variant_points([cur_x, y_bot, 0.0]), to_variant_points([cur_x, cur_ytop, 0.0]))
            tread.Layer = '31 Drawing'

    # 3.4 Đường Break line zíc-zắc
    p_break = [
        27750.0, -47945.4,
        28020.0, -48550.0,
        28180.0, -48470.0,
        28080.0, -48770.0,
        28240.0, -48690.0,
        28500.0, -49563.3
    ]
    pl_brk = ms.AddLightWeightPolyline(to_variant_points(p_break))
    pl_brk.Layer = '31 Drawing'

    # 3.5 Các vòng tròn đánh số bậc (1 đến 8)
    y_circ = -49250.0
    r_circ = 75.0
    for j in range(8):
        cx = x0 + j * step + step / 2.0
        circ = ms.AddCircle(to_variant_points([cx, y_circ, 0.0]), r_circ)
        circ.Layer = '31 Drawing'

    # 3.6 Mũi tên chỉ hướng UP
    y_arrow = -48750.0
    c_start = ms.AddCircle(to_variant_points([x0 + 125.0, y_arrow, 0.0]), 30.0)
    c_start.Layer = '31 Drawing'

    l_arr = ms.AddLine(to_variant_points([x0 + 155.0, y_arrow, 0.0]), to_variant_points([27800.0, y_arrow, 0.0]))
    l_arr.Layer = '31 Drawing'

    p_arrowhead = [
        27680.0, y_arrow + 50.0,
        27800.0, y_arrow,
        27680.0, y_arrow - 50.0
    ]
    pl_head = ms.AddLightWeightPolyline(to_variant_points(p_arrowhead))
    pl_head.Layer = '31 Drawing'

    doc.Regen(1)
    print("ALL THREE ISSUES RESOLVED SUCCESSFULLY!")

t = threading.Thread(target=run)
t.start()
t.join()
