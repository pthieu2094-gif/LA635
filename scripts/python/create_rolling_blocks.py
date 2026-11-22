import threading, ctypes, win32service, win32con

hdesk = win32service.OpenDesktop('Default', 0, False, win32con.MAXIMUM_ALLOWED)

def run():
    ctypes.windll.user32.SetThreadDesktop(int(hdesk))
    import pythoncom, win32com.client
    pythoncom.CoInitialize()
    acad = win32com.client.GetActiveObject('AutoCAD.Application')
    doc = acad.ActiveDocument
    ms = doc.ModelSpace
    
    # Read handles
    spans = {"D1_SPAN1": [], "D1_SPAN2": [], "D1_SPAN3": [], "D2_SPAN4": [], "D2_SPAN5": []}
    with open("C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/rolling_entities.txt") as f:
        for line in f:
            parts = line.strip().split()
            if not parts: continue
            tag = parts[0]
            h = parts[1][2:]
            if tag in spans:
                spans[tag].append(h)

    print({k: len(v) for k, v in spans.items()})

    # 1. Block B02_D1_ROLLING
    origin_d1 = (1097.5, -59549.0, 0.0)
    try:
        blk1 = doc.Blocks.Item("B02_D1_ROLLING")
    except Exception:
        zero_pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [0.0, 0.0, 0.0])
        blk1 = doc.Blocks.Add(zero_pt, "B02_D1_ROLLING")
        for h in spans["D1_SPAN1"]:
            try:
                line_obj = doc.HandleToObject(h)
                p1, p2 = line_obj.StartPoint, line_obj.EndPoint
                rp1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p1[0] - origin_d1[0], p1[1] - origin_d1[1], 0.0])
                rp2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p2[0] - origin_d1[0], p2[1] - origin_d1[1], 0.0])
                nl = blk1.AddLine(rp1, rp2)
                nl.Layer = "0"
            except Exception as ex:
                print(f"Error copying D1 line: {ex}")
        print(f"Created B02_D1_ROLLING with {blk1.Count} entities")

    # 2. Block B02_D2_ROLLING
    origin_d2 = (23180.8, -59549.0, 0.0)
    try:
        blk2 = doc.Blocks.Item("B02_D2_ROLLING")
    except Exception:
        zero_pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [0.0, 0.0, 0.0])
        blk2 = doc.Blocks.Add(zero_pt, "B02_D2_ROLLING")
        for h in spans["D2_SPAN5"]:
            try:
                line_obj = doc.HandleToObject(h)
                p1, p2 = line_obj.StartPoint, line_obj.EndPoint
                rp1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p1[0] - origin_d2[0], p1[1] - origin_d2[1], 0.0])
                rp2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [p2[0] - origin_d2[0], p2[1] - origin_d2[1], 0.0])
                nl = blk2.AddLine(rp1, rp2)
                nl.Layer = "0"
            except Exception as ex:
                print(f"Error copying D2 line: {ex}")
        print(f"Created B02_D2_ROLLING with {blk2.Count} entities")

    # Delete old lines across all spans
    for tag, handles in spans.items():
        for h in handles:
            try:
                doc.HandleToObject(h).Delete()
            except Exception:
                pass
    print("Deleted old rolling door lines")

    # Insert blocks
    d1_inserts = [
        [1097.5, -59549.0, 0.0],
        [7097.6, -59549.0, 0.0],
        [13296.3, -59549.0, 0.0]
    ]
    for pos in d1_inserts:
        pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, pos)
        ref = ms.InsertBlock(pt, "B02_D1_ROLLING", 1.0, 1.0, 1.0, 0.0)
        ref.Layer = "31 Drawing"

    d2_inserts = [
        [18547.3, -59549.0, 0.0],
        [23180.8, -59549.0, 0.0]
    ]
    for pos in d2_inserts:
        pt = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, pos)
        ref = ms.InsertBlock(pt, "B02_D2_ROLLING", 1.0, 1.0, 1.0, 0.0)
        ref.Layer = "31 Drawing"

    doc.Regen(1)
    print("Rolling doors created and inserted successfully!")

t = threading.Thread(target=run)
t.start()
t.join()
