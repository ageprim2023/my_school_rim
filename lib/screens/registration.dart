import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import '../fonctions/fonctions.dart';
import '../main.dart';
import '../tools/collections.dart';
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
  final askController = TextEditingController();
  final answerController = TextEditingController();
  int numPhone = 0;
  bool isRegistrationOK = false;
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSecondary,
      // appBar: AppBar(
      //   title: const Text('فتح حساب'),
      //   centerTitle: true,
      // ),
      body: Stack(children: [
        ContainerNormal(
          child: Column(
            children: [
              !isRegistrationOK
                  ? cardRegistration()
                  : cardRegistrationSuccess(),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorForth,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: !isRegistrationOK
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب؟',
                              style: TextStyle(color: colorWhite),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, Login.root);
                              },
                              child: Text(
                                'قم بالولوج إليه من هنا',
                                style: TextStyle(color: colorGreen),
                              ),
                            )
                          ],
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: isLoading ? const ContainerIndicator() : null,
        )
      ]),
    );
  }

  Widget cardRegistration() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
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
                'البيانات المطلوبة لفتح حساب',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              MyTextField(
                prefix: const MyIcon(icon: Icons.person),
                textController: nomController,
                myTitle: 'الاسم الشخصي',
                onChange: (val) {},
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
                    keyboardType: TextInputType.phone,
                    prefix: const MyIcon(icon: Icons.phone),
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
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorblue200),
                child: Column(
                  children: [
                    Text(
                      'لإضافة وسيلة لاستعادة الرمز الشخصي في حال نسيانه',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorPrimary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              showBottomSheet();
                            },
                            child: Text(
                              'اضغط هنا',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            'اختياري',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              MyButton(
                  color: colorPrimary!,
                  title: 'افتح الحساب',
                  onPressed: () {
                    if (nomController.text.isEmpty) {
                      dropdownAlert('الاسم الشخصي إلزامي', TypeAlert.error);
                      return;
                    }
                    if (!phoneNumberValidator(phoneController.text)) {
                      dropdownAlert('الهاتف الشخصي إلزامي', TypeAlert.error);
                      return;
                    }
                    if (codeController.text.length < 4) {
                      dropdownAlert('الرمز الشخصي إلزامي', TypeAlert.error);
                      return;
                    }
                    registration();
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

  Widget cardRegistrationSuccess() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: [
              Image.asset(
                'assets/images/appstore.png',
                height: 170,
              ),
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
      ),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ContainerNormal(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'المطلوب هنا هو انشاء سؤال وجواب من طرفكم.',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  textController: askController,
                  myTitle: 'أنشئ سؤالا تشاؤه',
                  onChange: (val) {},
                ),
                MyTextField(
                  textController: answerController,
                  myTitle: 'ادخل جوابا تشاؤه',
                  onChange: (val) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                    'الهدف هنا هو أنه في حال أنكم نسيتم رمزكم الشخصي، سيتم تذكيركم بالسؤال الذي أنشأتم لتعطوا أنتم من خلاله الجواب الذي اخترتم، ليتم منحكم بذلك الرمز الشخصي.'),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButton(
                        title: 'تأكيد',
                        minWidth: 60,
                        onPressed: () {
                          if (askController.text.isEmpty) {
                            dropdownAlert(
                                'إنشاء السؤال مطلوب', TypeAlert.error);
                            return;
                          }
                          if (answerController.text.isEmpty) {
                            dropdownAlert(
                                'إدخال الجواب إلزامي', TypeAlert.error);
                            return;
                          }
                          Navigator.pop(context);
                        },
                        color: colorGreen!),
                    MyButton(
                        title: 'إلغاء',
                        minWidth: 60,
                        onPressed: () {
                          askController.text = '';
                          answerController.text = '';
                          Navigator.pop(context);
                        },
                        color: colorRed!),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                const Text(
                    'يمكنكم الغاء العملية في حال أنكم لا ترون ضرورة لها'),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  registration() async {
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
        addCompteDataToUtilisateursCollection();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        dropdownAlert('حبذا تغيير الرمز الشخصي', TypeAlert.error);
      } else if (e.code == 'email-already-in-use') {
        dropdownAlert('الهاتف الشخصي المدخل لديه حساب سلفا', TypeAlert.error);
      } else {
        dropdownAlert('حدث خطأ أثناء التسجيل\n ${e.code}', TypeAlert.error);
      }
    } catch (r) {
      setState(() {
        isLoading = false;
      });
      dropdownAlert('حدث خطأ أثناء التسجيل\n $r', TypeAlert.error);
    }
  }

  addCompteDataToUtilisateursCollection() async {
    FirebaseFirestore.instance
        .collection(utilisateursCollection)
        .doc(phoneController.text)
        .set({
      utilisateursCollectionNom: nomController.text,
      utilisateursCollectionPhone: phoneController.text,
      utilisateursCollectionCode: codeController.text,
      utilisateursCollectionAsk: askController.text,
      utilisateursCollectionAnswer: answerController.text,
      utilisateursCollectionToken: myToken,
      utilisateursCollectionIsNewToken: false,
      utilisateursCollectionScools: ['']
    });
  }
}
