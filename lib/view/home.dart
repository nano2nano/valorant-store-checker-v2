import 'package:check_store_v2/view/add_account.dart';
import 'package:check_store_v2/view/storefront_view.dart' as storefront_view;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/riot_account/riot_account.dart';
import '../repository/account_repository.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = ref.watch(indexProvider);
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

            final items = <NavigationPaneItem>[];
            for (final riotAccount in _riotAccounts) {
              items.add(PaneItem(
                icon: const Icon(FluentIcons.reminder_person),
                title: Text(riotAccount.username),
              ));
            }

            items.add(PaneItemSeparator());
            items.add(
              PaneItem(
                icon: const Icon(FluentIcons.add),
                title: const Text('Add Account'),
              ),
            );

            return NavigationView(
              pane: NavigationPane(
                selected: _currentIndex,
                onChanged: (index) =>
                    ref.read(indexProvider.state).state = index,
                items: items,
                displayMode: PaneDisplayMode.auto,
              ),
              content: NavigationBody.builder(
                index: _currentIndex,
                itemBuilder: (context, index) {
                  if (index < _riotAccounts.length) {
                    return ProviderScope(
                      child: const storefront_view.StorefrontView(),
                      overrides: [
                        storefront_view.riotAccountProvider.overrideWithValue(
                          _riotAccounts[index],
                        )
                      ],
                    );
                  } else {
                    return const AddAccountView();
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: ProgressRing()),
      error: (_, __) => const Center(child: ProgressRing()),
    );
  }
}
