import threading, ctypes, win32service, win32con, math

hdesk = win32service.OpenDesktop('Default', 0, False, win32con.MAXIMUM_ALLOWED)

def run():
    ctypes.windll.user32.SetThreadDesktop(int(hdesk))
    import pythoncom, win32com.client
    pythoncom.CoInitialize()
    acad = win32com.client.GetActiveObject('AutoCAD.Application')
    doc = acad.ActiveDocument
    ms = doc.ModelSpace

    # 1. Zoom to WC area
    doc.SendCommand('_.ZOOM _W 25000,-48500 32000,-45000\n')

    # 2. Collect left entities to delete from wc_comparison.txt
    left_handles = []
    right_handles = []
    with open('C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/wc_comparison.txt') as f:
        for line in f:
            parts = line.strip().split()
            if not parts: continue
            h = parts[0]
            bb_part = [p for p in parts if p.startswith('bb=')][0]
            coords = bb_part[3:].replace('(', '').replace(')', '').split('->')
            x1, y1 = [float(v) for v in coords[0].split(',')]
            x2, y2 = [float(v) for v in coords[1].split(',')]

            # Left WC interior: X in [27070, 28666], Y in [-47846, -45340]
            if (x1 >= 27070.0 and x2 <= 28666.0 and y1 >= -47846.0 and y2 <= -45340.0):
                left_handles.append(h)
            elif h == '2C85E4': # left door
                left_handles.append(h)

            # Right WC interior: X in [28735, 30666], Y in [-47846, -45340]
            if (x1 >= 28735.0 and x2 <= 30666.0 and y1 >= -47846.0 and y2 <= -45340.0):
                right_handles.append(h)
            elif h == '2C85E5': # right door
                right_handles.append(h)

    # Also add the old left wall polylines and loose lines
    extra_delete = [
        '2C8626', '2C8627',  # old left wall pline & hatch
        '2C862A', '2C862B',  # old bottom wall pline & hatch
        '2C85F8', '2C85F9',  # old Axis C segment left of WC
        '2C52B0', '2C52AE', '2C5275', '2C5273', '2C5274', '2C5276',
        '2C5271', '2C5272', '2C5270', '2C526F', '2C517C', '2C517B',
        '2C517A', '2C5179', '2C5172', '2C52E5', '2C52E4', '2C52E2',
        '2C52E1', '2C52B5', '2C52B4', '2C52B2', '2C52B1', '2C52AF',
        '2C52AD', '2C526E', '2C526D', '2C526C', '2C526B', '2C526A',
        '2C523A', '2C5239', '2C5238', '2C5237', '2C5171', '2C516D'
    ]
    all_to_delete = set(left_handles + extra_delete)
    print(f'Total entities to delete in Left WC: {len(all_to_delete)}')

    del_count = 0
    for h in all_to_delete:
        try:
            doc.HandleToObject(h).Delete()
            del_count += 1
        except Exception:
            pass
    print(f'Deleted {del_count} entities')

    # 3. Create updated wall Polylines and Hatches
    # A. New Left Wall: X in [26665.9, 26735.6], Y in [-47846.2, -45449.0]
    p_left = [26665.9, -47846.2, 26735.6, -47846.2, 26735.6, -45449.0, 26665.9, -45449.0]
    var_p1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, p_left)
    pl1 = ms.AddLightWeightPolyline(var_p1)
    pl1.Closed = True
    pl1.Layer = '31 Drawing'

    h1 = ms.AddHatch(0, 'LINE', True)
    h1.Layer = '22 Hatch'
    h1.PatternScale = 50.0
    h1.PatternAngle = math.radians(45.0)
    loop1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, [pl1])
    h1.AppendOuterLoop(loop1)
    h1.Evaluate()

    # B. New Bottom Wall: X in [26665.9, 28651.1], Y in [-47930.6, -47861.2]
    p_bot = [26665.9, -47930.6, 28651.1, -47930.6, 28651.1, -47861.2, 26665.9, -47861.2]
    var_p2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, p_bot)
    pl2 = ms.AddLightWeightPolyline(var_p2)
    pl2.Closed = True
    pl2.Layer = '31 Drawing'

    h2 = ms.AddHatch(0, 'LINE', True)
    h2.Layer = '22 Hatch'
    h2.PatternScale = 50.0
    h2.PatternAngle = math.radians(45.0)
    loop2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, [pl2])
    h2.AppendOuterLoop(loop2)
    h2.Evaluate()

    # C. Updated Axis C Wall (Left of WC): X in [25638.1, 26665.9], Y in [-45434.2, -45359.8]
    p_c = [25638.1, -45434.2, 26665.9, -45434.2, 26665.9, -45359.8, 25638.1, -45359.8]
    var_p3 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, p_c)
    pl3 = ms.AddLightWeightPolyline(var_p3)
    pl3.Closed = True
    pl3.Layer = '31 Drawing'

    h3 = ms.AddHatch(0, 'LINE', True)
    h3.Layer = '22 Hatch'
    h3.PatternScale = 50.0
    h3.PatternAngle = math.radians(45.0)
    loop3 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, [pl3])
    h3.AppendOuterLoop(loop3)
    h3.Evaluate()

    # Add finished plaster lines for the new left wall
    # Outer plaster face: X = 26651.1 (from -47945.4 to -45449.0)
    p_plaster1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [26651.1, -47945.4, 0.0])
    p_plaster2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [26651.1, -45345.0, 0.0])
    l_pl1 = ms.AddLine(p_plaster1, p_plaster2)
    l_pl1.Layer = '31 Drawing'

    # Bottom plaster line: Y = -47945.4 from 26651.1 to 28651.1
    p_bpl1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [26651.1, -47945.4, 0.0])
    p_bpl2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [28651.1, -47945.4, 0.0])
    l_bpl1 = ms.AddLine(p_bpl1, p_bpl2)
    l_bpl1.Layer = '31 Drawing'

    # Axis C plaster lines: Y = -45449.0 from 25638.1 to 26651.1, and Y = -45345.0 from 25638.1 to 26651.1
    l_c1 = ms.AddLine(win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [25638.1, -45449.0, 0.0]),
                      win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [26651.1, -45449.0, 0.0]))
    l_c1.Layer = '31 Drawing'
    l_c2 = ms.AddLine(win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [25638.1, -45345.0, 0.0]),
                      win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [26651.1, -45345.0, 0.0]))
    l_c2.Layer = '31 Drawing'

    print('Updated wall polylines and hatches successfully')

    # 4. Mirror all right WC entities across X = 28700.8
    # Save handles to a file for LISP MIRROR
    with open('C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/mirror_handles.txt', 'w') as f:
        for h in right_handles:
            f.write(f'{h}\n')

    doc.Regen(1)

t = threading.Thread(target=run)
t.start()
t.join()
