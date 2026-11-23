import 'package:equatable/equatable.dart';
import '../../domain/entities/window_info.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object?> get props => [];
}

class RefreshOpenWindowsEvent extends WorkspaceEvent {}

class CreateWorkspaceGroupEvent extends WorkspaceEvent {}

class ActivateWorkspaceGroupEvent extends WorkspaceEvent {
  final String groupId;
  const ActivateWorkspaceGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class ToggleWindowInGroupEvent extends WorkspaceEvent {
  final WindowInfo window;
  const ToggleWindowInGroupEvent(this.window);

  @override
  List<Object?> get props => [window];
}

class MinimizeActiveGroupEvent extends WorkspaceEvent {}

class RestoreActiveGroupEvent extends WorkspaceEvent {}

class RenameWorkspaceGroupEvent extends WorkspaceEvent {
  final String groupId;
  final String newName;

  const RenameWorkspaceGroupEvent({
    required this.groupId,
    required this.newName,
  });

  @override
  List<Object?> get props => [groupId, newName];
}

class DeleteWorkspaceGroupEvent extends WorkspaceEvent {
  final String groupId;
  const DeleteWorkspaceGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class ReorderWorkspaceGroupsEvent extends WorkspaceEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderWorkspaceGroupsEvent({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class TogglePinWorkspaceGroupEvent extends WorkspaceEvent {
  final String groupId;
  const TogglePinWorkspaceGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class ToggleQuickSwitchEvent extends WorkspaceEvent {}