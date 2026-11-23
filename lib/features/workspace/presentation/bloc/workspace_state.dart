import 'package:equatable/equatable.dart';
import '../../domain/entities/window_info.dart';
import '../../domain/entities/workspace_group.dart';

class WorkspaceState extends Equatable {
  final List<WorkspaceGroup> groups;
  final String? activeGroupId;
  final String? pinnedGroupId;
  final String? previousGroupId;
  final List<WindowInfo> openWindows;

  const WorkspaceState({
    required this.groups,
    required this.activeGroupId,
    this.pinnedGroupId,
    this.previousGroupId,
    this.openWindows = const [],
  });

  WorkspaceGroup? get pinnedGroup => _findById(pinnedGroupId);
  WorkspaceGroup? get previousGroup => _findById(previousGroupId);

  /// Devuelve el destino del botón rápido y si corresponde a un regreso
  ({WorkspaceGroup group, bool isReturning})? get quickSwitchTarget {
    if (pinnedGroupId != null && activeGroupId == pinnedGroupId) {
      final prev = previousGroup;
      if (prev != null && prev.id != activeGroupId) {
        return (group: prev, isReturning: true);
      }
    }
    final pinned = pinnedGroup;
    if (pinned != null && pinned.id != activeGroupId) {
      return (group: pinned, isReturning: false);
    }
    return null;
  }

  WorkspaceGroup? _findById(String? id) {
    if (id == null) return null;
    try {
      return groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  WorkspaceGroup? get activeGroup {
    if (groups.isEmpty) return null;
    return groups.firstWhere(
      (g) => g.id == activeGroupId,
      orElse: () => groups.first,
    );
  }

  int get activeIndex {
    final active = activeGroup;
    if (active == null) return 0;
    return groups.indexWhere((g) => g.id == active.id);
  }
WorkspaceState copyWith({
    List<WorkspaceGroup>? groups,
    String? activeGroupId,
    String? pinnedGroupId,
    bool clearPinned = false,
    String? previousGroupId,
    bool clearPrevious = false,
    List<WindowInfo>? openWindows,
  }) {
    return WorkspaceState(
      groups: groups ?? this.groups,
      activeGroupId: activeGroupId ?? this.activeGroupId,
      pinnedGroupId: clearPinned ? null : (pinnedGroupId ?? this.pinnedGroupId),
      previousGroupId: clearPrevious ? null : (previousGroupId ?? this.previousGroupId),
      openWindows: openWindows ?? this.openWindows,
    );
  }

  @override
  List<Object?> get props => [
        groups,
        activeGroupId,
        pinnedGroupId,
        previousGroupId,
        openWindows,
      ];
}