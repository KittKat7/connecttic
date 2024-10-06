import 'package:connecttic/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import 'package:connecttic/lang/en_us.dart' as en_us;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Aspect.aspectWidth = 3;
  Aspect.aspectHeight = 4;
  setLangMap(en_us.en_us);
  AppTheme appTheme = AppTheme();
  runApp(ThemedWidget(
    widget: const MyApp(),
    theme: appTheme,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme.getThemeDataLight(context),
      darkTheme: appTheme.getThemeDataDark(context),
      themeMode: appTheme.getThemeMode(context),
      home: const HomeScreen(),
    );
  }
}
