import 'package:hive/hive.dart';

@HiveType(typeId: EventType.adapterTypeId)
enum EventType {
  @HiveField(0)
  feed,
  @HiveField(1)
  wet,
  @HiveField(2)
  stool;

  static const int adapterTypeId = 2;
}

@HiveType(typeId: BreastSide.adapterTypeId)
enum BreastSide {
  @HiveField(0)
  left,
  @HiveField(1)
  right,
  @HiveField(2)
  both,
  @HiveField(3)
  none;

  static const int adapterTypeId = 3;
}

@HiveType(typeId: StoolColor.adapterTypeId)
enum StoolColor {
  @HiveField(0)
  yellow,
  @HiveField(1)
  mustard,
  @HiveField(2)
  green,
  @HiveField(3)
  brown,
  @HiveField(4)
  black,
  @HiveField(5)
  red,
  @HiveField(6)
  white,
  @HiveField(7)
  other;

  static const int adapterTypeId = 4;
}

@HiveType(typeId: EventEntry.adapterTypeId)
class EventEntry extends HiveObject {
  static const int adapterTypeId = 5;

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String profileId;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final EventType type;

  // Feed details
  @HiveField(4)
  final int? amountMl;

  @HiveField(5)
  final int? durationMin;

  @HiveField(6)
  final BreastSide? breastSide;

  // Stool details
  @HiveField(7)
  final StoolColor? stoolColor;

  // Shared
  @HiveField(8)
  final String? note;

  EventEntry({
    required this.id,
    required this.profileId,
    required this.timestamp,
    required this.type,
    this.amountMl,
    this.durationMin,
    this.breastSide,
    this.stoolColor,
    this.note,
  });
}

/// Hive adapters kept in-source (no build_runner required).

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = EventType.adapterTypeId;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.feed;
      case 1:
        return EventType.wet;
      case 2:
        return EventType.stool;
      default:
        return EventType.feed;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.feed:
        writer.writeByte(0);
        break;
      case EventType.wet:
        writer.writeByte(1);
        break;
      case EventType.stool:
        writer.writeByte(2);
        break;
    }
  }
}

class BreastSideAdapter extends TypeAdapter<BreastSide> {
  @override
  final int typeId = BreastSide.adapterTypeId;

  @override
  BreastSide read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BreastSide.left;
      case 1:
        return BreastSide.right;
      case 2:
        return BreastSide.both;
      case 3:
        return BreastSide.none;
      default:
        return BreastSide.none;
    }
  }

  @override
  void write(BinaryWriter writer, BreastSide obj) {
    switch (obj) {
      case BreastSide.left:
        writer.writeByte(0);
        break;
      case BreastSide.right:
        writer.writeByte(1);
        break;
      case BreastSide.both:
        writer.writeByte(2);
        break;
      case BreastSide.none:
        writer.writeByte(3);
        break;
    }
  }
}

class StoolColorAdapter extends TypeAdapter<StoolColor> {
  @override
  final int typeId = StoolColor.adapterTypeId;

  @override
  StoolColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StoolColor.yellow;
      case 1:
        return StoolColor.mustard;
      case 2:
        return StoolColor.green;
      case 3:
        return StoolColor.brown;
      case 4:
        return StoolColor.black;
      case 5:
        return StoolColor.red;
      case 6:
        return StoolColor.white;
      case 7:
        return StoolColor.other;
      default:
        return StoolColor.other;
    }
  }

  @override
  void write(BinaryWriter writer, StoolColor obj) {
    switch (obj) {
      case StoolColor.yellow:
        writer.writeByte(0);
        break;
      case StoolColor.mustard:
        writer.writeByte(1);
        break;
      case StoolColor.green:
        writer.writeByte(2);
        break;
      case StoolColor.brown:
        writer.writeByte(3);
        break;
      case StoolColor.black:
        writer.writeByte(4);
        break;
      case StoolColor.red:
        writer.writeByte(5);
        break;
      case StoolColor.white:
        writer.writeByte(6);
        break;
      case StoolColor.other:
        writer.writeByte(7);
        break;
    }
  }
}

class EventEntryAdapter extends TypeAdapter<EventEntry> {
  @override
  final int typeId = 2;

  @override
  EventEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return EventEntry(
      id: fields[0] as String,
      profileId: fields[1] as String,
      type: fields[2] as EventType,
      timestamp: fields[3] as DateTime,
      amountMl: fields[4] as int?,
      durationMin: fields[5] as int?,
      breastSide: fields[6] as BreastSide?,
      stoolColor: fields[7] as StoolColor?,
      note: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.amountMl)
      ..writeByte(5)
      ..write(obj.durationMin)
      ..writeByte(6)
      ..write(obj.breastSide)
      ..writeByte(7)
      ..write(obj.stoolColor)
      ..writeByte(8)
      ..write(obj.note);
  }
}
