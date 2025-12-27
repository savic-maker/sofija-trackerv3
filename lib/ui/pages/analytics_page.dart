import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/models/event_entry.dart';
import '../../l10n/app_localizations.dart';
import '../../state/event_store.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final store = context.watch<EventStore>();

    final wet = store.countsForLast7Days(EventType.wet);
    final stool = store.countsForLast7Days(EventType.stool);
    final feed = store.countsForLast7Days(EventType.feed);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analyticsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChartCard(title: l10n.wetDiapers, data: wet, localeName: l10n.localeName),
          const SizedBox(height: 12),
          _ChartCard(title: l10n.stools, data: stool, localeName: l10n.localeName),
          const SizedBox(height: 12),
          _ChartCard(title: l10n.feeds, data: feed, localeName: l10n.localeName),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Map<DateTime, int> data;
  final String localeName;

  const _ChartCard({required this.title, required this.data, required this.localeName});

  @override
  Widget build(BuildContext context) {
    final days = data.keys.toList()..sort();
    final values = days.map((d) => data[d] ?? 0).toList();

    final maxY = (values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b)).toDouble();
    final double yTop = (maxY < 4.0 ? 4.0 : maxY + 1.0);

    final dayFmt = DateFormat.E(localeName);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: yTop,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(dayFmt.format(days[idx]), style: Theme.of(context).textTheme.labelSmall),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(days.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i].toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
