// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riot_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RiotAccountAdapter extends TypeAdapter<RiotAccount> {
  @override
  final int typeId = 0;

  @override
  RiotAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiotAccount(
      id: fields[0] as String,
      username: fields[1] as String,
      password: fields[2] as String,
      region: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RiotAccount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.region);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiotAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
