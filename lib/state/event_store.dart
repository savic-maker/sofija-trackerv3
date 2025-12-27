import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../core/models/event_entry.dart';

class EventStore extends ChangeNotifier {
  final _uuid = const Uuid();
  String? _activeProfileId;

  Box get _box => Hive.box('events');

  void setActiveProfileId(String? id) {
    if (_activeProfileId != id) {
      _activeProfileId = id;
      notifyListeners();
    }
  }

  List<EventEntry> get allForActiveProfile {
    final pid = _activeProfileId;
    if (pid == null) return [];
    return _box.values.whereType<EventEntry>().where((e) => e.profileId == pid).toList()
      ..sort((a,b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> add(EventEntry entry) async {
    await _box.put(entry.id, entry);
    notifyListeners();
  }

  Future<void> addNew({
    required DateTime timestamp,
    required EventType type,
    int? amountMl,
    int? durationMin,
    BreastSide? breastSide,
    StoolColor? stoolColor,
    String? note,
  }) async {
    final pid = _activeProfileId;
    if (pid == null) return;

    final entry = EventEntry(
      id: _uuid.v4(),
      profileId: pid,
      timestamp: timestamp,
      type: type,
      amountMl: amountMl,
      durationMin: durationMin,
      breastSide: breastSide,
      stoolColor: stoolColor,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
    );
    await add(entry);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  int countForDay(DateTime day, EventType type) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return allForActiveProfile.where((e) => e.type == type && !e.timestamp.isBefore(start) && e.timestamp.isBefore(end)).length;
  }

  Map<DateTime, int> countsForLast7Days(EventType type, {DateTime? today}) {
    final t = today ?? DateTime.now();
    final startToday = DateTime(t.year, t.month, t.day);
    final map = <DateTime,int>{};
    for (int i=6;i>=0;i--) {
      final d = startToday.subtract(Duration(days:i));
      map[d] = countForDay(d, type);
    }
    return map;
  }
}
