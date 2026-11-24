import 'package:material_ui/material_ui.dart';
import 'package:kurodesk/config/plugins/window_manager/window_manager.plugin.dart';
import 'package:kurodesk/config/plugins/window_manager/widgets/custom_drag_to_move_area.dart';

class KuroTopBar extends StatefulWidget {
  final VoidCallback onAddGroup;
  final VoidCallback onOpenSelector;
  final VoidCallback onMinimizeActive;
  final VoidCallback onToggleAutoMini;
  final bool isSelecting;
  final bool isAutoMiniEnabled;

  const KuroTopBar({
    super.key,
    required this.onOpenSelector,
    required this.isSelecting,
    required this.onAddGroup,
    required this.onMinimizeActive,
    required this.onToggleAutoMini,
    required this.isAutoMiniEnabled,
  });

  @override
  State<KuroTopBar> createState() => _KuroTopBarState();
}

class _KuroTopBarState extends State<KuroTopBar> {

  @override
  Widget build(BuildContext context) {

    double iconSpacing = 5;

    return CustomDragToMoveArea(
      child: Row(
        children: [
          _TopIcon(
            icon: Icons.fullscreen_exit,
            tooltip: 'Minimizar',
            onTap: () => widget.onMinimizeActive(),
          ),
          SizedBox(width: iconSpacing),
          _TopIcon(
            icon: Icons.tune_rounded,
            isActive: widget.isSelecting,
            tooltip: 'Asignar ventanas al grupo',
            onTap: widget.onOpenSelector,
          ),
          SizedBox(width: iconSpacing),
          _TopIcon(
            icon: Icons.auto_fix_high,
            isActive: widget.isAutoMiniEnabled,
            tooltip: 'Auto Mini',
            onTap: widget.onToggleAutoMini,
          ),

          const Spacer(),
          _TopIcon(
            icon: Icons.remove,
            tooltip: 'Minimizar',
            onTap: () => WindowManagerPlugin.minimize(),
          ),
          const SizedBox(width: 12),
          _TopIcon(
            icon: Icons.close,
            tooltip: 'Cerrar',
            onTap: () => WindowManagerPlugin.close(),
          ),
        ],
      ),
    );
  }
}


class _TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final String tooltip;

  const _TopIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}