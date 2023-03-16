import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../fonctions/fonctions.dart';
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
  int numPhone = 0;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isForget = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundPrimary,
      appBar: AppBar(
        title: const Text('صفحة الولوج'),
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
                    child: cardAccess(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
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
                  )
                ],
              ),
            ),
    );
  }

  Card cardAccess() {
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                      onPressed: () {
                        if (phoneController.text.isEmpty) {
                          myShowDialog(context, 'ادخل رقم الهاتف أولا');
                          return;
                        }
                        if (!phoneNumberValidator(phoneController.text)) {
                          myShowDialog(context, 'رقم الهاتف غير صحيح');
                          return;
                        }
                        myShowDialogYesNo(
                            context, 'هل حقا نسيتم الرقم الشخصي خاصتكم؟', () {
                          Navigator.pop(context);
                          forgetCode();
                        });
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
                height: 90,
              ),
              MyButton(
                  color: colorGreen!,
                  title: 'ولوج',
                  onPressed: () {
                    access();
                  }),
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
    var formData = formState.currentState;
    if (formData!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: 'agep${phoneController.text}@gmail.com',
                password: '@nrptS${codeController.text}');
        if (userCredential.user != null) {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, Home.root);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'user-not-found') {
          myShowDialog(context, 'رقم الهاتف الشخصي الذي أدخلتم غير مسجل');
        } else if (e.code == 'wrong-password') {
          myShowDialog(context, 'الرمز السري الذي أدخلتم غير صحيح');
        } else {
          myShowDialog(context, 'حدث خطأ أثناء محاولة الولوج\n ${e.code}');
        }
      } catch (r) {
        setState(() {
          isLoading = false;
        });
        myShowDialog(context, 'حدث خطأ أثناء محاولة الولوج\n $r');
      }
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
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        myShowDialog(context, 'رقم الهاتف الشخصي الذي أدخلتم غير مسجل');
      } else if (e.code == 'wrong-password') {
        /////
        resetPassword();
        /////
      } else {
        myShowDialog(context, 'حدث خطأ أثناء محاولة الولوج\n ${e.code}');
      }
    } catch (r) {
      setState(() {
        isLoading = false;
      });
      myShowDialog(context, 'حدث خطأ أثناء محاولة الولوج\n $r');
    }
  }

  Future resetPassword() async {
    String email = '';
    DocumentReference doc = FirebaseFirestore.instance
        .collection("emails")
        .doc(phoneController.text);
    await doc.get().then((value) async {
      if (value.exists) {
        email = value['email'];
        await auth.sendPasswordResetEmail(email: email).then((value) {
          print("send ***********************************");
        }).catchError((e) {
          print("$e ***********************************");
        });
      } else {
        myShowDialog(context, 'يرجى التواصل مع المبرمج');
      }
    });
  }
}
