// ignore_for_file: deprecated_member_use

import 'package:window_manager/window_manager.dart';
import 'package:material_ui/material_ui.dart';



class WindowManagerPlugin {

  static bool _isAlwaysOnTop = true;
  static bool get isPinned => _isAlwaysOnTop;
  
  static const Size _normalSize = Size(230, 275);
  static const Size _selectorSize = Size(400, 460);
  static const Size _miniSize = Size(150, 46);
  

  //: Initialization
  /// Initializes the window manager and sets up the main window.
  static Future<void> init() async {

    await windowManager.ensureInitialized();
    await windowManager.setMaximizable(false);

    const windowOptions = WindowOptions(
      title: 'Kurodesk',
      size: Size(230, 275),
      minimumSize: Size(200, 250),
      center: true,
      backgroundColor: Colors.transparent,
      alwaysOnTop: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMaximizable(false);
      await windowManager.setAsFrameless();
      await windowManager.setResizable(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }


  //: Always-On-Top
  /// Toggles the always-on-top state of the current window.
  static void toggleAlwaysOnTop() {
    _isAlwaysOnTop = !_isAlwaysOnTop;
    windowManager.setAlwaysOnTop(_isAlwaysOnTop);
  }


  //: Window Controls
  /// Minimizes the current window.
  static void minimize() {
    windowManager.minimize();
  }
  
  /// Closes the current window.
  static void close() {
    windowManager.close();
  }


  //: Change Window Size
  /// Sets the size of the current window.
  static void setSize(Size size, {bool animate = false}) {
    windowManager.setSize(size, animate: animate);
  }

  
  /// Sets the window to mini mode based on the group name.
  static Future<void> setMiniMode(String groupName) async {
    await windowManager.setOpacity(0.50);
    
    double width = (groupName.length * 16.0) + 20;

    await windowManager.setMinimumSize(Size(width, _miniSize.height));
    await windowManager.setSize(Size(width, _miniSize.height), animate: true);
  }


  /// Sets the window to selector mode.
  static Future<void> setSelectorMode() async {
    await windowManager.setOpacity(1.0);
    await windowManager.setSize(_selectorSize, animate: true);
  }


  /// Sets the window size based on the number of groups.
  static Future<void> setSizeBasedOnGroupCount(int currentGroupCount) async {
    double height = _normalSize.height;

    if (currentGroupCount > 1 && currentGroupCount <= 5){
      height = _normalSize.height + (currentGroupCount * 40);
    }
    else if (currentGroupCount > 5) {
      height = _normalSize.height + (5 * 40);
    }

    Size extraSize = Size(_normalSize.width, height);
    await windowManager.setSize(extraSize, animate: true);
    await windowManager.setOpacity(1.0);
  }

}