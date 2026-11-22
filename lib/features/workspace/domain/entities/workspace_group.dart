import 'package:equatable/equatable.dart';
import 'window_info.dart';

class WorkspaceGroup extends Equatable {
  /// Identificador único del grupo de ventanas
  final String id;
  /// Nombre del grupo de ventanas
  final String name;
  /// Lista de ventanas pertenecientes al grupo
  final List<WindowInfo> windows;

  const WorkspaceGroup({
    required this.id,
    required this.name,
    this.windows = const [],
  });

  WorkspaceGroup copyWith({
    String? id,
    String? name,
    List<WindowInfo>? windows,
  }) {
    return WorkspaceGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      windows: windows ?? this.windows,
    );
  }

  @override
  List<Object?> get props => [id, name, windows];
}