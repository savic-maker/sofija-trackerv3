import 'package:hive/hive.dart';

@HiveType(typeId: Profile.adapterTypeId)
class Profile extends HiveObject {
  static const int adapterTypeId = 1;

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime? birthDate;

  Profile({
    required this.id,
    required this.name,
    this.birthDate,
  });
}

/// Hive adapter kept in-source (no build_runner required).
class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = Profile.adapterTypeId;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return Profile(
      id: fields[0] as String,
      name: fields[1] as String,
      birthDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.birthDate);
  }
}
