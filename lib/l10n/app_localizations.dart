import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
  ];

  String get localeName => locale.languageCode;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _values = {
    'en': {
  "appTitle": "Beba Tracker",
  "navHome": "Home",
  "navLog": "Log",
  "navAnalytics": "Analytics",
  "navProfiles": "Profiles",
  "langSystem": "System",
  "langSerbian": "Serbian",
  "langEnglish": "English",
  "activeProfileLabel": "Active profile",
  "activeProfileHint": "Select the baby profile you want to track.",
  "change": "Change",
  "quickActions": "Quick actions",
  "actionWet": "Wet diaper",
  "actionWetSub": "Log a wet diaper",
  "actionStool": "Stool",
  "actionStoolSub": "Log stool + color",
  "actionFeed": "Feeding",
  "actionFeedSub": "Breast / bottle / notes",
  "actionReminder": "Reminder",
  "actionReminderSub": "Every 3 hours (customizable)",
  "todaySummary": "Today summary",
  "summaryWet": "Wet diapers",
  "summaryStool": "Stools",
  "summaryFeeds": "Feedings",
  "noteDemo": "This is a redesigned UI starter (v2). Data storage, reminders, and charts hook in next.",
  "logAddTitle": "Add an entry",
  "logAddHint": "Tap to log events. Time is auto-filled; you can edit.",
  "recentEvents": "Recent events",
  "recentEventsEmpty": "No entries yet",
  "recentEventsEmptySub": "Your recent diapers/feedings will show here.",
  "analyticsHint": "Weekly charts will appear here (wet/stool/feeding trends).",
  "add": "Add",
  "profilesEmptyTitle": "No profiles yet",
  "profilesEmptySub": "Create a baby profile to start tracking.",
  "navAdd": "Add",
  "dashboardTitle": "Dashboard",
  "today": "Today",
  "thisWeek": "This week",
  "wetDiapers": "Wet diapers",
  "stools": "Stools",
  "feeds": "Feedings",
  "nextReminder": "Next reminder",
  "snoozeNow": "Snooze now",
  "addEventTitle": "New entry",
  "eventType": "Type",
  "eventFeed": "Feeding",
  "eventWet": "Wet diaper",
  "eventStool": "Stool",
  "timeLabel": "Time",
  "dateLabel": "Date",
  "amountMl": "Amount (ml)",
  "durationMin": "Duration (min)",
  "breastSide": "Breast",
  "sideLeft": "Left",
  "sideRight": "Right",
  "sideBoth": "Both",
  "sideNone": "None/Other",
  "stoolColor": "Stool color",
  "colorYellow": "Yellow",
  "colorMustard": "Mustard",
  "colorGreen": "Green",
  "colorBrown": "Brown",
  "colorBlack": "Black",
  "colorRed": "Red",
  "colorWhite": "White",
  "colorOther": "Other",
  "note": "Note",
  "save": "Save",
  "saved": "Saved",
  "recentEntries": "Recent entries",
  "delete": "Delete",
  "deleteConfirmTitle": "Delete entry?",
  "deleteConfirmBody": "This entry will be permanently removed.",
  "cancel": "Cancel",
  "settings": "Settings",
  "reminders": "Reminders",
  "enableReminders": "Enable feeding reminders",
  "intervalHours": "Interval (hours)",
  "snoozeMinutes": "Snooze (minutes)",
  "language": "Language",
  "theme": "Theme",
  "system": "System",
  "light": "Light",
  "dark": "Dark",
  "analyticsTitle": "Weekly analytics",
  "last7Days": "Last 7 days",
  "noProfile": "No profile yet",
  "createProfile": "Create profile",
  "profileName": "Profile name",
  "birthDate": "Birth date (optional)",
  "selectProfile": "Select profile"
},
    'sr': {
  "appTitle": "Beba Tracker",
  "navHome": "Početna",
  "navLog": "Unos",
  "navAnalytics": "Analitika",
  "navProfiles": "Profili",
  "langSystem": "Sistem",
  "langSerbian": "Srpski",
  "langEnglish": "Engleski",
  "activeProfileLabel": "Aktivni profil",
  "activeProfileHint": "Izaberi profil bebe koju pratiš.",
  "change": "Promeni",
  "quickActions": "Brze radnje",
  "actionWet": "Mokra pelena",
  "actionWetSub": "Upiši mokru pelenu",
  "actionStool": "Stolica",
  "actionStoolSub": "Upiši stolicu + boju",
  "actionFeed": "Hranjenje",
  "actionFeedSub": "Dojenje / flašica / napomena",
  "actionReminder": "Podsetnik",
  "actionReminderSub": "Na 3 sata (podesivo)",
  "todaySummary": "Današnji zbir",
  "summaryWet": "Mokre pelene",
  "summaryStool": "Stolice",
  "summaryFeeds": "Hranjenja",
  "noteDemo": "Ovo je početna (v2) verzija lepšeg dizajna. Skladištenje, podsetnici i grafikoni se povezuju u sledećem koraku.",
  "logAddTitle": "Dodaj unos",
  "logAddHint": "Klikni da uneseš događaj. Vreme se automatski popunjava; možeš izmeniti.",
  "recentEvents": "Poslednji unosi",
  "recentEventsEmpty": "Još nema unosa",
  "recentEventsEmptySub": "Ovde će se prikazivati poslednje pelene/hranenja.",
  "analyticsHint": "Ovde će biti nedeljni grafikoni (trendovi pelena/hranenja).",
  "add": "Dodaj",
  "profilesEmptyTitle": "Nema profila",
  "profilesEmptySub": "Kreiraj profil bebe da bi počeo praćenje.",
  "navAdd": "Unos",
  "dashboardTitle": "Pregled",
  "today": "Danas",
  "thisWeek": "Ove nedelje",
  "wetDiapers": "Mokre pelene",
  "stools": "Stolice",
  "feeds": "Hranjenja",
  "nextReminder": "Sledeći podsetnik",
  "snoozeNow": "Odgodi (snooze)",
  "addEventTitle": "Novi unos",
  "eventType": "Tip",
  "eventFeed": "Hranjenje",
  "eventWet": "Mokra pelena",
  "eventStool": "Stolica",
  "timeLabel": "Vreme",
  "dateLabel": "Datum",
  "amountMl": "Količina (ml)",
  "durationMin": "Trajanje (min)",
  "breastSide": "Dojka",
  "sideLeft": "Leva",
  "sideRight": "Desna",
  "sideBoth": "Obe",
  "sideNone": "Nije/Drugo",
  "stoolColor": "Boja stolice",
  "colorYellow": "Žuta",
  "colorMustard": "Senf",
  "colorGreen": "Zelena",
  "colorBrown": "Braon",
  "colorBlack": "Crna",
  "colorRed": "Crvena",
  "colorWhite": "Bela",
  "colorOther": "Drugo",
  "note": "Napomena",
  "save": "Sačuvaj",
  "saved": "Sačuvano",
  "recentEntries": "Skorašnji unosi",
  "delete": "Obriši",
  "deleteConfirmTitle": "Obrisati unos?",
  "deleteConfirmBody": "Ovaj unos će biti trajno obrisan.",
  "cancel": "Otkaži",
  "settings": "Podešavanja",
  "reminders": "Podsetnici",
  "enableReminders": "Uključi podsetnik za hranjenje",
  "intervalHours": "Interval (sati)",
  "snoozeMinutes": "Snooze (min)",
  "language": "Jezik",
  "theme": "Tema",
  "system": "Sistemski",
  "light": "Svetla",
  "dark": "Tamna",
  "analyticsTitle": "Nedeljna analitika",
  "last7Days": "Poslednjih 7 dana",
  "noProfile": "Nema profila",
  "createProfile": "Napravi profil",
  "profileName": "Ime profila",
  "birthDate": "Datum rođenja (opciono)",
  "selectProfile": "Izaberi profil"
},
  };

  String _t(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;

  String get appTitle => _t('appTitle');
  String get navHome => _t('navHome');
  String get navAdd => _t('navAdd');
  String get navAnalytics => _t('navAnalytics');
  String get navProfiles => _t('navProfiles');
  String get navLog => _t('navLog');

  String get langSystem => _t('langSystem');
  String get langSerbian => _t('langSerbian');
  String get langEnglish => _t('langEnglish');

  String get dashboardTitle => _t('dashboardTitle');
  String get today => _t('today');
  String get thisWeek => _t('thisWeek');
  String get wetDiapers => _t('wetDiapers');
  String get stools => _t('stools');
  String get feeds => _t('feeds');
  String get nextReminder => _t('nextReminder');
  String get snoozeNow => _t('snoozeNow');

  String get addEventTitle => _t('addEventTitle');
  String get eventType => _t('eventType');
  String get eventFeed => _t('eventFeed');
  String get eventWet => _t('eventWet');
  String get eventStool => _t('eventStool');
  String get timeLabel => _t('timeLabel');
  String get dateLabel => _t('dateLabel');

  String get amountMl => _t('amountMl');
  String get durationMin => _t('durationMin');
  String get breastSide => _t('breastSide');
  String get sideLeft => _t('sideLeft');
  String get sideRight => _t('sideRight');
  String get sideBoth => _t('sideBoth');
  String get sideNone => _t('sideNone');

  String get stoolColor => _t('stoolColor');
  String get colorYellow => _t('colorYellow');
  String get colorMustard => _t('colorMustard');
  String get colorGreen => _t('colorGreen');
  String get colorBrown => _t('colorBrown');
  String get colorBlack => _t('colorBlack');
  String get colorRed => _t('colorRed');
  String get colorWhite => _t('colorWhite');
  String get colorOther => _t('colorOther');

  String get note => _t('note');
  String get save => _t('save');
  String get saved => _t('saved');
  String get recentEntries => _t('recentEntries');

  String get delete => _t('delete');
  String get deleteConfirmTitle => _t('deleteConfirmTitle');
  String get deleteConfirmBody => _t('deleteConfirmBody');
  String get cancel => _t('cancel');

  String get settings => _t('settings');
  String get reminders => _t('reminders');
  String get enableReminders => _t('enableReminders');
  String get intervalHours => _t('intervalHours');
  String get snoozeMinutes => _t('snoozeMinutes');

  String get language => _t('language');
  String get theme => _t('theme');
  String get system => _t('system');
  String get light => _t('light');
  String get dark => _t('dark');

  String get analyticsTitle => _t('analyticsTitle');
  String get last7Days => _t('last7Days');

  String get noProfile => _t('noProfile');
  String get createProfile => _t('createProfile');
  String get profileName => _t('profileName');
  String get birthDate => _t('birthDate');
  String get selectProfile => _t('selectProfile');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'sr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
