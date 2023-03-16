import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import '../fonctions/fonctions.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
import '../widgets/icons.dart';
import '../widgets/pin_put.dart';
import '../widgets/text_field.dart';
import '../widgets/whats_operator.dart';
import 'login.dart';

class Registration extends StatefulWidget {
  static const root = 'Registration';
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool isLoading = false;
  final nomController = TextEditingController();
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final mailController = TextEditingController();
  int numPhone = 0;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isRegistrationOK = false;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    AlertController.onTabListener(
        (Map<String, dynamic>? payload, TypeAlert type) {
      print("$payload - $type");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundPrimary,
      appBar: AppBar(
        title: const Text('فتح حساب'),
        centerTitle: true,
      ),
      body: isLoading
          ? const ContainerIndicator()
          : ContainerNoIndicator(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/appstore.png',
                    height: 170,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: !isRegistrationOK
                        ? cardRegistration()
                        : cardRegistrationSuccess(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لديك حساب؟'),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Login.root);
                        },
                        child: const Text('قم بالولوج إليه من هنا'),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Card cardRegistration() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Form(
            key: formState,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'البيانات المطلوبة لفتح حساب',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  prefix: const MyIcon(icon: Icons.person),
                  labelText: 'الاسم الشخصي',
                  controller: nomController,
                  onChanged: (p0) {},
                  onValidator: (val) {
                    if (val!.isEmpty) {
                      return 'الاسم الشخصي مطلوب';
                    }
                    if (nomController.text.length < 3) {
                      return 'الاسم ينبغي أن يتكون من 3 أحرف على الأقل';
                    }
                    return null;
                  },
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
                    MyTextFormField(
                      prefix: const MyIcon(icon: Icons.phone),
                      labelText: 'الهاتف الشخصي',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (p0) {
                        setState(() {
                          numPhone = phoneController.text.length;
                        });
                      },
                      onValidator: (val) {
                        if (val!.isEmpty) {
                          return 'الهاتف الشخصي مطلوب';
                        }
                        if (!phoneNumberValidator(phoneController.text)) {
                          return 'رقم الهاتف غير صحيح';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const Text('الرمز الشخصي'),
                MyPinPut(
                  pinController: codeController,
                  onValidator: (val) {
                    if (val!.isEmpty) {
                      return 'الرمز الشخصي مطلوب';
                    }
                    if (codeController.text.length < 4) {
                      return 'الرمز الشخصي ينبغي أن يتكون من 4 أرقام على الأقل';
                    }
                    return null;
                  },
                ),
                MyTextFormField(
                  prefix: const MyIcon(
                    icon: Icons.mail,
                  ),
                  labelText: 'البريد الالكتروني',
                  hintText: 'لاستعادة الرمز الشخصي في حالة نسيانه',
                  controller: mailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (p0) {},
                  onValidator: (val) {
                    if (mailController.text.isNotEmpty &&
                        !isEmail(mailController.text)) {
                      return 'البريد الالكتروني غير صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                MyButton(
                    color: colorPrimary!,
                    title: 'فتح حساب',
                    onPressed: () {
                      registration();
                    }),
                const SizedBox(
                  height: 30,
                ),
              ],
            )),
      ),
    );
  }

  Card cardRegistrationSuccess() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              'تم فتح حسابكم بنجاح\nيمكنكم الولوج إلى التطبيق من خلال صفحة الولوج',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorGreen, fontSize: 22),
            ),
            const SizedBox(
              height: 25,
            ),
            MyButton(
                color: colorGreen!,
                title: 'صفحة الولوج',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Login.root);
                }),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  registration() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: 'agep${phoneController.text}@gmail.com',
                password: '@nrptS${codeController.text}');
        if (userCredential.user != null) {
          setState(() {
            isLoading = false;
            isRegistrationOK = true;
          });
          addEmailToEmailsCollection();
          //mailController.text.isNotEmpty ? registrationToo() : null;
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          myShowDialog(context, 'حبذا تغيير الرمز الشخصي');
        } else if (e.code == 'email-already-in-use') {
          myShowDialog(context, 'الهاتف الشخصي المدخل لديه حساب سلفا');
        } else {
          myShowDialog(context, 'حدث خطأ أثناء التسجيل\n ${e.code}');
        }
      } catch (r) {
        setState(() {
          isLoading = false;
        });
        myShowDialog(context, 'حدث خطأ أثناء التسجيل\n $r');
      }
    }
  }

  registrationToo() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mailController.text, password: '@nrptS${codeController.text}');
      // ignore: empty_catches
    } catch (r) {}
  }

  addEmailToEmailsCollection() async {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection("emails");
    collRef.doc(phoneController.text).set({
      'phone': phoneController.text,
      'email': mailController.text.isNotEmpty
          ? mailController.text
          : 'ageprim2023@gmail.com',
    });
  }
}
