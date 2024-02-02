import 'package:get_it/get_it.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/device_info_service.dart';
import 'package:insult_me/services/firestore_service.dart';
import 'package:insult_me/services/initial_quotes_service.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:insult_me/services/sync_service.dart';
import 'package:insult_me/utils/shared_preferences_helper.dart';
import 'package:insult_me/widgets/snackbar_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service locator class to manage and retrieve various services.
class LocatorService {
  static final GetIt getIt = GetIt.instance;

  /// Registers all the singleton services.
  static Future<void> configureLocalModuleInjection() async {
    // Register SharedPreferences as a singleton asynchronously
    getIt.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);

    // Create an instance of SharedPreferenceHelper using the asynchronously retrieved SharedPreferences instance
    getIt.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(
        await getIt.getAsync<SharedPreferences>(),
      ),
    );

    // Register NotificationService as a singleton
    getIt.registerSingleton<NotificationService>(
      NotificationService(),
    );

    // Register DatabaseService as a singleton
    getIt.registerSingleton<DatabaseService>(
      DatabaseService(),
    );

    // Register FirestoreService as a singleton
    getIt.registerSingleton<FirestoreService>(
      FirestoreService(),
    );

    // Register InitialQuotesService as a singleton
    getIt.registerSingleton<InitialQuotesService>(
      InitialQuotesService(databaseService: getIt<DatabaseService>()),
    );

    // Register SyncService as a singleton
    getIt.registerSingleton<SyncService>(
      SyncService(
          databaseService: getIt<DatabaseService>(),
          firestoreService: getIt<FirestoreService>()),
    );

    // Register DeviceInfoService as a singleton
    getIt.registerSingleton<DeviceInfoService>(
      DeviceInfoService(),
    );

    // Register DeviceInfoService as a singleton
    getIt.registerSingleton<SnackbarService>(
      SnackbarService(),
    );
  }

  /// Getter for SharedPreferences instance.
  static SharedPreferences get sharedPreferences => getIt<SharedPreferences>();

  /// Getter for SharedPreferenceHelper instance.
  static SharedPreferenceHelper get sharedPreferenceHelper =>
      getIt<SharedPreferenceHelper>();

  /// Getter for NotificationService instance.
  static NotificationService get notificationService =>
      getIt<NotificationService>();

  /// Getter for DatabaseService instance.
  static DatabaseService get databaseService => getIt<DatabaseService>();

  /// Getter for FirestoreService instance.
  static FirestoreService get firestoreService => getIt<FirestoreService>();

  /// Getter for InitialQuotesService instance.
  static InitialQuotesService get initialQuotesService =>
      getIt<InitialQuotesService>();

  /// Getter for SyncService instance.
  static SyncService get syncService => getIt<SyncService>();

  /// Getter for DeviceInfoService instance.
  static DeviceInfoService get deviceInfoService => getIt<DeviceInfoService>();

  /// Getter for DeviceInfoService instance.
  static SnackbarService get snackbarService => getIt<SnackbarService>();
}
