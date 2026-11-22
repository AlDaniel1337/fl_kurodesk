import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kurodesk/features/workspace/data/datasources/win32_window_datasource.dart';
import 'package:kurodesk/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:kurodesk/features/workspace/presentation/pages/home_page/home_page.dart';
import 'package:material_ui/material_ui.dart';
import 'config/plugins/window_manager/window_manager.plugin.dart';
import 'core/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManagerPlugin.init();

  runApp(const KurodeskApp());
}


class KurodeskApp extends StatelessWidget {
  const KurodeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkspaceBloc(Win32WindowDatasource()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kurodesk',
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}