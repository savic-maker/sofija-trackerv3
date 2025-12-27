import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'state/app_settings.dart';
import 'state/profile_store.dart';
import 'state/event_store.dart';
import 'ui/app_theme.dart';
import 'ui/shell.dart';
import 'core/hive_adapters.dart';
import 'notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerHiveAdapters();

  // Open core boxes
  await Hive.openBox('app'); // small key-value
  await Hive.openBox('profiles');
  await Hive.openBox('events'); // all profiles in one box, filtered by profileId

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings(notificationService)..load()),
        ChangeNotifierProvider(create: (_) => ProfileStore()..load()),
        ChangeNotifierProxyProvider<ProfileStore, EventStore>(
          create: (_) => EventStore(),
          update: (_, profiles, store) => (store!..setActiveProfileId(profiles.activeProfileId)),
        ),
      ],
      child: const BebaTrackerApp(),
    ),
  );
}

class BebaTrackerApp extends StatelessWidget {
  const BebaTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beba Tracker',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.localeOverride,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Shell(),
    );
  }
}
