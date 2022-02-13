import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weponSkinlevelProvider =
    FutureProvider.family<dynamic, String>((ref, uuid) async {
  final url = 'https://valorant-api.com/v1/weapons/skinlevels/$uuid';
  final response = await Dio().get(url, queryParameters: {'language': 'ja-JP'});
  return response.data['data'];
});

class WeaponCard extends ConsumerWidget {
  const WeaponCard(this.uuid, {Key? key}) : super(key: key);
  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(weponSkinlevelProvider(uuid));
    return snapshot.when(
      data: (weponData) {
        if (weponData == null) throw Error();
        return ListTile(
          title: Text(weponData['displayName']),
        );
      },
      loading: () => const Center(child: ProgressRing()),
      error: (_, __) => const Center(child: ProgressRing()),
    );
  }
}
