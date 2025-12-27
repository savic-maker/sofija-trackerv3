import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../notifications/notification_service.dart';

enum LanguageChoice { system, sr, en }

class AppSettings extends ChangeNotifier {
  final NotificationService _notifications;
  AppSettings(this._notifications);

  ThemeMode themeMode = ThemeMode.system;
  LanguageChoice languageChoice = LanguageChoice.system;

  int feedIntervalHours = 3;
  int snoozeMinutes = 15;
  bool remindersEnabled = true;

  Locale? get localeOverride {
    switch (languageChoice) {
      case LanguageChoice.sr:
        return const Locale('sr');
      case LanguageChoice.en:
        return const Locale('en');
      case LanguageChoice.system:
        return null;
    }
  }

  Future<void> load() async {
    final box = Hive.box('app');
    final theme = box.get('themeMode') as String?;
    final lang = box.get('language') as String?;
    themeMode = theme == 'dark'
        ? ThemeMode.dark
        : theme == 'light'
            ? ThemeMode.light
            : ThemeMode.system;

    languageChoice = lang == 'sr'
        ? LanguageChoice.sr
        : lang == 'en'
            ? LanguageChoice.en
            : LanguageChoice.system;

    feedIntervalHours = (box.get('feedIntervalHours') as int?) ?? 3;
    snoozeMinutes = (box.get('snoozeMinutes') as int?) ?? 15;
    remindersEnabled = (box.get('remindersEnabled') as bool?) ?? true;

    // Sync reminders
    await _syncReminder();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final box = Hive.box('app');
    await box.put('themeMode', mode == ThemeMode.dark ? 'dark' : mode == ThemeMode.light ? 'light' : 'system');
    notifyListeners();
  }

  Future<void> setLanguage(LanguageChoice choice) async {
    languageChoice = choice;
    final box = Hive.box('app');
    await box.put('language', choice == LanguageChoice.sr ? 'sr' : choice == LanguageChoice.en ? 'en' : 'system');
    notifyListeners();
  }

  Future<void> setFeedIntervalHours(int hours) async {
    feedIntervalHours = hours.clamp(1, 24);
    await Hive.box('app').put('feedIntervalHours', feedIntervalHours);
    await _syncReminder();
    notifyListeners();
  }

  Future<void> setSnoozeMinutes(int minutes) async {
    snoozeMinutes = minutes.clamp(5, 120);
    await Hive.box('app').put('snoozeMinutes', snoozeMinutes);
    notifyListeners();
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    remindersEnabled = enabled;
    await Hive.box('app').put('remindersEnabled', remindersEnabled);
    await _syncReminder();
    notifyListeners();
  }

  Future<void> snoozeNow() async {
    if (!remindersEnabled) return;
    await _notifications.snooze(minutes: snoozeMinutes);
  }

  Future<void> _syncReminder() async {
    if (!remindersEnabled) {
      await _notifications.cancelAll();
      return;
    }
    await _notifications.scheduleNextFeedReminder(intervalHours: feedIntervalHours);
  }
}
