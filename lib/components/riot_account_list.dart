import 'package:check_store_v2/components/riot_account_card.dart';
import 'package:check_store_v2/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/riot_account/riot_account.dart';

final riotAccountRepositoryProvider =
    FutureProvider((ref) => RiotAccountRepository.open());

class RiotAccountList extends ConsumerWidget {
  const RiotAccountList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRiotAccountRepository = ref.watch(riotAccountRepositoryProvider);
    return asyncRiotAccountRepository.when(
      data: (RiotAccountRepository riotAccountRepository) {
        return StreamBuilder(
          stream: riotAccountRepository.stream,
          builder: (_, AsyncSnapshot<BoxEvent> snapshot) {
            final List<RiotAccount> riotAccounts =
                riotAccountRepository.riotAccounts;

            if (riotAccounts.isEmpty) {
              return const Center(
                child: Text('No accounts...'),
              );
            }

            return ListView.builder(
              itemBuilder: (_, int index) {
                return Dismissible(
                  key: Key(riotAccounts[index].id),
                  child: ProviderScope(
                    overrides: [
                      riotAccountProvider.overrideWithValue(
                        riotAccounts[index],
                      )
                    ],
                    child: const RiotAccountCard(),
                  ),
                  onDismissed: (DismissDirection direction) async {
                    await riotAccountRepository.delete(riotAccounts[index]);
                  },
                );
              },
              itemCount: riotAccounts.length,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: CircularProgressIndicator()),
    );
  }
}
