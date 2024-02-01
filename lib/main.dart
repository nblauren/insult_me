import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insult_me/screens/on_boarding_screen.dart';
import 'package:insult_me/screens/quote_screen.dart';
import 'package:insult_me/services/initial_quotes_service.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:timezone/data/latest.dart' as tz;

int? initScreen;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  // InitScreen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  // End InitScreen
  FlutterNativeSplash.remove();
  await initialiseSql();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://dcedc6e03b1c6b4b6b831dcea34abdd4@o1346306.ingest.sentry.io/4506669873233920';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

Future<void> initialiseSql() async {
  if (initScreen == 0 || initScreen == null) {
    await InitialiseDatabaseService.importQuotes();
  }
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
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
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
