import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:my_school_rim/fonctions/fonctions.dart';
import 'package:my_school_rim/models/utilisateurs.dart';
import 'package:my_school_rim/tools/styles.dart';
import 'package:my_school_rim/widgets/buttons.dart';
import 'package:my_school_rim/widgets/container_indicator.dart';
import 'package:my_school_rim/widgets/text_field.dart';
import 'dart:math';

import '../tools/collections.dart';

enum SingingCharacter { free, paye }

class DirectionSchool extends StatefulWidget {
  final Utilisateur myUtilisateur;
  static const root = 'DirectionSchool';
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

  _DirectionSchoolState(this.myUtilisateur);

  late int myCode;
  SingingCharacter? _character = SingingCharacter.free;
  late DateTime dateValidation;

  getRandom() {
    _character == SingingCharacter.free
        ? myCode = Random().nextInt(2000) + 1000
        : myCode = Random().nextInt(2000) + 8000;
    codeController.text = '$myCode';
  }

  @override
  void initState() {
    getRandom();
    dirController.text = myUtilisateur.nom;
    phoneController.text = myUtilisateur.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundPrimary,
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
                cardData(context),
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
                saveVisible
                    ? MyButton(
                        minWidth: 140,
                        title: 'حفظ البيانات',
                        onPressed: () {
                          if (nomController.text.isEmpty) {
                            dropdownAlert('إسم المدرسة مطلوب', TypeAlert.error);
                            return;
                          }
                          setState(() {
                            isLoading = true;
                            dateValidation = DateTime.now();
                            _character == SingingCharacter.free
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
                            _character == SingingCharacter.free
                                ? isValidation = true
                                : isValidation = false;
                          });
                          getCodeSchool();
                        },
                        color: colorGreen!)
                    : const SizedBox(),
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
            !saveVisible
                ? _character == SingingCharacter.free
                    ? Text(
                        textAlign: TextAlign.center,
                        'هذه النسخة صالحة لغاية\n $dateValidation',
                        style: TextStyle(color: colorRed),
                      )
                    : Text(
                        'ينبغي التواصل مع المبرمج لتفعيل هذه النسخة',
                        style: TextStyle(color: colorGreen),
                      )
                : const SizedBox(),
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
          const Text(
            'ترغبون في إدارة مدرسة :',
            style: TextStyle(
                decoration: TextDecoration.underline, color: colorBlack),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _character = SingingCharacter.free;
                getRandom();
              });
            },
            title: Text(
              'لمدة محددة، مجانية لمدة 30 يوما.',
              style: TextStyle(
                  color: _character == SingingCharacter.free
                      ? colorGreen
                      : colorBlack),
            ),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.free,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value!;
                  getRandom();
                });
              },
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _character = SingingCharacter.paye;
                getRandom();
              });
            },
            title: Text(
              'لمدة غير محددة، مدفوعة الثمن.',
              style: TextStyle(
                  color: _character == SingingCharacter.paye
                      ? colorGreen
                      : colorBlack),
            ),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.paye,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value!;
                  getRandom();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  getCodeSchool() async {
    await FirebaseFirestore.instance
        .collection(schoolsCollection)
        .doc('$myCode')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          getRandom();
        });
        getCodeSchool();
      } else {
        addSchoolDataInSchoolCollection();
        setState(() {
          saveVisible = false;
          isLoading = false;
        });
        dropdownAlert('تم حفظ البيانات بنجاح', TypeAlert.success);
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
      schoolsCollectionDir: dirController.text,
      schoolsCollectionPhone: phoneController.text,
      schoolsCollectionDate: dateValidation,
      schoolsCollectionValid: isValidation,
    });
  }
}
