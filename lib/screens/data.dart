import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:my_school_rim/widgets/text_field.dart';

import '../fonctions/fonctions.dart';
import '../models/utilisateurs.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
import '../widgets/icons.dart';
import '../widgets/pin_put.dart';

class Data extends StatefulWidget {
  static const root = 'Data';
  
  final Utilisateur utilisateur;
  
  const Data({super.key, required this.utilisateur});

  @override
  // ignore: no_logic_in_create_state
  State<Data> createState() => _DataState(utilisateur);
}

class _DataState extends State<Data> {
  final phoneController = TextEditingController();
  final nomController = TextEditingController();
  final codeController = TextEditingController();
  final askController = TextEditingController();
  final answerController = TextEditingController();
  final Utilisateur utilisateur;
  bool isShowPassword = false;

  _DataState(this.utilisateur);

  @override
  void initState() {
    phoneController.text = utilisateur.phone;
    nomController.text = utilisateur.nom;
    codeController.text = utilisateur.code;
    askController.text = utilisateur.ask;
    answerController.text = utilisateur.answer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //utilisateur = ModalRoute.of(context)?.settings.arguments as Utilisateur?;
    
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(),
      body: ContainerNormal(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Center(
                child: Column(
                  children: [
                    Stack(children: [
                      Image.asset(
                        'assets/images/appstore.png',
                        height: 170,
                      ),
                      InkWell(
                        child: const MyIcon(
                          icon: Icons.camera_alt,
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
                                color: isShowPassword ? colorGreen : colorRed,
                              ),
                            ),
                            const Text('الرمز الشخصي'),
                          ],
                        ),
                        isShowPassword
                            ? Container(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: colorGreen,
                                ),
                                child: Text(
                                  codeController.text,
                                  style: const TextStyle(color: colorWhite),
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
                                dropdownAlert(
                                    'الاسم الشخصي مطلوب',
                                    TypeAlert.error);
                                return;
                              }
                              if (codeController.text.length<4) {
                                dropdownAlert(
                                    'الرمز الشخصي مطلوب',
                                    TypeAlert.error);
                                return;
                              }
                              if (askController.text.isEmpty && answerController.text.isNotEmpty) {
                                dropdownAlert(
                                    'يوجد جواب، فماهو السؤال؟',
                                    TypeAlert.error);
                                return;
                              }
                              if (answerController.text.isEmpty &&
                                  askController.text.isNotEmpty) {
                                dropdownAlert('يوجد سؤال، فماهو الجواب؟', TypeAlert.error);
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
          ),
        ),
      ),
    );
  }

  registration() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User? currentUser = firebaseAuth.currentUser;
      currentUser
          ?.updatePassword("@nrptS${codeController.text}")
          .then((val) {})
          .catchError((err) {
        // An error has occured.
      });
      addEmailToEmailsCollection();
      Navigator.pop(context);
      dropdownAlert('تم الحفظ بنجاح', TypeAlert.success);
    } catch (r) {}
  }

  addEmailToEmailsCollection() async {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection("emails");
    collRef.doc(phoneController.text).update({
      'nom': nomController.text,
      //'phone': phoneController.text,
      'code': codeController.text,
      'ask': askController.text,
      'answer': answerController.text,
    });
  }
}
