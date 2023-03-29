import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_school_rim/models/utilisateurs.dart';

import '../fonctions/fonctions.dart';
import '../tools/styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/drawer.dart';
import 'direction_shcool.dart';
import 'login.dart';
import 'my_compte_data.dart';

enum SingingCharacter { free, paye }

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

  SingingCharacter? _character = SingingCharacter.free;

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
            myShowDialogWidgetYesNo(
              context,
              [
                Column(
                  children: [
                    const Text(
                      'إدارة مدرسة :',
                      style:
                          TextStyle(decoration: TextDecoration.underline),
                    ),
                    ListTile(
                      title: const Text(
                          'لمدة محددة، مجانية 30 يوما'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.free,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('لمدة غير محددة، مدفوعة الثمن'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.paye,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
              () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DirectionSchool(myUtilisateur: myUtilisateur),
                    ));
              },
            );
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
      ),
    );
  }
}
