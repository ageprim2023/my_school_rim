import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../fonctions/fonctions.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
import '../widgets/pin_put.dart';
import '../widgets/text_field.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import '../widgets/whats_operator.dart';
import 'login.dart';

class Registration extends StatefulWidget {
  static const String root = 'Registration';
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool isLoading = false;
  final nomController = TextEditingController();
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  int numPhone = 0;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isRegistrationOK = false;

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
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        myShowDialog(context, 'حدث خطأ أثناء التسجيل\n ${e.code}');
      } catch (r) {
        setState(() {
          isLoading = false;
        });
        myShowDialog(context, 'حدث خطأ أثناء التسجيل\n $r');
      }
    }
  }

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
                  prefix: const Icon(Icons.person),
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
                      prefix: const Icon(Icons.phone),
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
}
