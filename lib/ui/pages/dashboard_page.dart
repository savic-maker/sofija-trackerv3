import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/event_store.dart';
import '../../core/models/event_entry.dart';
import '../../state/app_settings.dart';
import '../../state/profile_store.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final events = context.watch<EventStore>();
    final settings = context.watch<AppSettings>();
    final profile = context.watch<ProfileStore>().activeProfile;

    final now = DateTime.now();
    final wetToday = events.countForDay(now, EventType.wet);
    final stoolToday = events.countForDay(now, EventType.stool);
    final feedToday = events.countForDay(now, EventType.feed);

    final wetWeek = events.countsForLast7Days(EventType.wet).values.fold<int>(0, (a,b)=>a+b);
    final stoolWeek = events.countsForLast7Days(EventType.stool).values.fold<int>(0, (a,b)=>a+b);
    final feedWeek = events.countsForLast7Days(EventType.feed).values.fold<int>(0, (a,b)=>a+b);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(
            tooltip: l10n.snoozeNow,
            onPressed: settings.remindersEnabled ? () => settings.snoozeNow() : null,
            icon: const Icon(Icons.snooze),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (profile != null)
            Text(
              '${profile.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          const SizedBox(height: 12),
          SectionHeader(title: l10n.today),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: MetricCard(title: l10n.wetDiapers, value: '$wetToday', icon: Icons.opacity)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(title: l10n.stools, value: '$stoolToday', icon: Icons.event_note)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(title: l10n.feeds, value: '$feedToday', icon: Icons.baby_changing_station)),
            ],
          ),
          const SizedBox(height: 16),
          SectionHeader(title: l10n.thisWeek),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: MetricCard(title: l10n.wetDiapers, value: '$wetWeek', icon: Icons.opacity)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(title: l10n.stools, value: '$stoolWeek', icon: Icons.event_note)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(title: l10n.feeds, value: '$feedWeek', icon: Icons.baby_changing_station)),
            ],
          ),
          const SizedBox(height: 16),
          SectionHeader(title: l10n.reminders),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.enableReminders),
                    value: settings.remindersEnabled,
                    onChanged: (v) => settings.setRemindersEnabled(v),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _NumberStepper(
                          label: l10n.intervalHours,
                          value: settings.feedIntervalHours,
                          min: 1,
                          max: 12,
                          onChanged: (v) => settings.setFeedIntervalHours(v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _NumberStepper(
                          label: l10n.snoozeMinutes,
                          value: settings.snoozeMinutes,
                          min: 5,
                          max: 60,
                          step: 5,
                          onChanged: (v) => settings.setSnoozeMinutes(v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  const _NumberStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.step = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Row(
          children: [
            IconButton(
              onPressed: value - step >= min ? () => onChanged(value - step) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$value', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              onPressed: value + step <= max ? () => onChanged(value + step) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
