import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import '../fonctions/fonctions.dart';
import '../main.dart';
import '../models/utilisateurs.dart';
import '../tools/collections.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
import '../widgets/icons.dart';
import '../widgets/pin_put.dart';
import '../widgets/text_field.dart';
import '../widgets/whats_operator.dart';
import 'home.dart';
import 'registration.dart';

class Login extends StatefulWidget {
  static const root = 'Login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final answerController = TextEditingController();
  int numPhone = 0;
  bool isForget = false;
  bool newToken = false;
  bool enablePhoneController = true;
  final auth = FirebaseAuth.instance;
  bool isShowPassword = false;
  Utilisateur utilisateur = Utilisateur.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSecondary,
      // appBar: AppBar(
      //   title: const Text('صفحة الولوج'),
      //   centerTitle: true,
      // ),
      body: Stack(children: <Widget>[
        ContainerNormal(
          child: Column(
            children: [
              cardAccess(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorForth,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟'),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Registration.root);
                        },
                        child: const Text('قم بفتح حساب من هنا'),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36, right: 36),
                child: Container(
                  decoration: BoxDecoration(
                    //color: colorWhite,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('للاتصال بنا'),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: MyIcon(
                            icon: Icons.phone, color: colorGreen, size: 36),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: MyIcon(
                            icon: Icons.speaker_phone,
                            color: colorPrimary,
                            size: 36),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          child: isLoading ? const ContainerIndicator() : null,
        )
      ]),
    );
  }

  Widget cardAccess() {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Image.asset(
                'assets/images/appstore.png',
                height: 170,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'البيانات المطلوبة للولوج',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: numPhone > 0
                        ? WhatOperator(
                            number: phoneController.text,
                          )
                        : null,
                  ),
                  MyTextField(
                    enabled: enablePhoneController,
                    prefix: const MyIcon(icon: Icons.phone),
                    keyboardType: TextInputType.phone,
                    textController: phoneController,
                    myTitle: 'الهاتف الشخصي',
                    onChange: (val) {
                      setState(() {
                        numPhone = phoneController.text.length;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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
                      padding: const EdgeInsets.only(left: 12, right: 12),
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
                height: 40,
              ),
              MyButton(
                  color: colorGreen!,
                  title: 'ولوج',
                  onPressed: () {
                    if (!phoneNumberValidator(phoneController.text)) {
                      dropdownAlert('الهاتف الشخصي إلزامي', TypeAlert.error);
                      return;
                    }
                    if (codeController.text.length < 4) {
                      dropdownAlert('الرمز الشخصي إلزامي', TypeAlert.error);
                      return;
                    }
                    access();
                  }),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  newToken
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: () {
                              if (!phoneNumberValidator(phoneController.text)) {
                                dropdownAlert(
                                    'الهاتف الشخصي إلزامي', TypeAlert.error);
                                return;
                              }
                              updateTokenInUtilisateursCollection();
                            },
                            child: Text(
                              'تأكيد السماح',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorGreen,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                      onPressed: () {
                        if (!phoneNumberValidator(phoneController.text)) {
                          dropdownAlert(
                              'الهاتف الشخصي إلزامي', TypeAlert.error);
                          return;
                        }
                        forgetCode();
                      },
                      child: Text(
                        'هل نسيت الرمز الشخصي؟',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  access() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: 'agep${phoneController.text}@gmail.com',
              password: '@nrptS${codeController.text}');
      if (userCredential.user != null) {
        getDataFromUtilisateursCollection();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        dropdownAlert(
            'رقم الهاتف الشخصي الذي أدخلتم غير مسجل', TypeAlert.error);
      } else if (e.code == 'wrong-password') {
        dropdownAlert('الرمز السري الذي أدخلتم غير صحيح', TypeAlert.error);
      } else if (e.code == 'network-request-failed') {
        dropdownAlert('توجد مشكلة في الانترنت لديكم', TypeAlert.error);
      } else {
        dropdownAlert(
            'حدث خطأ أثناء محاولة الولوج\n ${e.code}', TypeAlert.error);
      }
    } catch (r) {
      setState(() {
        isLoading = false;
      });
      dropdownAlert('حدث خطأ أثناء محاولة الولوج\n $r', TypeAlert.error);
    }
  }

  forgetCode() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'agep${phoneController.text}@gmail.com',
          password: '@nrptSagep3344');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        dropdownAlert(
            'رقم الهاتف الشخصي الذي أدخلتم غير مسجل', TypeAlert.error);
      } else if (e.code == 'wrong-password') {
        /////
        getCode();
        /////
      } else {
        setState(() {
          isLoading = false;
        });
        dropdownAlert(
            'حدث خطأ أثناء محاولة الولوج\n ${e.code}', TypeAlert.error);
      }
    } catch (r) {
      setState(() {
        isLoading = false;
      });
      dropdownAlert('حدث خطأ أثناء محاولة الولوج\n $r', TypeAlert.error);
    }
  }

  Future getCode() async {
    await FirebaseFirestore.instance
        .collection("emails")
        .doc(phoneController.text)
        .get()
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.exists) {
        if (value['ask'] == '') {
          dropdownAlert(
              'لم تقوموا بإضافة وسيلة لاستعادة الرمز الشخصي، لذا يرجى التواصل مع المبرمج',
              TypeAlert.error);
          return;
        }
        myShowDialogWithField(context, 'سؤالكم كان:', value['ask'], () {
          Navigator.pop(context);
          if (answerController.text == value['answer']) {
            dropdownAlert(
                'صح،\n رمزكم الشخصي هو ${value['code']}', TypeAlert.success);
          } else {
            dropdownAlert('خطأ، يرجى إعادة المحاولة', TypeAlert.error);
          }
        });
      } else {
        dropdownAlert('يرجى التواصل مع المبرمج', TypeAlert.warning);
      }
    });
  }

  Future<void> myShowDialogWithField(
    BuildContext context,
    String title,
    String quation,
    VoidCallBack onPressed,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.info),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: colorPrimary,
                  ),
                ),
                Text(
                  quation,
                  style: TextStyle(
                    color: colorThird,
                  ),
                ),
                MyTextField(
                  textController: answerController,
                  myTitle: 'فما هو الجواب؟',
                  onChange: (val) {},
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed,
              child: Text(
                'تأكيد',
                style: TextStyle(
                  //fontFamily: 'Amiri',
                  color: colorGreen,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              child: Text(
                'إلغاء',
                style: TextStyle(
                  //fontFamily: 'Amiri',
                  color: colorRed,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getDataFromUtilisateursCollection() async {
    try {
      await FirebaseFirestore.instance
          .collection(utilisateursCollection)
          .doc(phoneController.text)
          .get()
          .then((value) => {
                utilisateur = Utilisateur(
                    value[utilisateursCollectionNom],
                    value[utilisateursCollectionPhone],
                    value[utilisateursCollectionCode],
                    value[utilisateursCollectionAsk],
                    value[utilisateursCollectionAnswer],
                    value[utilisateursCollectionToken],
                    value[utilisateursCollectionIsNewToken],
                    value[utilisateursCollectionScools])
              });
      if (utilisateur.token == myToken) {
        //dropdownAlert('تم الولوج بنجاح', TypeAlert.success);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(myUtilisateur: utilisateur),
            ));
      } else {
        dropdownAlert(
            'الولوج غير ممكن، نظرا لأنكم غيرتم هاتفكم، أو قمتم بتهيئته، يرجى الاتصال بالمبرمج',
            TypeAlert.error);
        setState(() {
          isLoading = false;
          newToken = utilisateur.isNewToken;
          enablePhoneController = false;
        });
      }
    } catch (e) {
      myShowDialog(context, '$e');
    }
  }

  updateTokenInUtilisateursCollection() async {
    FirebaseFirestore.instance
        .collection(utilisateursCollection)
        .doc(phoneController.text)
        .update({
      utilisateursCollectionToken: myToken,
      utilisateursCollectionIsNewToken: false,
    });
    setState(() {
      newToken = false;
      enablePhoneController = true;
    });
    dropdownAlert('أصبح بإمكانكم الآن الولوج من هذا الهاتف', TypeAlert.success);
  }
}
