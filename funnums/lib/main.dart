import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_theme.dart';
import 'core/di.dart';
import 'core/routing.dart';
import 'features/difficulty/difficulty_screen.dart';
import 'features/gameplay/gameplay_screen.dart';
import 'features/gameplay/game_over_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    await Services.init();
    runApp(const FunnumsApp());
  });
}

class FunnumsApp extends StatelessWidget {
  const FunnumsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'funnums',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.difficulty,
      routes: {
        AppRoutes.difficulty: (_) => const DifficultyScreen(),
        AppRoutes.gameplay: (_) => const GameplayScreen(),
        AppRoutes.gameOver: (_) => const GameOverScreen(),
      },
    );
  }
}
