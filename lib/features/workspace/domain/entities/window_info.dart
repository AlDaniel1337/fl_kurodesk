import 'package:equatable/equatable.dart';

class WindowInfo extends Equatable {

  /// Identificador único de la ventana en Windows
  final int hwnd; 
  /// Título de la barra (ej. "personaje.blend - Blender")
  final String title; 
  /// Nombre del ejecutable (ej. "blender.exe")
  final String processName; 
  /// Indica si la ventana está minimizada
  final bool isMinimized;

  const WindowInfo({
    required this.hwnd,
    required this.title,
    required this.processName,
    required this.isMinimized,
  });

  @override
  List<Object?> get props => [hwnd, title, processName, isMinimized];
}