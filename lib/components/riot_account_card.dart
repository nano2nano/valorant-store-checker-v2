import 'package:check_store_v2/view/storefront_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/riot_account/riot_account.dart';

final riotAccountProvider =
    Provider<RiotAccount>((ref) => throw UnimplementedError());

class RiotAccountCard extends ConsumerWidget {
  const RiotAccountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riotAccount = ref.watch(riotAccountProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StorefrontView(riotAccount),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(riotAccount.username),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
