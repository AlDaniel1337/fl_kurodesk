import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kurodesk/config/plugins/window_manager/window_manager.plugin.dart';
import 'package:kurodesk/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:kurodesk/features/workspace/presentation/bloc/workspace_event.dart';
import 'package:kurodesk/features/workspace/presentation/bloc/workspace_state.dart';
import 'package:kurodesk/features/workspace/presentation/pages/home_page/components/components.index.dart';
import 'package:kurodesk/features/workspace/presentation/widgets/editable_group_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {

  bool _isSelecting = false;
  bool _isMini = false;
  String groupName = 'A';


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> _setMiniMode() async {
    setState(() => _isMini = true);
    await WindowManagerPlugin.setMiniMode(groupName);
  }

  Future<void> _setNormalMode() async {
    setState(() => _isMini = false);
    _onGroupsChange(context.read<WorkspaceBloc>().state.groups.length);
  }
  
  Future<void> _onGroupsChange( int currentGroupCount ) async {
    await WindowManagerPlugin.setSizeBasedOnGroupCount(currentGroupCount);
  }

  Future<void> _toggleSelector(BuildContext context) async {
    final next = !_isSelecting;
    setState(() {
      _isSelecting = next;
      _isMini = false;
    });
    if (next) {
      context.read<WorkspaceBloc>().add(RefreshOpenWindowsEvent());
      await WindowManagerPlugin.setSelectorMode();
    } else {
      _onGroupsChange(context.read<WorkspaceBloc>().state.groups.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(160, 0, 0, 0),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isMini ? const Color(0xFF333333) : const Color(0xFF222222),
              width: 1,
            ),
          ),
        
          child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
            builder: (context, state) {
              final activeGroup = state.activeGroup;
              final bloc = context.read<WorkspaceBloc>();
              final groups = state.groups;
              groupName = state.activeGroup?.name ?? '';

              if (_isMini) {
                return MiniGroupPill(
                  key: const ValueKey('mini'),
                  groupName: groupName,
                  windowCount: activeGroup?.windows.length ?? 0,
                  onExpand: () => _setNormalMode(),
                  onQuickSwitch: () => bloc.add(ToggleQuickSwitchEvent()),
                  quickTarget: state.quickSwitchTarget,
                );
              }
        
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 4),
                child: _ExpandedContent(
                    key: const ValueKey('expanded'),
                    state: state,
                    isSelecting: _isSelecting,
                    onAddGroup: () {
                      _onGroupsChange(groups.length + 1);
                      bloc.add(CreateWorkspaceGroupEvent());
                    },
                    onToggleSelector: () => _toggleSelector(context),
                    onSelectGroup: (id) => bloc.add(ActivateWorkspaceGroupEvent(id)),
                    onToggleWindow: (w) => bloc.add(ToggleWindowInGroupEvent(w)),
                    onRefresh: () => bloc.add(RefreshOpenWindowsEvent()),
                    onMinimizeActive: () => _setMiniMode(),
                    onDeleteGroup: () {
                      final activeGroup = state.activeGroup;
                      if (activeGroup != null && state.groups.length > 1) {
                        _onGroupsChange(groups.length - 1);
                        context.read<WorkspaceBloc>().add(DeleteWorkspaceGroupEvent(activeGroup.id));
                      }
                    },
                    onTogglePin: (id) => bloc.add(TogglePinWorkspaceGroupEvent(id)),
                    pinnedGroupId: state.pinnedGroup?.id,
                  ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  final WorkspaceState state;
  final bool isSelecting;
  final VoidCallback onAddGroup;
  final VoidCallback onToggleSelector;
  final ValueChanged<String> onSelectGroup;
  final ValueChanged<dynamic> onToggleWindow;
  final VoidCallback onRefresh;
  final VoidCallback onMinimizeActive;
  final VoidCallback onDeleteGroup;
  final ValueChanged<String> onTogglePin;
  final String? pinnedGroupId;

  const _ExpandedContent({
    super.key,
    required this.state,
    required this.isSelecting,
    required this.onAddGroup,
    required this.onToggleSelector,
    required this.onSelectGroup,
    required this.onToggleWindow,
    required this.onRefresh,
    required this.onMinimizeActive,
    required this.onDeleteGroup,
    required this.pinnedGroupId,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final activeGroup = state.activeGroup;
    
    return Localizations.override(
      context: context,
      delegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      child: Column(
        children: [
          KuroTopBar(
            isSelecting: isSelecting,
            onOpenSelector: onToggleSelector,
            onAddGroup: onAddGroup,
            onMinimizeActive: onMinimizeActive,
          ),
          if (isSelecting && activeGroup != null)
            WindowSelectorView(
              groupName: activeGroup.name,
              availableWindows: state.openWindows,
              selectedHwnds: activeGroup.windows.map((w) => w.hwnd).toSet(),
              onToggleWindow: (win) => onToggleWindow(win),
              onRefresh: onRefresh,
              onDone: onToggleSelector,
            )
          else ...[
            //: Title of the active group or placeholder text if no group is active
            const Spacer(),
            if (activeGroup != null)
              EditableGroupTitle(
                title: activeGroup.name,
                onSubmitted: (newName) => context.read<WorkspaceBloc>().add(
                  RenameWorkspaceGroupEvent(
                    groupId: activeGroup.id,
                    newName: newName,
                  ),
                ),
              )
            else
              const Text(
                'SIN GRUPO',
                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 14),

            GroupPillSelector(
              groups: state.groups,
              activeGroupId: activeGroup?.id,
              onSelectGroup: onSelectGroup,
              onReorder: (oldIndex, newIndex) => context.read<WorkspaceBloc>().add(
                ReorderWorkspaceGroupsEvent(oldIndex: oldIndex, newIndex: newIndex),
              ),
              onTogglePin: onTogglePin,
              pinnedGroupId: pinnedGroupId,
            ),
            const Spacer(),
            
            _BottomControls(
              countText: '${state.activeIndex + 1} / ${state.groups.length}',
              onDeleteGroup: onDeleteGroup,
              onAddGroup: onAddGroup,
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final String countText;
  final VoidCallback onDeleteGroup;
  final VoidCallback onAddGroup;

  const _BottomControls({
    required this.countText,
    required this.onDeleteGroup,
    required this.onAddGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleBtn(
            tooltip: 'Eliminar grupo',
            icon: Icons.delete, 
            onTap: onDeleteGroup
          ),
          Text(countText, style: const TextStyle(color: Colors.white54, fontSize: 13)),          
          _CircleBtn(
            tooltip: 'Agregar grupo',
            icon: Icons.add_box_outlined,
            onTap: onAddGroup,
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final String? tooltip;

  const _CircleBtn({
    required this.icon, 
    required this.onTap, 
    this.tooltip, 
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: Color(0xFF1C1C1C), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}