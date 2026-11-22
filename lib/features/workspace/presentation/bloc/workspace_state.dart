import 'package:equatable/equatable.dart';
import '../../domain/entities/window_info.dart';
import '../../domain/entities/workspace_group.dart';

class WorkspaceState extends Equatable {
  final List<WorkspaceGroup> groups;
  final String? activeGroupId;
  final List<WindowInfo> openWindows;

  const WorkspaceState({
    required this.groups,
    required this.activeGroupId,
    this.openWindows = const [],
  });

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
    List<WindowInfo>? openWindows,
  }) {
    return WorkspaceState(
      groups: groups ?? this.groups,
      activeGroupId: activeGroupId ?? this.activeGroupId,
      openWindows: openWindows ?? this.openWindows,
    );
  }

  @override
  List<Object?> get props => [groups, activeGroupId, openWindows];
}