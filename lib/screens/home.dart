import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            MyButton(
                title: 'بياناتي',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Data(utilisateur: utilisateur),
                      ));
                },
                color: colorGreen!)
          ],
        ),
      ),
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
