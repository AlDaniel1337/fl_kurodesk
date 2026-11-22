import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/win32_window_datasource.dart';
import '../../domain/entities/workspace_group.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final Win32WindowDatasource _win32;

  WorkspaceBloc(this._win32)
      : super(const WorkspaceState(
          groups: [
            WorkspaceGroup(id: '1', name: 'A'),
          ],
          activeGroupId: '1',
        )) {
    on<RefreshOpenWindowsEvent>(_onRefreshWindows);
    on<CreateWorkspaceGroupEvent>(_onCreateGroup);
    on<ActivateWorkspaceGroupEvent>(_onActivateGroup);
    on<ToggleWindowInGroupEvent>(_onToggleWindow);
    on<MinimizeActiveGroupEvent>(_onMinimizeActive);
    on<RestoreActiveGroupEvent>(_onRestoreActive);
    on<RenameWorkspaceGroupEvent>(_onRenameGroup);
    on<DeleteWorkspaceGroupEvent>(_onDeleteGroup);
    on<ReorderWorkspaceGroupsEvent>(_onReorderGroups);
  }

  void _onRefreshWindows(RefreshOpenWindowsEvent event, Emitter<WorkspaceState> emit) {
    final windows = _win32.getOpenWindows();
    emit(state.copyWith(openWindows: windows));
  }

  void _onCreateGroup(CreateWorkspaceGroupEvent event, Emitter<WorkspaceState> emit) {
    final nextIndex = state.groups.length;
    final letter = String.fromCharCode(65 + (nextIndex % 26));
    final newGroup = WorkspaceGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: letter,
    );
    emit(state.copyWith(
      groups: [...state.groups, newGroup],
      activeGroupId: newGroup.id,
    ));
  }

  void _onActivateGroup(ActivateWorkspaceGroupEvent event, Emitter<WorkspaceState> emit) {
    final cleanedGroups = _purgeClosedWindows(state.groups);
    final target = cleanedGroups.firstWhere((g) => g.id == event.groupId);
    final targetHwnds = target.windows.map((w) => w.hwnd).toSet();

    // Minimizar ventanas de los demás grupos (si no están compartidas con el activo)
    for (final group in cleanedGroups) {
      if (group.id == target.id) continue;
      for (final win in group.windows) {
        if (!targetHwnds.contains(win.hwnd)) {
          _win32.minimizeWindow(win.hwnd);
        }
      }
    }

    // Restaurar y traer al frente las ventanas del grupo seleccionado
    for (final win in target.windows) {
      _win32.restoreAndFocusWindow(win.hwnd);
    }

    emit(state.copyWith(groups: cleanedGroups, activeGroupId: target.id));
  }

  void _onToggleWindow(ToggleWindowInGroupEvent event, Emitter<WorkspaceState> emit) {
    final active = state.activeGroup;
    if (active == null) return;

    final exists = active.windows.any((w) => w.hwnd == event.window.hwnd);
    final updatedWindows = exists
        ? active.windows.where((w) => w.hwnd != event.window.hwnd).toList()
        : [...active.windows, event.window];

    final updatedGroups = state.groups
        .map((g) => g.id == active.id ? g.copyWith(windows: updatedWindows) : g)
        .toList();

    emit(state.copyWith(groups: updatedGroups));
  }

  void _onMinimizeActive(MinimizeActiveGroupEvent event, Emitter<WorkspaceState> emit) {
    final active = state.activeGroup;
    if (active == null) return;
    for (final win in active.windows) {
      _win32.minimizeWindow(win.hwnd);
    }
  }

  void _onRestoreActive(RestoreActiveGroupEvent event, Emitter<WorkspaceState> emit) {
    final active = state.activeGroup;
    if (active == null) return;
    for (final win in active.windows) {
      _win32.restoreAndFocusWindow(win.hwnd);
    }
  }

  List<WorkspaceGroup> _purgeClosedWindows(List<WorkspaceGroup> groups) {
    return groups.map((g) {
      final valid = g.windows.where((w) => _win32.isWindowValid(w.hwnd)).toList();
      return g.copyWith(windows: valid);
    }).toList();
  }

  void _onRenameGroup(RenameWorkspaceGroupEvent event, Emitter<WorkspaceState> emit) {
    final trimmed = event.newName.trim();
    if (trimmed.isEmpty) return;

    final updatedGroups = state.groups.map((g) {
      return g.id == event.groupId ? g.copyWith(name: trimmed) : g;
    }).toList();

    emit(state.copyWith(groups: updatedGroups));
  }

  void _onDeleteGroup(DeleteWorkspaceGroupEvent event, Emitter<WorkspaceState> emit) {
    if (state.groups.length <= 1) return; // Siempre conservamos al menos 1 grupo

    final index = state.groups.indexWhere((g) => g.id == event.groupId);
    if (index == -1) return;

    final updatedGroups = List<WorkspaceGroup>.from(state.groups)..removeAt(index);
    final nextActiveId = state.activeGroupId == event.groupId
        ? updatedGroups[(index - 1).clamp(0, updatedGroups.length - 1)].id
        : state.activeGroupId;

    emit(state.copyWith(groups: updatedGroups, activeGroupId: nextActiveId));
  }

  void _onReorderGroups(ReorderWorkspaceGroupsEvent event, Emitter<WorkspaceState> emit) {
    var newIndex = event.newIndex;
    if (event.oldIndex < newIndex) {
      newIndex -= 1;
    }
    final updatedGroups = List<WorkspaceGroup>.from(state.groups);
    final item = updatedGroups.removeAt(event.oldIndex);
    updatedGroups.insert(newIndex, item);

    emit(state.copyWith(groups: updatedGroups));
  }
}