import 'package:flutter/material.dart';
import 'package:kurodesk/features/workspace/domain/entities/workspace_group.dart';

class GroupPillSelector extends StatelessWidget {
  final List<WorkspaceGroup> groups;
  final String? activeGroupId;
  final ValueChanged<String> onSelectGroup;
  final void Function(int oldIndex, int newIndex) onReorder;

  const GroupPillSelector({
    super.key,
    required this.groups,
    required this.activeGroupId,
    required this.onSelectGroup,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {

    double height = 48;

    if (groups.length > 1 && groups.length <= 5){
      height = 40 + (groups.length * 40);
    }
    else if (groups.length > 5) {
      height = 40 + (5 * 40);
    }

    return SizedBox(
      height: height,
      child: ReorderableListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        buildDefaultDragHandles: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: groups.length,
        onReorder: onReorder,
        proxyDecorator: (child, index, animation) => Material(
          color: Colors.transparent,
          child: child,
        ),
        itemBuilder: (context, index) {
          final group = groups[index];
          final isSelected = group.id == activeGroupId;

          return ReorderableDragStartListener(
            key: ValueKey(group.id),
            index: index,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: () => onSelectGroup(group.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  constraints: const BoxConstraints(minWidth: 68, minHeight: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1F1F1F) : const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.white70 : const Color(0xFF2E2E2E),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        group.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${group.windows.length}',
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.white30,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}