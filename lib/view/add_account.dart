import 'package:check_store_v2/components/riot_account_list.dart';
import 'package:check_store_v2/repository/account_repository.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:valorant_client/valorant_client.dart';

import '../model/riot_account/riot_account.dart';

final usernameControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final passwordControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

class AddAccountView extends StatelessWidget {
  const AddAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const _AddAccountView(),
    );
  }
}

class _AddAccountView extends ConsumerWidget {
  const _AddAccountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              TextFormField(
                controller: ref.watch(usernameControllerProvider),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: ref.watch(passwordControllerProvider),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              const DropDown(),
              const SizedBox(height: 24.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CommonButton(
                    onPressed: () async {
                      final username =
                          ref.read(usernameControllerProvider).text;
                      final password =
                          ref.read(passwordControllerProvider).text;
                      final region = ref.read(selectedRegionProvider);

                      final RiotAccountRepository riotAccountRepository =
                          await ref.read(riotAccountRepositoryProvider.future);

                      final RiotAccount newRiotAccount = RiotAccount(
                        id: const Uuid().v4(),
                        username: username,
                        password: password,
                        region: EnumToString.convertToString(region),
                      );
                      await riotAccountRepository.create(newRiotAccount);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Register'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

final selectedRegionProvider = StateProvider.autoDispose<Region>(
  (ref) => Region.values[0],
);

final regionDropdownMenuItemProvider = Provider<List<DropdownMenuItem<Region>>>(
  (ref) => Region.values.map(
    (region) {
      return DropdownMenuItem(
        value: region,
        child: Text(EnumToString.convertToString(region)),
      );
    },
  ).toList(),
);

class DropDown extends ConsumerWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegion = ref.watch(selectedRegionProvider.state);
    return DropdownButton<Region>(
      items: ref.watch(regionDropdownMenuItemProvider),
      value: selectedRegion.state,
      onChanged: (value) {
        if (value == null) return;
        ref.read(selectedRegionProvider.state).state = value;
      },
    );
  }
}
