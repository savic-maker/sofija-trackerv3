import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/profile_store.dart';
import '../../state/app_settings.dart';

class ProfilesPage extends StatelessWidget {
  final bool showCreateHint;
  const ProfilesPage({super.key, this.showCreateHint = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final store = context.watch<ProfileStore>();
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navProfiles),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProfileDialog(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.createProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (showCreateHint)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(l10n.noProfile),
              ),
            ),
          const SizedBox(height: 8),
          ...store.profiles.map((p) {
            final selected = p.id == store.activeProfileId;
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(p.name.isEmpty ? '?' : p.name[0].toUpperCase())),
                title: Text(p.name),
                subtitle: p.birthDate == null ? null : Text('${l10n.birthDate}: ${_fmtDate(p.birthDate!)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected) const Icon(Icons.check_circle),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(context, p.id),
                    ),
                  ],
                ),
                onTap: () => store.setActive(p.id),
              ),
            );
          }),
          const SizedBox(height: 24),
          Text(l10n.settings, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.language),
                  subtitle: Text(_langLabel(l10n, settings.languageChoice)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openLanguage(context),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.theme),
                  subtitle: Text(_themeLabel(l10n, settings.themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openTheme(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2,'0')}.${d.month.toString().padLeft(2,'0')}.${d.year}';

  String _langLabel(AppLocalizations l10n, LanguageChoice c) {
    switch (c) {
      case LanguageChoice.system: return l10n.langSystem;
      case LanguageChoice.sr: return l10n.langSerbian;
      case LanguageChoice.en: return l10n.langEnglish;
    }
  }

  String _themeLabel(AppLocalizations l10n, ThemeMode m) {
    switch (m) {
      case ThemeMode.system: return l10n.system;
      case ThemeMode.light: return l10n.light;
      case ThemeMode.dark: return l10n.dark;
    }
  }

  Future<void> _createProfileDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController();
    DateTime? birth;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.createProfile),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.profileName),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => birth = picked);
                },
                icon: const Icon(Icons.cake_outlined),
                label: Text(birth == null ? l10n.birthDate : _fmtDate(birth!)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.save)),
          ],
        ),
      ),
    );

    if (ok == true) {
      final name = nameCtrl.text.trim();
      if (name.isEmpty) return;
      await context.read<ProfileStore>().addProfile(name: name, birthDate: birth);
    }
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok == true) {
      await context.read<ProfileStore>().deleteProfile(id);
    }
  }

  void _openSettings(BuildContext context) {
    // just scroll to settings section; kept simple
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('')));
  }

  Future<void> _openLanguage(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.read<AppSettings>();
    final choice = await showModalBottomSheet<LanguageChoice>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.langSystem), onTap: () => Navigator.pop(context, LanguageChoice.system)),
            ListTile(title: Text(l10n.langSerbian), onTap: () => Navigator.pop(context, LanguageChoice.sr)),
            ListTile(title: Text(l10n.langEnglish), onTap: () => Navigator.pop(context, LanguageChoice.en)),
          ],
        ),
      ),
    );
    if (choice != null) {
      await settings.setLanguage(choice);
    }
  }

  Future<void> _openTheme(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.read<AppSettings>();
    final mode = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.system), onTap: () => Navigator.pop(context, ThemeMode.system)),
            ListTile(title: Text(l10n.light), onTap: () => Navigator.pop(context, ThemeMode.light)),
            ListTile(title: Text(l10n.dark), onTap: () => Navigator.pop(context, ThemeMode.dark)),
          ],
        ),
      ),
    );
    if (mode != null) {
      await settings.setThemeMode(mode);
    }
  }
}
