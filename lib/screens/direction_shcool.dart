import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:my_school_rim/screens/home.dart';

import '../fonctions/fonctions.dart';
import '../models/utilisateurs.dart';
import '../tools/collections.dart';
import '../tools/styles.dart';
import '../widgets/buttons.dart';
import '../widgets/container_indicator.dart';
import '../widgets/text_field.dart';

enum SingingCharacter { free, paye }

class DirectionSchool extends StatefulWidget {
  static const root = 'DirectionSchool';
  final Utilisateur myUtilisateur;
  const DirectionSchool({super.key, required this.myUtilisateur});

  @override
  // ignore: no_logic_in_create_state
  State<DirectionSchool> createState() => _DirectionSchoolState(myUtilisateur);
}

class _DirectionSchoolState extends State<DirectionSchool> {
  final Utilisateur myUtilisateur;
  bool isLoading = false;
  bool isChoosed = false;
  bool saveVisible = true;
  late bool isValidation;
  TextEditingController nomController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController anneeController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController dirController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late int myCode;
  late SingingCharacter character;
  late DateTime dateValidation;
  late String freeOrPaye;
  late List mySchools;
  late Utilisateur utilisateur;

  _DirectionSchoolState(this.myUtilisateur);

  @override
  void initState() {
    character = SingingCharacter.free;
    dirController.text = myUtilisateur.nom;
    phoneController.text = myUtilisateur.phone;
    mySchools = myUtilisateur.schools;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSecondary,
      appBar: AppBar(title: const Text('إدارة مدرسة'), centerTitle: true),
      body: Stack(
        children: [
          ContainerNormal(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: saveVisible ? choosingTypeDirection() : null,
                ),
                Container(child: !saveVisible ? cardData(context) : null),
              ],
            ),
          ),
          Container(
            child: isLoading ? const ContainerIndicator() : null,
          )
        ],
      ),
    );
  }

  Card cardData(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          children: [
            character == SingingCharacter.free
                ? Text(
                    textAlign: TextAlign.center,
                    'هذه النسخة صالحة لغاية\n $dateValidation \n في حال قمتم بإدخال البيانات أسفله والموافقة عليها',
                    style: TextStyle(color: colorRed),
                  )
                : Text(
                    textAlign: TextAlign.center,
                    'ينبغي التواصل مع المبرمج لتفعيل هذه النسخة \n في حال قمتم بإدخال البيانات أسفله والموافقة عليها',
                    style: TextStyle(color: colorGreen),
                  ),
            const SizedBox(
              height: 22,
            ),
            const Text(
              'بيانات المدرسة',
              style:
                  TextStyle(decoration: TextDecoration.underline, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: MyTextField(
                      keyboardType: TextInputType.name,
                      textController: nomController,
                      myTitle: 'اسم المدرسة',
                      onChange: (val) {}),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: MyTextField(
                    enabled: false,
                    textController: codeController,
                    myTitle: 'كود المدرسة',
                    onChange: (val) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    keyboardType: TextInputType.number,
                    textController: numController,
                    myTitle: 'رقم الترخيص',
                    onChange: (val) {},
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: MyTextField(
                    keyboardType: TextInputType.number,
                    textController: anneeController,
                    myTitle: 'سنة الترخيص',
                    onChange: (val) {},
                  ),
                ),
              ],
            ),
            MyTextField(
                keyboardType: TextInputType.text,
                textController: adressController,
                myTitle: 'عنوان المدرسة',
                onChange: (val) {}),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: MyTextField(
                    enabled: false,
                    textController: dirController,
                    myTitle: 'مدير المدرسة',
                    onChange: (val) {},
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: MyTextField(
                    enabled: false,
                    textController: phoneController,
                    myTitle: 'الهاتف',
                    onChange: (val) {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                    minWidth: 140,
                    title: 'موافقة',
                    onPressed: () {
                      if (nomController.text.isEmpty) {
                        dropdownAlert('إسم المدرسة مطلوب', TypeAlert.error);
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      getCodeSchoolFromSchoolsCollection();
                    },
                    color: colorGreen!),
                MyButton(
                    minWidth: 70,
                    title: 'إغلاق',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: colorRed!),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Container choosingTypeDirection() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: colorForth),
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          const Text(
            'ترغبون في إدارة مدرسة :',
            style: TextStyle(
                decoration: TextDecoration.underline, color: colorBlack),
          ),
          ListTile(
            onTap: () {
              setState(() {
                character = SingingCharacter.free;
              });
            },
            title: Text(
              'لمدة محددة، 30 يوما مجانا.',
              style: TextStyle(
                  color: character == SingingCharacter.free
                      ? colorGreen
                      : colorBlack),
            ),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.free,
              groupValue: character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  character = value!;
                });
              },
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                character = SingingCharacter.paye;
              });
            },
            title: Text(
              'لمدة غير محددة، مدفوعة الثمن.',
              style: TextStyle(
                  color: character == SingingCharacter.paye
                      ? colorGreen
                      : colorBlack),
            ),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.paye,
              groupValue: character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  character = value!;
                });
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          MyButton(
              title: 'تأكيد',
              onPressed: () {
                setState(() {
                  saveVisible = false;
                  getRandom();
                  dateValidation = DateTime.now();
                  character == SingingCharacter.free
                      ? dateValidation = DateTime(
                          dateValidation.year,
                          dateValidation.month + 1,
                          dateValidation.day,
                          dateValidation.hour,
                          dateValidation.minute,
                          dateValidation.second,
                        )
                      : dateValidation = DateTime(
                          dateValidation.year + 100,
                          dateValidation.month,
                          dateValidation.day,
                          dateValidation.hour,
                          dateValidation.minute,
                          dateValidation.second,
                        );
                  character == SingingCharacter.free
                      ? isValidation = true
                      : isValidation = false;
                  character == SingingCharacter.free
                      ? freeOrPaye = 'free'
                      : freeOrPaye = 'paye';
                });
              },
              color: colorPrimary!),
          const SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  getRandom() {
    character == SingingCharacter.free
        ? myCode = Random().nextInt(2000) + 1000
        : myCode = Random().nextInt(2000) + 8000;
    codeController.text = '$myCode';
  }

  getCodeSchoolFromSchoolsCollection() async {
    await FirebaseFirestore.instance
        .collection(schoolsCollection)
        .doc('$myCode')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          getRandom();
        });
        getCodeSchoolFromSchoolsCollection();
      } else {
        addSchoolDataInSchoolCollection();
        mySchools.add(codeController.text);
        updateSchoolsInUtilisateursCollection();
        setState(() {
          saveVisible = false;
          isLoading = false;
        });
        utilisateur = Utilisateur(
            myUtilisateur.nom,
            myUtilisateur.phone,
            myUtilisateur.code,
            myUtilisateur.ask,
            myUtilisateur.answer,
            myUtilisateur.token,
            myUtilisateur.isNewToken,
            mySchools);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(myUtilisateur: utilisateur),
            ));
      }
    });
    try {} catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  addSchoolDataInSchoolCollection() async {
    FirebaseFirestore.instance
        .collection(schoolsCollection)
        .doc(codeController.text)
        .set({
      schoolsCollectionNom: nomController.text,
      schoolsCollectionCode: codeController.text,
      schoolsCollectionNum: numController.text,
      schoolsCollectionAnnee: anneeController.text,
      schoolsCollectionAdress: adressController.text,
      schoolsCollectionDate: dateValidation,
      schoolsCollectionValid: isValidation,
      schoolsCollectionFreeOrPaye: freeOrPaye,
    });
  }

  updateSchoolsInUtilisateursCollection() async {
    FirebaseFirestore.instance
        .collection(utilisateursCollection)
        .doc(phoneController.text)
        .update({
      utilisateursCollectionScools: mySchools,
    });
  }
}
