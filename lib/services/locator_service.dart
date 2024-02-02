import 'package:get_it/get_it.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/device_info_service.dart';
import 'package:insult_me/services/firestore_service.dart';
import 'package:insult_me/services/initial_quotes_service.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:insult_me/services/sync_service.dart';

/// A service locator class to manage and retrieve various services.
class LocatorService {
  final GetIt _getIt = GetIt.instance;

  /// Registers all the singleton services.
  void setup() {
    _getIt.registerSingleton<NotificationService>(NotificationService());
    _getIt.registerSingleton<DatabaseService>(DatabaseService());
    _getIt.registerSingleton<FirestoreService>(FirestoreService());
    _getIt.registerSingleton<InitialQuotesService>(InitialQuotesService());
    _getIt.registerSingleton<SyncService>(SyncService());
    _getIt.registerSingleton<DeviceInfoService>(DeviceInfoService());
  }

  /// Retrieves the [NotificationService] instance.
  NotificationService get notificationService => _getIt<NotificationService>();

  /// Retrieves the [DatabaseService] instance.
  DatabaseService get databaseService => _getIt<DatabaseService>();

  /// Retrieves the [FirestoreService] instance.
  FirestoreService get firestoreService => _getIt<FirestoreService>();

  /// Retrieves the [InitialQuotesService] instance.
  InitialQuotesService get initialQuotesService =>
      _getIt<InitialQuotesService>();

  /// Retrieves the [SyncService] instance.
  SyncService get syncService => _getIt<SyncService>();

  /// Retrieves the [SyncService] instance.
  DeviceInfoService get deviceInfoService => _getIt<DeviceInfoService>();
}
