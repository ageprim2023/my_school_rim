import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import '../fonctions/fonctions.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
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

void _success(String message) {
  Map<String, dynamic> payload = new Map<String, dynamic>();
  payload["data"] = "content";
  AlertController.show("", message, TypeAlert.success, payload);
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  int numPhone = 0;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isForget = false;

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
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
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
        setState(() {
          isForget = true;
        });
        _success('يتم الآن ارسال رسالة SMS إلى هاتفكم');
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

  verfied() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+222${phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          myShowDialog(context, '${e.message}');
          //   myShowDialog(context,
          //       'حدثت مشكلة أثناء الاتصال بالسيرفر، ربما تتعلق بمدى قوة الانترنت لديكم، يرجى إعادة المحاولة بعد دقائق');
          //print('${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          myShowDialog(context,
              'تم ارسال رسالة SMS على رقم هاتفكم بها رمز التحقق، يرجى ادخاله في حقل رمز التحقق');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      myShowDialog(context, '${e.message}');
    }
  }

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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                      onPressed: () {
                        if (!phoneNumberValidator(phoneController.text)) {
                          myShowDialog(context, 'رقم الهاتف غير صحيح');
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
              Container(
                height: 70,
                child: isForget
                    ? MyTextFormField(
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.verified_user),
                        labelText: 'رمز التحقق',
                        controller: smsController,
                        onChanged: (val) {},
                        onValidator: (val) {
                          return null;
                        },
                        suffix: MyButton(
                          title: 'تحقق',
                          onPressed: () {
                            if (smsController.text.isEmpty) {
                              myShowDialog(context, 'رمز التحقق مطلوب');
                              return;
                            }
                            if (smsController.text.length < 6 ||
                                smsController.text.length > 6) {
                              myShowDialog(context,
                                  'ينبغي أن يتكون رمز التحقق من 6 أرقام');
                              return;
                            }
                          },
                          color: colorGreen!,
                          minWidth: 100,
                        ),
                      )
                    : null,
              ),
              Container(
                child: !isForget
                    ? MyButton(
                        color: colorThird!,
                        title: 'ولوج',
                        onPressed: () {
                          access();
                        })
                    : null,
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
}
