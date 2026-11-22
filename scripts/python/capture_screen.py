import sys, threading, ctypes, win32service, win32con

out_path = sys.argv[1] if len(sys.argv) > 1 else "C:/Users/OS/.gemini/antigravity/brain/a004ff9c-b31a-4036-884e-42c622a64472/scratch/cad_screenshot.png"
hdesk = win32service.OpenDesktop('Default', 0, False, win32con.MAXIMUM_ALLOWED)

def run():
    ret = ctypes.windll.user32.SetThreadDesktop(int(hdesk))
    if not ret:
        print("Failed to set desktop")
        return
    
    import pythoncom, win32com.client, win32gui, win32ui
    from PIL import Image
    pythoncom.CoInitialize()
    acad = win32com.client.GetActiveObject('AutoCAD.Application')
    hwnd = acad.HWND
    
    # Zoom if coordinates provided
    if len(sys.argv) >= 6:
        x1, y1, x2, y2 = float(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4]), float(sys.argv[5])
        p1 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [x1, y1, 0.0])
        p2 = win32com.client.VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, [x2, y2, 0.0])
        acad.ZoomWindow(p1, p2)
    
    # Capture window
    l, t, r, b = win32gui.GetWindowRect(hwnd)
    w = r - l
    h = b - t
    if w <= 0 or h <= 0:
        print("Invalid window dimensions")
        return
        
    hwnd_dc = win32gui.GetWindowDC(hwnd)
    mfc_dc = win32ui.CreateDCFromHandle(hwnd_dc)
    save_dc = mfc_dc.CreateCompatibleDC()
    save_bmp = win32ui.CreateBitmap()
    save_bmp.CreateCompatibleBitmap(mfc_dc, w, h)
    save_dc.SelectObject(save_bmp)
    
    # PrintWindow (PW_RENDERFULLCONTENT = 2)
    user32 = ctypes.windll.user32
    user32.PrintWindow(hwnd, save_dc.GetSafeHdc(), 2)
    
    bmp_info = save_bmp.GetInfo()
    bmp_str = save_bmp.GetBitmapBits(True)
    im = Image.frombuffer('RGB', (bmp_info['bmWidth'], bmp_info['bmHeight']), bmp_str, 'raw', 'BGRX', 0, 1)
    im.save(out_path)
    print(f"Captured {w}x{h} to {out_path}")
    
    win32gui.DeleteObject(save_bmp.GetHandle())
    save_dc.DeleteDC()
    mfc_dc.DeleteDC()
    win32gui.ReleaseDC(hwnd, hwnd_dc)

t = threading.Thread(target=run)
t.start()
t.join()
