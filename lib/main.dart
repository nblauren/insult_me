import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insult_me/provider/daily_insult_provider.dart';
import 'package:insult_me/provider/local_insult_count_provider.dart';
import 'package:insult_me/screens/on_boarding_screen.dart';
import 'package:insult_me/screens/quote_screen.dart';
import 'package:insult_me/services/locator_service.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import the timezone library with an alias 'tz'
import 'package:timezone/data/latest.dart' as tz;

// Variable to store the initial screen value
int? initScreen;

// Entry point of the application
Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup Service Locator to manage dependencies
  await LocatorService.configureLocalModuleInjection();

  // Configure and display the native splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize notification service from the LocatorService
  await LocatorService.notificationService.initNotification();

  // Initialize time zones
  tz.initializeTimeZones();

  // Retrieve the initial screen value from shared preferences
  initScreen = await LocatorService.sharedPreferenceHelper.initScreen;

  //Initialize Notification Service
  await LocatorService.notificationService.initNotification();

  // Initialize Database Service
  await LocatorService.databaseService.initializeDatabase();

  // Initialise the local database
  await initialiseSql();

  // Retrieve new insults from Firebase
  await LocatorService.syncService.sync();

  // Remove native splash screen
  FlutterNativeSplash.remove();

  // Initialize the Sentry SDK for error reporting
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://dcedc6e03b1c6b4b6b831dcea34abdd4@o1346306.ingest.sentry.io/4506669873233920';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

// Function to initialize the database by importing quotes
Future<void> initialiseSql() async {
  if (initScreen == 0 || initScreen == null) {
    await LocatorService.initialQuotesService.importQuotes();
  }
}

// Main application class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provide instances of ChangeNotifier providers
      providers: [
        ChangeNotifierProvider(create: (context) => DailyInsultProvider()),
        ChangeNotifierProvider(create: (context) => LocalInsultCountProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Insult Me',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
        ),
        // Set initial route based on the initScreen value
        initialRoute: initScreen == 0 || initScreen == null
            ? const OnBoardingScreen().routeName
            : const QuoteScreen().routeName,
        // Define named routes for navigation
        routes: {
          const QuoteScreen().routeName: (context) => const QuoteScreen(),
          const OnBoardingScreen().routeName: (context) =>
              const OnBoardingScreen(),
        },
      ),
    );
  }
}
