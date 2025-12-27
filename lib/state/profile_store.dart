import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../core/models/profile.dart';

class ProfileStore extends ChangeNotifier {
  final _uuid = const Uuid();

  List<Profile> profiles = [];
  String? activeProfileId;

  Box get _box => Hive.box('profiles');
  Box get _app => Hive.box('app');

  Future<void> load() async {
    final values = _box.values.whereType<Profile>().toList();
    profiles = values;
    activeProfileId = _app.get('activeProfileId') as String?;
    if (activeProfileId == null && profiles.isNotEmpty) {
      activeProfileId = profiles.first.id;
      await _app.put('activeProfileId', activeProfileId);
    }
    notifyListeners();
  }

  Profile? get activeProfile => profiles.where((p) => p.id == activeProfileId).cast<Profile?>().firstWhere((p) => true, orElse: () => null);

  Future<void> addProfile({required String name, DateTime? birthDate}) async {
    final profile = Profile(id: _uuid.v4(), name: name.trim(), birthDate: birthDate);
    await _box.put(profile.id, profile);
    profiles = _box.values.whereType<Profile>().toList();
    activeProfileId ??= profile.id;
    await _app.put('activeProfileId', activeProfileId);
    notifyListeners();
  }

  Future<void> setActive(String id) async {
    activeProfileId = id;
    await _app.put('activeProfileId', activeProfileId);
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    await _box.delete(id);
    profiles = _box.values.whereType<Profile>().toList();
    if (activeProfileId == id) {
      activeProfileId = profiles.isNotEmpty ? profiles.first.id : null;
      await _app.put('activeProfileId', activeProfileId);
    }
    notifyListeners();
  }
}
