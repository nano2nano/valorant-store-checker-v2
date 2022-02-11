import 'package:check_store_v2/components/front_store.dart';
import 'package:check_store_v2/model/riot_account.dart';
import 'package:flutter/material.dart';

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
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Storefront')),
              body: FrontStore(riotAccount),
            ),
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
