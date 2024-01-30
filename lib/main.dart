import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insult_me/screens/on_boarding_screen.dart';
import 'package:insult_me/screens/quote_screen.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/data/latest.dart' as tz;

int? initScreen;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationService().initNotification();
  tz.initializeTimeZones();
  // InitScreen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  // End InitScreen
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insult Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      initialRoute: initScreen == 0 || initScreen == null
          ? const OnBoardingScreen().routeName
          : const QuoteScreen().routeName,
      routes: {
        const QuoteScreen().routeName: (context) => const QuoteScreen(),
        const OnBoardingScreen().routeName: (context) =>
            const OnBoardingScreen(),
      },
    );
  }
}
