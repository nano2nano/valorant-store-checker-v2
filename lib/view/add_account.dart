import 'package:check_store_v2/repository/account_repository.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
final selectedRegionProvider = StateProvider.autoDispose<Region>(
  (ref) => Region.values[0],
);

class AddAccountView extends StatelessWidget {
  const AddAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NavigationView(
      appBar: NavigationAppBar(
        title: Text('Register'),
      ),
      content: _AddAccountView(),
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
              TextBox(
                controller: ref.watch(usernameControllerProvider),
                placeholder: 'Username',
              ),
              const SizedBox(height: 24.0),
              TextBox(
                controller: ref.watch(passwordControllerProvider),
                placeholder: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              const RegionSelector(),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    CancelButton(),
                    RegisterButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Center(
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RegisterButton extends ConsumerWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonButton(
      onPressed: () async {
        final username = ref.read(usernameControllerProvider).text;
        final password = ref.read(passwordControllerProvider).text;
        final region = ref.read(selectedRegionProvider);

        final RiotAccountRepository _riotAccountRepository =
            await ref.read(riotAccountRepositoryProvider.future);

        final RiotAccount _newRiotAccount = RiotAccount(
          id: const Uuid().v4(),
          username: username,
          password: password,
          region: EnumToString.convertToString(region),
        );
        await _riotAccountRepository.create(_newRiotAccount);
        Navigator.pop(context);
      },
      child: const Center(
        child: Text(
          'Register',
          textAlign: TextAlign.center,
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
  final Widget child;
  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 200,
      child: Button(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

final regionDropdownMenuItemProvider = Provider<List<ComboboxItem<Region>>>(
  (ref) => Region.values.map(
    (region) {
      return ComboboxItem<Region>(
        value: region,
        child: Text(EnumToString.convertToString(region)),
      );
    },
  ).toList(),
);

class RegionSelector extends ConsumerWidget {
  const RegionSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegion = ref.watch(selectedRegionProvider.state);
    return Combobox<Region>(
      items: ref.watch(regionDropdownMenuItemProvider),
      value: selectedRegion.state,
      onChanged: (value) {
        if (value == null) return;
        ref.read(selectedRegionProvider.state).state = value;
      },
    );
  }
}
