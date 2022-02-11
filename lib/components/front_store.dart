import 'package:check_store_v2/error/auth_error.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valorant_client/valorant_client.dart';
import 'package:dio/dio.dart';
import '../model/riot_account.dart';
import 'package:valorant_client/src/models/storefront.dart';
import '../model/weapon_skinlevel/weapon_skinlevel.dart';

final weponSkinlevelProvider =
    FutureProvider.family<WeaponSkinlevel, String>((ref, uuid) async {
  final url = 'https://valorant-api.com/v1/weapons/skinlevels/$uuid';
  final response = await Dio().get(url, queryParameters: {'language': 'ja-JP'});
  final weapon = WeaponSkinlevel.fromJson(response.data['data']);
  return weapon;
});

Future<WeaponSkinlevel> getweponSkinlevel(String uuid) async {
  final url = 'https://valorant-api.com/v1/weapons/skinlevels/$uuid';
  final response = await Dio().get(url, queryParameters: {'language': 'ja-JP'});
  final weapon = WeaponSkinlevel.fromJson(response.data['data']);
  return weapon;
}

Future<List<WeaponSkinlevel>> getweponSkinlevels(List<String> uuids) async {
  final tasks = uuids.map((uuid) => getweponSkinlevel(uuid)).toList();
  final weapons = await Future.wait(tasks);
  return weapons;
}

class FrontStore extends ConsumerWidget {
  const FrontStore(this.riotAccount, {Key? key}) : super(key: key);
  final RiotAccount riotAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _asyncValorantClient = ref.watch(valorantClientProvider(riotAccount));
    return _asyncValorantClient.when(
      data: (storeFront) {
        final offers = storeFront?.skinsPanelLayout?.singleItemOffers;
        if (offers == null) throw Error();
        return FutureBuilder<List<WeaponSkinlevel>>(
          future: getweponSkinlevels(offers),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final weapons = snapshot.data!;
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: weapons.length,
                itemBuilder: (context, index) => ProviderScope(
                  child: const StoreItemCard(),
                  overrides: [weaponProvider.overrideWithValue(weapons[index])],
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, __) => Text(error.toString()),
    );
  }
}

final valorantClientProvider =
    FutureProvider.autoDispose.family<Storefront?, RiotAccount>(
  (ref, account) async {
    ValorantClient client = ValorantClient(
      UserDetails(
        userName: account.username,
        password: account.password,
        region: EnumToString.fromString(Region.values, account.region)!,
      ),
      callback: Callback(
        onError: (_) => throw AuthenticationFailedException(),
        onRequestError: (DioError error) {
          throw error;
        },
      ),
    );
    await client.init(true);
    return await client.playerInterface.getStorefront();
  },
);

final weaponProvider =
    Provider<WeaponSkinlevel>((ref) => throw UnimplementedError());

class StoreItemCard extends ConsumerWidget {
  const StoreItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weapon = ref.watch(weaponProvider);
    return Card(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              weapon.displayName,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
          Image(
            image: NetworkImage(weapon.displayIcon),
            fit: BoxFit.fill,
            height: 150,
          ),
        ],
      ),
    );
  }
}
