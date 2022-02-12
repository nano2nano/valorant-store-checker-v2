import 'package:check_store_v2/view/storefront_view.dart';
import 'package:flutter/material.dart';

import '../model/riot_account/riot_account.dart';

class RiotAccountCard extends StatelessWidget {
  const RiotAccountCard(this.riotAccount, {Key? key}) : super(key: key);
  final RiotAccount riotAccount;

  @override
  Widget build(BuildContext context) {
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
