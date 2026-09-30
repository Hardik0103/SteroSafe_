import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'data/local_storage/health_storage_service.dart';
import 'data/repositories/edge_vitals_repository.dart';
import 'data/repositories/edge_environment_repository.dart';
import 'data/repositories/edge_sos_repository.dart';
import 'presentation/providers/app_state.dart';
import 'presentation/screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize offline Qualcomm Edge-AI repositories
  final vitalsRepo = EdgeVitalsRepository();
  final environmentRepo = EdgeEnvironmentRepository();
  final sosRepo = EdgeSosRepository();
  final storageService = HealthStorageService();

  final appState = AppState(
    vitalsRepo: vitalsRepo,
    environmentRepo: environmentRepo,
    sosRepo: sosRepo,
    storageService: storageService,
  );

  runApp(HealthCompanionApp(state: appState));
}

class HealthCompanionApp extends StatelessWidget {
  final AppState state;

  const HealthCompanionApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainShell(state: state),
    );
  }
}
