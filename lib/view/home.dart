import 'package:check_store_v2/view/add_account.dart';
import 'package:check_store_v2/view/storefront_view.dart' as storefront_view;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/riot_account/riot_account.dart';
import '../repository/account_repository.dart';

final indexProvider = StateProvider<int>((ref) => 0);
final accountProvider = StateProvider<RiotAccount?>((ref) {
  return null;
});

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = ref.watch(indexProvider);
    final _currentAccount = ref.watch(accountProvider);
    final _asyncRiotAccountRepository =
        ref.watch(riotAccountRepositoryProvider);

    return _asyncRiotAccountRepository.when(
      data: (RiotAccountRepository _riotAccountRepository) {
        return StreamBuilder(
          stream: _riotAccountRepository.stream,
          builder: (_, AsyncSnapshot<BoxEvent> snapshot) {
            final List<RiotAccount> _riotAccounts =
                _riotAccountRepository.riotAccounts;

            final homeViews = [
              _currentAccount == null
                  ? const ScaffoldPage(
                      content: Center(child: Text('Select account')),
                    )
                  : ProviderScope(
                      overrides: [
                        storefront_view.riotAccountProvider.overrideWithValue(
                          ref.watch(accountProvider)!,
                        )
                      ],
                      child: const storefront_view.StorefrontView(),
                    ),
              const AddAccountView(),
            ];

            return NavigationView(
              pane: NavigationPane(
                selected: _currentIndex,
                onChanged: (index) =>
                    ref.read(indexProvider.state).state = index,
                items: [
                  PaneItem(
                    icon: const Icon(FluentIcons.store_logo16),
                    title: const Text('Storefront'),
                  ),
                  PaneItemSeparator(),
                  PaneItemAction(
                    icon: const Icon(FluentIcons.add),
                    title: const Text('Add Account'),
                    onTap: () => Navigator.pushNamed(context, '/add_account'),
                  ),
                ],
                footerItems: [
                  PaneItemHeader(
                    header: Expander(
                      header:
                          Text(_currentAccount?.username ?? 'Select account'),
                      content: Column(
                        children: _riotAccounts
                            .map(
                              (account) => SizedBox(
                                width: double.infinity,
                                child: Button(
                                  child: Text(
                                    account.username,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    ref.read(accountProvider.state).state =
                                        account;
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      direction: ExpanderDirection.up,
                      initiallyExpanded: false,
                    ),
                  )
                ],
                displayMode: PaneDisplayMode.auto,
              ),
              content: NavigationBody(
                index: _currentIndex,
                children: homeViews,
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
