import 'package:material_ui/material_ui.dart';
import 'package:window_manager/window_manager.dart';

class CustomDragToMoveArea extends StatelessWidget {

  final Widget child;
  
  const CustomDragToMoveArea({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}