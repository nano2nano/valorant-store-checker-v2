import 'package:check_store_v2/view/storefront_view.dart' as store_front_view;
import 'package:fluent_ui/fluent_ui.dart';
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
          FluentPageRoute(
            builder: (context) => ProviderScope(
              overrides: [
                store_front_view.riotAccountProvider
                    .overrideWithValue(riotAccount),
              ],
              child: const store_front_view.StorefrontView(),
            ),
          ),
        );
      },
      child: ListTile(
        title: Text(riotAccount.username),
      ),
    );
  }
}
