import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import '../../domain/entities/window_info.dart';

typedef _NativeEnumWindowsProc = Bool Function(Pointer<Void> hwnd, IntPtr lParam);

class Win32WindowDatasource {
  static final List<WindowInfo> _buffer = [];
  static int _selfHwnd = 0;

  static bool _enumWindowsProc(Pointer<Void> rawPtr, int lParam) {

    // Skip the current window itself.
    final rawHwnd = rawPtr.address;
    if (rawHwnd == _selfHwnd) return true;

    // Get the HWND of the current window.
    final hwnd = HWND(rawPtr);
    if (!IsWindowVisible(hwnd)) return true;

    // Skip tool windows.
    final exStyleResult = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
    if ((exStyleResult.value & WS_EX_TOOLWINDOW) != 0) {
      return true;
    }

    // Get the length of the window title.
    final length = GetWindowTextLength(hwnd).value;
    if (length == 0) return true;

    // Allocate memory for the window title and retrieve it.
    final titlePtr = wsalloc(length + 1);
    GetWindowText(hwnd, titlePtr, length + 1);

    // Convert the window title to a Dart string.
    final title = titlePtr.toDartString();
    free(titlePtr);
    
    // Filtrar ventanas "cloaked" (apps UWP en segundo plano y otros escritorios virtuales)
    final cloakedPtr = calloc<DWORD>();
    var isCloaked = false;
    try {
      DwmGetWindowAttribute(
        hwnd,
        DWMWA_CLOAKED,
        cloakedPtr,
        sizeOf<DWORD>(),
      );
      isCloaked = cloakedPtr.value != 0;
    } catch (_) {
      // Si la ventana no soporta el atributo, la tratamos como visible normal
    } finally {
      free(cloakedPtr);
    }
    if (isCloaked) return true;

    if (title.trim().isEmpty || title == 'Program Manager') {
      return true;
    }

    final processName = _getProcessName(hwnd);
    final isMinimized = IsIconic(hwnd);

    _buffer.add(WindowInfo(
      hwnd: rawHwnd,
      title: title,
      processName: processName,
      isMinimized: isMinimized,
    ));
    return true;
  }

  static String _getProcessName(HWND hwnd) {
    final pidPtr = calloc<DWORD>();
    GetWindowThreadProcessId(hwnd, pidPtr);
    final pid = pidPtr.value;
    free(pidPtr);

    final processResult = OpenProcess(
      PROCESS_QUERY_INFORMATION | PROCESS_VM_READ,
      false,
      pid,
    );
    final hProcess = processResult.value;
    if (hProcess.address == 0) return 'app.exe';

    final pathPtr = wsalloc(MAX_PATH);
    final len = GetModuleFileNameEx(hProcess, HMODULE(nullptr), pathPtr, MAX_PATH).value;
    CloseHandle(hProcess);

    if (len == 0) {
      free(pathPtr);
      return 'app.exe';
    }
    final fullPath = pathPtr.toDartString();
    free(pathPtr);
    return fullPath.split('\\').last;
  }

  List<WindowInfo> getOpenWindows() {
    _buffer.clear();
    _selfHwnd = GetActiveWindow().address;
    final callback = Pointer.fromFunction<_NativeEnumWindowsProc>(_enumWindowsProc, false);
    EnumWindows(callback.cast(), LPARAM(0));

    // Ordenar: primero las visibles en monitores (isMinimized == false)
    _buffer.sort((a, b) {
      if (a.isMinimized == b.isMinimized) return 0;
      return a.isMinimized ? 1 : -1;
    });
    return List<WindowInfo>.from(_buffer);
  }

  bool isWindowValid(int rawHwnd) {
    return IsWindow(HWND(Pointer.fromAddress(rawHwnd)));
  }

  void minimizeWindow(int rawHwnd) {
    final hwnd = HWND(Pointer.fromAddress(rawHwnd));
    if (IsWindow(hwnd) && !IsIconic(hwnd)) {
      ShowWindow(hwnd, SW_MINIMIZE);
    }
  }

  void restoreAndFocusWindow(int rawHwnd) {
    final hwnd = HWND(Pointer.fromAddress(rawHwnd));
    if (!IsWindow(hwnd)) return;
    if (IsIconic(hwnd)) {
      ShowWindow(hwnd, SW_RESTORE);
    }
    SetForegroundWindow(hwnd);
  }
}