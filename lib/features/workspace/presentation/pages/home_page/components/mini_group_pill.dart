import 'package:flutter/material.dart';
import 'package:kurodesk/config/plugins/window_manager/widgets/custom_drag_to_move_area.dart';
import 'package:kurodesk/features/workspace/domain/entities/workspace_group.dart';

class MiniGroupPill extends StatelessWidget {
  final String groupName;
  final int windowCount;
  final ({WorkspaceGroup group, bool isReturning})? quickTarget;
  final VoidCallback onExpand;
  final VoidCallback onQuickSwitch;

  const MiniGroupPill({
    super.key,
    required this.groupName,
    required this.windowCount,
    required this.quickTarget,
    required this.onExpand,
    required this.onQuickSwitch,
  });

  @override
  Widget build(BuildContext context) {

    final target = quickTarget;
    final accentColor = target?.isReturning == true
        ? const Color(0xFFFFB74D) // Ámbar: regresar al grupo anterior
        : const Color(0xFF64B5F6); // Azul: saltar al grupo fijado

    return CustomDragToMoveArea(
      child: Stack(
        children: [
      
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: onExpand,
              ),
            ),
          ),
      
          Center(
            child: Text(
              groupName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          if (target != null) ...[
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    target.isReturning
                      ? Icons.undo_rounded
                      : Icons.push_pin_rounded,
                    size: 12,
                    color: accentColor,
                  ),
                  onPressed: onQuickSwitch,
                ),
              ),
            ),
          ],
      
        ],
      ),
    );
  }
}