import threading, ctypes, win32service, win32con

hdesk = win32service.OpenDesktop('Default', 0, False, win32con.MAXIMUM_ALLOWED)

def run():
    ctypes.windll.user32.SetThreadDesktop(int(hdesk))
    import pythoncom, win32com.client
    pythoncom.CoInitialize()
    acad = win32com.client.GetActiveObject('AutoCAD.Application')
    doc = acad.ActiveDocument
    ms = doc.ModelSpace
    
    # 1. Parse window entities from scratch/window_entities.txt
    w1_handles = []
    w2_handles = []
    w3_handles = []
    w4_handles = []
    with open("C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/window_entities.txt") as f:
        for line in f:
            parts = line.strip().split()
            if not parts: continue
            tag = parts[0]
            h = parts[1][2:]
            if tag == "W1_N1": w1_handles.append(h)
            elif tag == "W1_N2": w2_handles.append(h)
            elif tag == "W1_N3": w3_handles.append(h)
            elif tag == "W1_N4": w4_handles.append(h)

    print(f"Handles count: W1={len(w1_handles)}, W2={len(w2_handles)}, W3={len(w3_handles)}, W4={len(w4_handles)}")

    # 2. Build B02_W1_1400 block definition
    origin_w1 = (2397.8, -45345.0, 0.0)
    try:
        blk1 = doc.Blocks.Item("B02_W1_1400")
        print("Block B02_W1_1400 already exists")
    except Exception:
        zero_pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [0.0, 0.0, 0.0])
        blk1 = doc.Blocks.Add(zero_pt, "B02_W1_1400")
        for h in w1_handles:
            try:
                line_obj = doc.HandleToObject(h)
                p1 = line_obj.StartPoint
                p2 = line_obj.EndPoint
                # relative to origin_w1
                rp1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p1[0] - origin_w1[0], p1[1] - origin_w1[1], 0.0])
                rp2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p2[0] - origin_w1[0], p2[1] - origin_w1[1], 0.0])
                nl = blk1.AddLine(rp1, rp2)
                nl.Layer = "0"
            except Exception as ex:
                print(f"Error copying line {h} to block: {ex}")
        print(f"Created block B02_W1_1400 with {blk1.Count} entities")

    # 3. Build B02_W1_1960 block definition
    origin_w3 = (31634.0, -45345.0, 0.0)
    try:
        blk3 = doc.Blocks.Item("B02_W1_1960")
        print("Block B02_W1_1960 already exists")
    except Exception:
        zero_pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [0.0, 0.0, 0.0])
        blk3 = doc.Blocks.Add(zero_pt, "B02_W1_1960")
        for h in w3_handles:
            try:
                line_obj = doc.HandleToObject(h)
                p1 = line_obj.StartPoint
                p2 = line_obj.EndPoint
                rp1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p1[0] - origin_w3[0], p1[1] - origin_w3[1], 0.0])
                rp2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p2[0] - origin_w3[0], p2[1] - origin_w3[1], 0.0])
                nl = blk3.AddLine(rp1, rp2)
                nl.Layer = "0"
            except Exception as ex:
                print(f"Error copying line {h} to block: {ex}")
        print(f"Created block B02_W1_1960 with {blk3.Count} entities")

    # 4. Delete old line entities of W1, W2, W3, W4
    all_win_handles = w1_handles + w2_handles + w3_handles + w4_handles
    deleted_cnt = 0
    for h in all_win_handles:
        try:
            e = doc.HandleToObject(h)
            e.Delete()
            deleted_cnt += 1
        except Exception:
            pass
    print(f"Deleted {deleted_cnt} old window lines")

    # 5. Insert block references on layer 31 Drawing
    insertions = [
        ("B02_W1_1400", [2397.8, -45345.0, 0.0]),
        ("B02_W1_1400", [8497.2, -45345.0, 0.0]),
        ("B02_W1_1960", [31634.0, -45345.0, 0.0]),
        ("B02_W1_1960", [33633.9, -45345.0, 0.0]),
    ]
    for bname, pos in insertions:
        ins_pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, pos)
        ref = ms.InsertBlock(ins_pt, bname, 1.0, 1.0, 1.0, 0.0)
        ref.Layer = "31 Drawing"
        print(f"Inserted {bname} at ({pos[0]:.1f}, {pos[1]:.1f})")

    doc.Regen(1)
    print("Window blocks processing completed successfully!")

t = threading.Thread(target=run)
t.start()
t.join()
