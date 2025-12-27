import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/section_header.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text(t.navLog, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.logAddTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(t.logAddHint),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.baby_changing_station),
                        label: Text(t.actionWet),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_nature),
                        label: Text(t.actionStool),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.local_drink),
                  label: Text(t.actionFeed),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SectionHeader(title: t.recentEvents),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(t.recentEventsEmpty),
            subtitle: Text(t.recentEventsEmptySub),
          ),
        ),
      ],
    );
  }
}
