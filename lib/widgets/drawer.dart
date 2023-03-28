import 'package:flutter/material.dart';

import '../models/utilisateurs.dart';
import '../tools/styles.dart';
import 'icons.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.nomUtilisateur,
    required this.listWidges,
  });

  final String nomUtilisateur;
  final List<Widget> listWidges;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MyDrawerHead(nomUtilisateur: nomUtilisateur),
          MyDrawerBody(listWidges: listWidges),
        ],
      ),
    );
  }
}

class MyDrawerHead extends StatelessWidget {
  const MyDrawerHead({
    super.key,
    required this.nomUtilisateur,
  });

  final String nomUtilisateur;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.only(bottom: 0, top: 6, left: 12, right: 12),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colorSecondary!, colorPrimary!])),
      child: Stack(children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            nomUtilisateur,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/appstore.png'),
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/1234.png'),
            ),
          ],
        ),
      ]),
    );
  }
}

class MyDrawerBody extends StatelessWidget {
  final List<Widget> listWidges;

  const MyDrawerBody({
    super.key,
    required this.listWidges,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: listWidges,
      ),
    );
  }
}

Widget labelTask(String text, Color color) {
  return Column(
    children: [
      Text(
        text,
        style: TextStyle(
            decoration: TextDecoration.underline, fontSize: 18, color: color),
      ),
      const SizedBox(
        height: 28,
      )
    ],
  );
}

Widget listTile(IconData icon, Color? color, String text, VoidCallback onTap) {
  return Column(
    children: [
      ListTile(
        leading: MyIcon(icon: icon, color: color),
        title: Text(
          text,
        ),
        trailing: const MyIcon(icon: Icons.arrow_right, color: Colors.black),
        onTap: onTap,
      ),
      const Divider(),
    ],
  );
}
