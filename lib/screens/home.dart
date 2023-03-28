import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_school_rim/models/utilisateurs.dart';

import '../fonctions/fonctions.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('الرئيسية'),
      ),
      body: const Text('data'),
      drawer: MyDrawer(
        nomUtilisateur: myUtilisateur.nom,
        listWidges: [
          labelTask('المهام', colorThird!),
          listTile(Icons.school, colorThird, 'إدارة مدرسة', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, DirectionSchool.root);
          }),
          listTile(Icons.badge, colorPrimary, 'انتساب لمدرسة', () {}),
          listTile(Icons.account_balance, colorGreen, 'بيانات الحساب', () {
            //Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyCompteData(myUtilisateur: myUtilisateur),
                ));
          }),
          listTile(Icons.exit_to_app, colorRed, 'خروج', () {
            myShowDialogYesNo(context, 'هل تربد حقا غلق التطبيق؟', () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, Login.root);
            });
          }),
        ],
      ),
    );
  }
}
