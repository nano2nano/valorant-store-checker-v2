import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/weapon_skinlevel/weapon_skinlevel.dart';

final weaponProvider =
    Provider<WeaponSkinlevel>((ref) => throw UnimplementedError());

class StoreItemCard extends ConsumerWidget {
  const StoreItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weapon = ref.watch(weaponProvider);
    return Card(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              weapon.displayName,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
          Image(
            image: NetworkImage(weapon.displayIcon),
            fit: BoxFit.fill,
            height: 150,
          ),
        ],
      ),
    );
  }
}
