import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/models/event_entry.dart';
import '../../l10n/app_localizations.dart';
import '../../state/event_store.dart';
import '../../state/profile_store.dart';
import '../widgets/section_header.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  EventType _type = EventType.feed;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  final _amountCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  BreastSide _breastSide = BreastSide.none;
  StoolColor _stoolColor = StoolColor.yellow;
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _durationCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  DateTime get _timestamp {
    final d = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    return d;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final store = context.read<EventStore>();

    int? amount;
    int? duration;
    if (_type == EventType.feed) {
      amount = int.tryParse(_amountCtrl.text.trim());
      duration = int.tryParse(_durationCtrl.text.trim());
    }

    await store.addNew(
      timestamp: _timestamp,
      type: _type,
      amountMl: _type == EventType.feed ? amount : null,
      durationMin: _type == EventType.feed ? duration : null,
      breastSide: _type == EventType.feed ? _breastSide : null,
      stoolColor: _type == EventType.stool ? _stoolColor : null,
      note: _noteCtrl.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.saved)));
      _noteCtrl.clear();
      _amountCtrl.clear();
      _durationCtrl.clear();
      setState(() {
        _type = EventType.feed;
        _breastSide = BreastSide.none;
        _stoolColor = StoolColor.yellow;
        _date = DateTime.now();
        _time = TimeOfDay.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<ProfileStore>().activeProfile;

    final dateFmt = DateFormat.yMMMd(l10n.localeName);
    final timeFmt = DateFormat.Hm(l10n.localeName);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addEventTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (profile == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(l10n.noProfile),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: l10n.addEventTitle),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<EventType>(
                    value: _type,
                    decoration: InputDecoration(labelText: l10n.eventType),
                    items: [
                      DropdownMenuItem(value: EventType.feed, child: Text(l10n.eventFeed)),
                      DropdownMenuItem(value: EventType.wet, child: Text(l10n.eventWet)),
                      DropdownMenuItem(value: EventType.stool, child: Text(l10n.eventStool)),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? _type),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                          label: Text('${l10n.dateLabel}: ${dateFmt.format(_date)}'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(Icons.access_time),
                          label: Text('${l10n.timeLabel}: ${timeFmt.format(_timestamp)}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_type == EventType.feed) ...[
                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.amountMl),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.durationMin),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<BreastSide>(
                      value: _breastSide,
                      decoration: InputDecoration(labelText: l10n.breastSide),
                      items: [
                        DropdownMenuItem(value: BreastSide.left, child: Text(l10n.sideLeft)),
                        DropdownMenuItem(value: BreastSide.right, child: Text(l10n.sideRight)),
                        DropdownMenuItem(value: BreastSide.both, child: Text(l10n.sideBoth)),
                        DropdownMenuItem(value: BreastSide.none, child: Text(l10n.sideNone)),
                      ],
                      onChanged: (v) => setState(() => _breastSide = v ?? _breastSide),
                    ),
                    const SizedBox(height: 10),
                  ],

                  if (_type == EventType.stool) ...[
                    DropdownButtonFormField<StoolColor>(
                      value: _stoolColor,
                      decoration: InputDecoration(labelText: l10n.stoolColor),
                      items: [
                        DropdownMenuItem(value: StoolColor.yellow, child: Text(l10n.colorYellow)),
                        DropdownMenuItem(value: StoolColor.mustard, child: Text(l10n.colorMustard)),
                        DropdownMenuItem(value: StoolColor.green, child: Text(l10n.colorGreen)),
                        DropdownMenuItem(value: StoolColor.brown, child: Text(l10n.colorBrown)),
                        DropdownMenuItem(value: StoolColor.black, child: Text(l10n.colorBlack)),
                        DropdownMenuItem(value: StoolColor.red, child: Text(l10n.colorRed)),
                        DropdownMenuItem(value: StoolColor.white, child: Text(l10n.colorWhite)),
                        DropdownMenuItem(value: StoolColor.other, child: Text(l10n.colorOther)),
                      ],
                      onChanged: (v) => setState(() => _stoolColor = v ?? _stoolColor),
                    ),
                    const SizedBox(height: 10),
                  ],

                  TextFormField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(labelText: l10n.note),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: profile == null ? null : _save,
                      icon: const Icon(Icons.save),
                      label: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(title: l10n.recentEntries),
          const SizedBox(height: 8),
          _RecentEntries(),
        ],
      ),
    );
  }
}

class _RecentEntries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final store = context.watch<EventStore>();
    final items = store.allForActiveProfile.take(20).toList();

    if (items.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text('—'),
        ),
      );
    }

    String typeLabel(EventType t) {
      switch (t) {
        case EventType.feed:
          return l10n.eventFeed;
        case EventType.wet:
          return l10n.eventWet;
        case EventType.stool:
          return l10n.eventStool;
      }
    }

    final timeFmt = DateFormat('dd.MM HH:mm', l10n.localeName);

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final e = items[i];
          final subtitleParts = <String>[];

          if (e.type == EventType.feed) {
            if (e.amountMl != null) subtitleParts.add('${e.amountMl} ml');
            if (e.durationMin != null) subtitleParts.add('${e.durationMin} min');
          }
          if (e.type == EventType.stool && e.stoolColor != null) {
            subtitleParts.add(e.stoolColor.toString().split('.').last);
          }
          if (e.note != null && e.note!.isNotEmpty) subtitleParts.add(e.note!);

          return ListTile(
            title: Text(typeLabel(e.type)),
            subtitle: Text('${timeFmt.format(e.timestamp)}  ${subtitleParts.isEmpty ? '' : '• ${subtitleParts.join(' • ')}'}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(l10n.deleteConfirmTitle),
                    content: Text(l10n.deleteConfirmBody),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
                    ],
                  ),
                );
                if (ok == true) {
                  await context.read<EventStore>().delete(e.id);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
