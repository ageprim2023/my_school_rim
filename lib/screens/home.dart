import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_school_rim/tools/styles.dart';

import '../fonctions/fonctions.dart';
import '../models/utilisateurs.dart';
import '../tools/collections.dart';
import '../widgets/container_indicator.dart';
import '../widgets/drawer.dart';
import '../widgets/icons.dart';
import 'direction_shcool.dart';
import 'login.dart';
import 'my_compte_data.dart';

class Home extends StatefulWidget {
  static const root = 'Home';
  final Utilisateur myUtilisateur;

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

  late List myListSchools;

  @override
  void initState() {
    myListSchools = myUtilisateur.schools;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('قائمة مدارسي'),
      ),
      drawer: getMyDrawer(context),
      body: ContainerNormal(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(schoolsCollection)
                  .where(schoolsCollectionCode, whereIn: myListSchools)
                  //.orderBy(schoolsCollectionNom)
                  .snapshots(),
              builder: (context, snapshot) {
                List<Widget> mySchools = [];
                if (snapshot.hasData) {
                  for (QueryDocumentSnapshot school in snapshot.data!.docs) {
                    String free = school.get(schoolsCollectionFreeOrPaye);
                    mySchools.add(Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Card(
                        child: ListTile(
                          leading: MyIcon(
                            icon: Icons.school,
                            color: free != 'free' ? colorGreen : colorRed,
                          ),
                          title: Text('${school.get(schoolsCollectionNom)}'),
                          subtitle: const Text('مدير عام'),
                          trailing: Text(
                            'كود\n${school.get(schoolsCollectionCode)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: colorPrimary),
                          ),
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
                      child:
                          !snapshot.hasData ? const ContainerIndicator() : null,
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  MyDrawer getMyDrawer(BuildContext context) {
    return MyDrawer(
      nomUtilisateur: myUtilisateur.nom,
      listWidges: [
        labelTask('المهام', colorThird!),
        listTile(Icons.manage_accounts, colorPrimary, 'طلب إدارة مدرسة', () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DirectionSchool(myUtilisateur: myUtilisateur),
              ));
        }),
        listTile(Icons.badge, colorGreen, 'طلب انتساب لمدرسة', () {}),
        listTile(Icons.account_balance, colorSecondary, 'بيانات الحساب', () {
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
