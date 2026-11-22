import threading, ctypes, win32service, win32con, math

hdesk = win32service.OpenDesktop('Default', 0, False, win32con.MAXIMUM_ALLOWED)

def run():
    ctypes.windll.user32.SetThreadDesktop(int(hdesk))
    import pythoncom, win32com.client
    pythoncom.CoInitialize()
    acad = win32com.client.GetActiveObject('AutoCAD.Application')
    doc = acad.ActiveDocument
    ms = doc.ModelSpace

    # List of all wall core rectangles in MB T1 B02
    # Format: (type, minx, miny, maxx, maxy)
    wall_rects = [
        # --- Axis C (North) ---
        ('H', 149.5, -45434.2, 2248.9, -45359.8),  # already created pline 2C85AD / hatch 2C85AE
        ('H', 3946.1, -45434.2, 6050.5, -45359.8),  # already created pline 2C85E6 / hatch 2C85E7
        ('H', 6348.2, -45434.2, 8348.3, -45359.8),  # already created pline 2C85E8 / hatch 2C85E9
        ('H', 10050.7, -45434.2, 12050.6, -45359.8),
        ('H', 12348.4, -45434.2, 13559.5, -45359.8),
        ('H', 17038.4, -45434.2, 18249.5, -45359.8),
        ('H', 18497.8, -45434.2, 20159.5, -45359.8),
        ('H', 21290.2, -45434.2, 22948.5, -45359.8),
        ('H', 23148.3, -45434.2, 24523.2, -45359.8),
        ('H', 25638.1, -45434.2, 27012.9, -45359.8),
        ('H', 27852.0, -45434.2, 28651.1, -45359.8),
        ('H', 28750.3, -45434.2, 29549.4, -45359.8),
        ('H', 30447.7, -45434.2, 31549.5, -45359.8),
        ('H', 33549.6, -45434.2, 33633.9, -45359.8),
        ('H', 35549.8, -45434.2, 36477.7, -45359.8),

        # --- Axis A (South) ---
        ('H', 149.5, -59633.4, 998.2, -59563.8),   # already created pline 2C85EA / hatch 2C85EB
        ('H', 5196.8, -59633.4, 6050.5, -59563.8),
        ('H', 6149.7, -59633.4, 6998.4, -59563.8),
        ('H', 11197.2, -59633.4, 12050.6, -59563.8),
        ('H', 12348.4, -59633.4, 13197.1, -59563.8),
        ('H', 17400.8, -59633.4, 18249.5, -59563.8),
        ('H', 27852.0, -59633.4, 30447.7, -59563.8),
        ('H', 30750.5, -59633.4, 36477.7, -59563.8),

        # --- Axis 1 (West) ---
        ('V', -138.4, -59345.5, -69.0, -51647.9),
        ('V', -138.4, -51345.2, -69.0, -45647.5),

        # --- Axis 8 (East) ---
        ('V', 36641.6, -59400.1, 36711.0, -51623.1),
        ('V', 36641.6, -51375.0, 36711.0, -45597.9),

        # --- Axis B (Middle Wall) ---
        ('H', 149.5, -51533.7, 6050.5, -51464.2),
        ('H', 6348.2, -51533.7, 12050.6, -51464.2),
        ('H', 12348.4, -51533.7, 18249.5, -51464.2),
        ('H', 18497.8, -51533.7, 22948.5, -51464.2),
        ('H', 23148.3, -51533.7, 27601.3, -51464.2),
        ('H', 27852.0, -51533.7, 30447.7, -51464.2),

        # --- Internal Partitions (WC & Rooms) ---
        ('V', 27012.9, -47846.2, 27077.9, -45449.0),
        ('V', 28666.1, -47846.2, 28735.5, -45449.0),
        ('H', 27077.9, -47930.6, 28651.1, -47861.2),
        ('H', 28750.3, -47930.6, 30651.2, -47861.2),
        ('V', 27601.3, -54447.1, 27666.3, -51647.9),
        ('H', 28651.1, -54531.3, 30651.2, -54461.9),
        ('V', 30666.0, -59345.5, 30735.7, -54546.4),
        ('V', 30666.0, -54447.1, 30735.7, -51647.9),
        ('V', 30666.0, -51345.2, 30735.7, -47945.4),
        ('V', 30666.0, -47846.2, 30735.7, -45647.5),
    ]

    # Skip the 4 that were already created in tests:
    already_done = [
        (149.5, -45434.2, 2248.9, -45359.8),
        (3946.1, -45434.2, 6050.5, -45359.8),
        (6348.2, -45434.2, 8348.3, -45359.8),
        (149.5, -59633.4, 998.2, -59563.8),
    ]

    # Collect old line handles matching these wall core lines to delete them cleanly
    old_lines_to_delete = []
    with open('C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/remaining_wall_lines.txt') as f:
        for l in f:
            parts = l.strip().split()
            if len(parts) >= 6:
                h, x1, y1, x2, y2 = parts[0], float(parts[1]), float(parts[2]), float(parts[3]), float(parts[4])
                minx, maxx = min(x1, x2), max(x1, x2)
                miny, maxy = min(y1, y2), max(y1, y2)
                
                # Check if this line lies on any of the wall core rectangle borders
                for r_type, rx1, ry1, rx2, ry2 in wall_rects:
                    # Horizontal boundary line:
                    if abs(y1 - y2) < 1.0:
                        if (abs(miny - ry1) < 2.0 or abs(miny - ry2) < 2.0) and (minx >= rx1 - 5.0 and maxx <= rx2 + 5.0):
                            old_lines_to_delete.append(h)
                            break
                    # Vertical boundary line:
                    elif abs(x1 - x2) < 1.0:
                        if (abs(minx - rx1) < 2.0 or abs(minx - rx2) < 2.0) and (miny >= ry1 - 5.0 and maxy <= ry2 + 5.0):
                            old_lines_to_delete.append(h)
                            break

    print(f'Total old core lines identified to delete: {len(old_lines_to_delete)}')

    # 1. Delete old core lines
    deleted_cnt = 0
    for h in set(old_lines_to_delete):
        try:
            doc.HandleToObject(h).Delete()
            deleted_cnt += 1
        except:
            pass
    print(f'Successfully deleted {deleted_cnt} old core lines')

    # 2. Create closed polylines and hatches for each wall core rectangle
    created_plines = 0
    created_hatches = 0
    for r_type, x1, y1, x2, y2 in wall_rects:
        # Check if already done
        is_done = False
        for ax1, ay1, ax2, ay2 in already_done:
            if abs(x1 - ax1) < 5 and abs(y1 - ay1) < 5 and abs(x2 - ax2) < 5 and abs(y2 - ay2) < 5:
                is_done = True
                break
        if is_done:
            continue

        # Add Lightweight Polyline
        pts = [x1, y1, x2, y1, x2, y2, x1, y2]
        var_pts = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, pts)
        pline = ms.AddLightWeightPolyline(var_pts)
        pline.Closed = True
        pline.Layer = '31 Drawing'
        created_plines += 1

        # Add Hatch
        hatch = ms.AddHatch(0, 'LINE', True)
        hatch.Layer = '22 Hatch'
        hatch.PatternScale = 50.0
        hatch.PatternAngle = math.radians(45.0)

        loop = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, [pline])
        hatch.AppendOuterLoop(loop)
        hatch.Evaluate()
        created_hatches += 1

    print(f'Successfully created {created_plines} closed wall Polylines and {created_hatches} Hatches!')
    doc.Regen(1)

t = threading.Thread(target=run)
t.start()
t.join()
