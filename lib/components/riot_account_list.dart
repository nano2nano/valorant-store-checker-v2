import 'package:check_store_v2/components/riot_account_card.dart';
import 'package:check_store_v2/repository/account_repository.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/riot_account/riot_account.dart';

class RiotAccountList extends ConsumerWidget {
  const RiotAccountList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _asyncRiotAccountRepository =
        ref.watch(riotAccountRepositoryProvider);
    return _asyncRiotAccountRepository.when(
      data: (RiotAccountRepository _riotAccountRepository) {
        return StreamBuilder(
          stream: _riotAccountRepository.stream,
          builder: (_, AsyncSnapshot<BoxEvent> snapshot) {
            final List<RiotAccount> _riotAccounts =
                _riotAccountRepository.riotAccounts;

            if (_riotAccounts.isEmpty) {
              return const Center(
                child: Text('No accounts...'),
              );
            }

            return ListView.builder(
              itemBuilder: (_, int index) {
                return Dismissible(
                  key: Key(_riotAccounts[index].id),
                  child: ProviderScope(
                    overrides: [
                      riotAccountProvider.overrideWithValue(
                        _riotAccounts[index],
                      )
                    ],
                    child: const RiotAccountCard(),
                  ),
                  onDismissed: (DismissDirection direction) async {
                    await _riotAccountRepository.delete(_riotAccounts[index]);
                  },
                );
              },
              itemCount: _riotAccounts.length,
            );
          },
        );
      },
      loading: () => const Center(child: ProgressRing()),
      error: (_, __) => const Center(child: ProgressRing()),
    );
  }
}
