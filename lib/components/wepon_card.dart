import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(weponData['displayName']),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: CircularProgressIndicator()),
    );
  }
}
