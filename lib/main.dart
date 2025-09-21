import 'package:blue_art_mad2/routes/app_route.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CustomColors.loadThemes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlueArt',
      themeMode: ThemeMode.system,
      routes: AppRoute.routes,
      builder: (context, child) {
        final brightness = MediaQuery.of(context).platformBrightness;
        final bgColor = brightness == Brightness.dark
            ? CustomColors.getThemeColor(context, 'surface') 
            : CustomColors.getThemeColor(context, 'surface'); 

        return Container(
          color: bgColor,
          child: SafeArea(child: child!),
        );
      },
    );
  }
}
