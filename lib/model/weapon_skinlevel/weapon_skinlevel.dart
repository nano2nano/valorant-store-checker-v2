import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weapon_skinlevel.freezed.dart';
part 'weapon_skinlevel.g.dart';

@freezed
class WeaponSkinlevel with _$WeaponSkinlevel {
  const factory WeaponSkinlevel({
    @JsonKey(name: 'uuid') required String uuid,
    @JsonKey(name: 'displayName') required String displayName,
    @JsonKey(name: 'levelItem') String? levelItem,
    @JsonKey(name: 'displayIcon') required String displayIcon,
    @JsonKey(name: 'streamedVideo') String? streamedVideo,
    @JsonKey(name: 'assetPath') required String assetPath,
  }) = _WeaponSkinlevel;
  factory WeaponSkinlevel.fromJson(Map<String, dynamic> json) =>
      _$WeaponSkinlevelFromJson(json);
}
