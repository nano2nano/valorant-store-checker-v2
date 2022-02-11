// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon_skinlevel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WeaponSkinlevel _$$_WeaponSkinlevelFromJson(Map<String, dynamic> json) =>
    _$_WeaponSkinlevel(
      uuid: json['uuid'] as String,
      displayName: json['displayName'] as String,
      levelItem: json['levelItem'] as String?,
      displayIcon: json['displayIcon'] as String,
      streamedVideo: json['streamedVideo'] as String?,
      assetPath: json['assetPath'] as String,
    );

Map<String, dynamic> _$$_WeaponSkinlevelToJson(_$_WeaponSkinlevel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'displayName': instance.displayName,
      'levelItem': instance.levelItem,
      'displayIcon': instance.displayIcon,
      'streamedVideo': instance.streamedVideo,
      'assetPath': instance.assetPath,
    };
