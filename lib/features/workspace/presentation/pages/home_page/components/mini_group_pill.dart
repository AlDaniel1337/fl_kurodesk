import 'package:flutter/material.dart';
import 'package:kurodesk/config/plugins/window_manager/widgets/custom_drag_to_move_area.dart';

class MiniGroupPill extends StatelessWidget {
  final String groupName;
  final int windowCount;
  final VoidCallback onExpand;

  const MiniGroupPill({
    super.key,
    required this.groupName,
    required this.windowCount,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
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
      
        ],
      ),
    );
  }
}