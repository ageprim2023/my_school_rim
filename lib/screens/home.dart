import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_school_rim/widgets/icons.dart';

import '../fonctions/fonctions.dart';
import '../models/utilisateurs.dart';
import '../tools/styles.dart';
import 'data.dart';
import 'login.dart';

class Home extends StatefulWidget {
  static const root = 'Home';
  final Utilisateur utilisateur;
  const Home({super.key, required this.utilisateur});

  @override
  // ignore: no_logic_in_create_state
  State<Home> createState() => _HomeState(utilisateur);
}

class _HomeState extends State<Home> {
  final Utilisateur utilisateur;
  late Utilisateur thisUtilisateur;
  //late String phoneNumber;
  User? userCurrent = FirebaseAuth.instance.currentUser;

  _HomeState(this.utilisateur);

  @override
  Widget build(BuildContext context) {
    //phoneNumber = ModalRoute.of(context)?.settings.arguments as String;
    //getData();
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            myShowDialogYesNo(context, 'هل تربد حقا غلق التطبيق؟', () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, Login.root);
            });
          },
          icon: const Icon(Icons.close),
        )
      ]),
      body: Text('nom ${utilisateur.nom}'),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(padding: const EdgeInsets.only(bottom: 0,top: 6,left: 12,right: 12),
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [colorSecondary!, colorPrimary!])),
              child: Stack(children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(utilisateur.nom,style: const TextStyle(color: Colors.white),),),
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
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 42,
                  ),
                  listTile(Icons.school, colorThird, 'إدارة مدرسة', () {}),
                  const Divider(),
                  listTile(Icons.badge, colorPrimary, 'انتساب لمدرسة', () {}),
                  const Divider(),
                  listTile(Icons.account_balance, colorGreen, 'بيانات الحساب',
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Data(utilisateur: utilisateur),
                        ));
                  }),
                  const Divider(),
                  listTile(Icons.exit_to_app, colorRed, 'خروج', () {
                    myShowDialogYesNo(context, 'هل تربد حقا غلق التطبيق؟',
                        () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, Login.root);
                    });
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile listTile(
      IconData icon, Color? color, String text, VoidCallback onTap) {
    return ListTile(
      leading: MyIcon(icon: icon, color: color),
      title: Text(
        text,
      ),
      trailing: const MyIcon(icon: Icons.arrow_right, color: Colors.black),
      onTap: onTap,
    );
  }

  Text labelDrawwer(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.underline, fontSize: 18, color: color),
    );
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection("emails")
        .doc(thisUtilisateur.phone)
        .get()
        .then((value) => {
              thisUtilisateur = Utilisateur(value['nom'], value['phone'],
                  value['code'], value['ask'], value['answer'])
            });
  }
}
