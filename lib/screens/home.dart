import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_school_rim/models/utilisateurs.dart';
import 'package:my_school_rim/widgets/container_indicator.dart';
import 'package:my_school_rim/widgets/icons.dart';

import '../fonctions/fonctions.dart';
import '../tools/collections.dart';
import '../tools/styles.dart';
import '../widgets/drawer.dart';
import 'direction_shcool.dart';
import 'login.dart';
import 'my_compte_data.dart';

class Home extends StatefulWidget {
  final Utilisateur myUtilisateur;
  static const root = 'Home';
  const Home({super.key, required this.myUtilisateur});

  @override
  // ignore: no_logic_in_create_state
  State<Home> createState() => _HomeState(myUtilisateur);
}

class _HomeState extends State<Home> {
  final Utilisateur myUtilisateur;
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  User? userCurrent = FirebaseAuth.instance.currentUser;

  _HomeState(this.myUtilisateur);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('الرئيسية'),
      ),
      drawer: getMyDrawer(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(schoolsCollection)
            .snapshots(),
        builder: (context, snapshot) {
          List<Widget> mySchools = [];
          if (snapshot.hasData) {
            for (var school in snapshot.data!.docs) {
              mySchools.add(Padding(
                padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
                child: Card(
                  child: ListTile(
                    leading: const MyIcon(icon: Icons.school),
                    title: Text('${school.get(schoolsCollectionNom)}'),
                    subtitle: Text('${school.get(schoolsCollectionDir)}'),
                  ),
                ),
              ));
            }
          }
          return Stack(
            children: [
              ContainerNormal(
                child: Column(
                  children: mySchools,
                ),
              ),
              Container(
                child: !snapshot.hasData ? const ContainerIndicator() : null,
              )
            ],
          );
        },
      ),
    );
  }

  MyDrawer getMyDrawer(BuildContext context) {
    return MyDrawer(
      nomUtilisateur: myUtilisateur.nom,
      listWidges: [
        labelTask('المهام', colorThird!),
        listTile(Icons.school, colorThird, 'إدارة مدرسة', () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DirectionSchool(myUtilisateur: myUtilisateur),
              ));
        }),
        listTile(Icons.badge, colorPrimary, 'انتساب لمدرسة', () {}),
        listTile(Icons.account_balance, colorGreen, 'بيانات الحساب', () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MyCompteData(myUtilisateur: myUtilisateur),
              ));
          // //Navigator.pop(context);
        }),
        listTile(Icons.exit_to_app, colorRed, 'خروج', () {
          myShowDialogYesNo(
            context,
            'هل تربد حقا غلق التطبيق؟',
            () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, Login.root);
            },
          );
        }),
      ],
    );
  }
}
