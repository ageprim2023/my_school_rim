import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:my_school_rim/models/utilisateurs.dart';

import '../fonctions/fonctions.dart';
import '../tools/collections.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
import '../widgets/icons.dart';
import '../widgets/pin_put.dart';
import '../widgets/text_field.dart';
import 'home.dart';

class MyCompteData extends StatefulWidget {
  static const root = 'MyCompteData';
  final Utilisateur myUtilisateur;
  const MyCompteData({super.key, required this.myUtilisateur});

  @override
  // ignore: no_logic_in_create_state
  State<MyCompteData> createState() => _MyCompteDataState(myUtilisateur);
}

class _MyCompteDataState extends State<MyCompteData> {
  final Utilisateur myUtilisateur;
  final phoneController = TextEditingController();
  final nomController = TextEditingController();
  final codeController = TextEditingController();
  final askController = TextEditingController();
  final answerController = TextEditingController();
  bool isLoading = false;
  bool isShowPassword = false;
  late Utilisateur utilisateur;

  _MyCompteDataState(this.myUtilisateur);

  @override
  void initState() {
    phoneController.text = myUtilisateur.phone;
    nomController.text = myUtilisateur.nom;
    codeController.text = myUtilisateur.code;
    askController.text = myUtilisateur.ask;
    answerController.text = myUtilisateur.answer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: const Text('بيانات الحساب'),
        ),
        body: Stack(
          children: [
            ContainerNormal(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  child: Stack(alignment: Alignment.topLeft, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Home(myUtilisateur: myUtilisateur),
                              ));
                        },
                        icon: MyIcon(
                          icon: Icons.close_outlined,
                          color: colorRed,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Center(
                        child: Column(
                          children: [
                            Stack(children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/1234.png'),
                                radius: 80,
                              ),
                              InkWell(
                                child: MyIcon(
                                  icon: Icons.add_a_photo,
                                  color: colorPrimary,
                                ),
                                onTap: () {
                                  //myShowDialog(context, 'title');
                                },
                              ),
                            ]),
                            const Text(
                              'بيانات الحساب',
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              enabled: false,
                              prefix: const MyIcon(icon: Icons.phone),
                              textController: phoneController,
                              myTitle: 'الهاتف الشخصي',
                              onChange: (val) {},
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                MyTextField(
                                  prefix: const MyIcon(icon: Icons.person),
                                  textController: nomController,
                                  myTitle: 'الاسم الشخصي',
                                  onChange: (val) {},
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (codeController.text.isNotEmpty) {
                                          setState(() {
                                            isShowPassword
                                                ? isShowPassword = false
                                                : isShowPassword = true;
                                          });
                                        }
                                      },
                                      icon: MyIcon(
                                        icon: Icons.remove_red_eye,
                                        color: isShowPassword
                                            ? colorGreen
                                            : colorRed,
                                      ),
                                    ),
                                    const Text('الرمز الشخصي'),
                                  ],
                                ),
                                isShowPassword
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: colorGreen,
                                        ),
                                        child: Text(
                                          codeController.text,
                                          style: const TextStyle(
                                              color: colorWhite),
                                        ))
                                    : MyPinPut(
                                        pinController: codeController,
                                      ),
                                const SizedBox(
                                  height: 8,
                                ),
                                MyTextField(
                                  prefix: const MyIcon(icon: Icons.security),
                                  textController: askController,
                                  myTitle: 'سؤال الأمان',
                                  onChange: (val) {},
                                ),
                                MyTextField(
                                  prefix: const MyIcon(icon: Icons.abc),
                                  textController: answerController,
                                  myTitle: 'الجواب',
                                  onChange: (val) {},
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                MyButton(
                                    color: colorGreen!,
                                    title: 'حفظ البيانات',
                                    onPressed: () {
                                      if (nomController.text.isEmpty) {
                                        dropdownAlert('الاسم الشخصي مطلوب',
                                            TypeAlert.error);
                                        return;
                                      }
                                      if (codeController.text.length < 4) {
                                        dropdownAlert('الرمز الشخصي مطلوب',
                                            TypeAlert.error);
                                        return;
                                      }
                                      if (askController.text.isEmpty &&
                                          answerController.text.isNotEmpty) {
                                        dropdownAlert(
                                            'يوجد جواب، فماهو السؤال؟',
                                            TypeAlert.error);
                                        return;
                                      }
                                      if (answerController.text.isEmpty &&
                                          askController.text.isNotEmpty) {
                                        dropdownAlert(
                                            'يوجد سؤال، فماهو الجواب؟',
                                            TypeAlert.error);
                                        return;
                                      }
                                      registration();
                                    }),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Container(
              child: isLoading ? const ContainerIndicator() : null,
            )
          ],
        ));
  }

  registration() async {
    try {
      setState(() {
        isLoading = true;
      });
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User? currentUser = firebaseAuth.currentUser;
      currentUser?.updatePassword("@nrptS${codeController.text}").then((val) {
        updateMyComptesDataInEmailsCollection();
        utilisateur = Utilisateur(
            nomController.text,
            myUtilisateur.phone,
            codeController.text,
            askController.text,
            answerController.text,
            myUtilisateur.token,
            myUtilisateur.isNewToken);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(myUtilisateur: utilisateur),
            ));
        setState(() {
          isLoading = false;
        });
        dropdownAlert('تم الحفظ بنجاح', TypeAlert.success);
      }).catchError((err) {
        // An error has occured.
      });
    } catch (r) {
      setState(() {
        isLoading = false;
      });
      myShowDialog(context, '$r');
    }
  }

  updateMyComptesDataInEmailsCollection() async {
    FirebaseFirestore.instance
        .collection(utilisateursCollection)
        .doc(phoneController.text)
        .update({
      utilisateursCollectionNom: nomController.text,
      utilisateursCollectionCode: codeController.text,
      utilisateursCollectionAsk: askController.text,
      utilisateursCollectionAnswer: answerController.text,
    });
  }
}
