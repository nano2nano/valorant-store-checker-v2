import 'package:hive/hive.dart';

import '../model/riot_account/riot_account.dart';

class RiotAccountRepository {
  late Box<RiotAccount> _box;

  Box<RiotAccount> get box => _box;

  List<RiotAccount> get riotAccounts => _box.values.toList();

  Stream<BoxEvent> get stream => _box.watch();

  static Future<RiotAccountRepository> open() async {
    final repos = RiotAccountRepository();
    await repos._initHive();
    return repos;
  }

  Future<RiotAccountRepository> _initHive() async {
    Hive.registerAdapter(RiotAccountAdapter());
    _box = await Hive.openBox('riot_account');
    return this;
  }

  Future<void> create(RiotAccount riotAccount) async {
    return _box.put(riotAccount.id, riotAccount);
  }

  Future<RiotAccount?> read(String id) async {
    return _box.get(id);
  }

  Future<void> update(RiotAccount riotAccount) async {
    return _box.put(riotAccount.id, riotAccount);
  }

  Future<void> delete(RiotAccount riotAccount) async {
    return _box.delete(riotAccount.id);
  }
}
