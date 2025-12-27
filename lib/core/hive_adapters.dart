import 'package:hive/hive.dart';

import 'models/profile.dart';
import 'models/event_entry.dart';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(Profile.adapterTypeId)) {
    Hive.registerAdapter(ProfileAdapter());
  }
  if (!Hive.isAdapterRegistered(EventEntry.adapterTypeId)) {
    Hive.registerAdapter(EventEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(EventType.adapterTypeId)) {
    Hive.registerAdapter(EventTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(BreastSide.adapterTypeId)) {
    Hive.registerAdapter(BreastSideAdapter());
  }
  if (!Hive.isAdapterRegistered(StoolColor.adapterTypeId)) {
    Hive.registerAdapter(StoolColorAdapter());
  }
}
