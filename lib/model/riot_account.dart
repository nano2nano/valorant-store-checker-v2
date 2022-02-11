import 'package:hive/hive.dart';

part 'riot_account.g.dart';

@HiveType(typeId: 0)
class RiotAccount extends HiveObject {
  RiotAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.region,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  @HiveField(3)
  String region;
}
