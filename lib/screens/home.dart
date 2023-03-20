import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_school_rim/widgets/icons.dart';

import '../fonctions/fonctions.dart';
import '../models/utilisateurs.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import 'data.dart';
import 'login.dart';

class Home extends StatefulWidget {
  static const root = 'Home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Utilisateur utilisateur;
  late String phoneNumber;
  User? userCurrent = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    phoneNumber = ModalRoute.of(context)?.settings.arguments as String;
    getData();
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [colorWhite, colorPrimary!])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/appstore.png'),
                  ),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/1234.png'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  labelDrawwer('المهام', colorThird!),
                  const SizedBox(
                    height: 12,
                  ),
                  listTile(
                      Icons.manage_accounts, colorThird, 'إدارة مدرسة', () {}),
                  listTile(Icons.badge, colorThird, 'انتساب لمدرسة', () {}),
                  const Divider(),
                  listTile(Icons.school, colorPrimary, 'مدارسي', () {}),
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
        .doc(phoneNumber)
        .get()
        .then((value) => {
              utilisateur = Utilisateur(value['nom'], value['phone'],
                  value['code'], value['ask'], value['answer'])
            });
  }
}
