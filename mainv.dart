// import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dropdown_alert/dropdown_alert.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:my_school_rim/models/utilisateurs.dart';
// import 'screens/data.dart';
// import 'screens/home.dart';
// import 'screens/login.dart';
// import 'screens/registration.dart';
// import 'tools/styles.dart';
// import 'package:http/http.dart' as http;

// var fbm = FirebaseMessaging.instance;

// late String myToken;

// var serverToken =
//     'AAAAqw41WDs:APA91bFRrseMye96pT3zURSsKZJDho1I1Uk15zRXv-sTkSNoV2tBGaO8DW49KLWUNlHGTqNnCR7sot9l-IJZHK-etjLxZH8VlblJmwm2-ojuqCrkvOJMDqgPbka6CcR3gzVh4K-0hL-c';

// sendNotify(String title, String body, String id, String token) async {
//   try {
//     await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'key=$serverToken'
//       },
//       body: jsonEncode(<String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': body.toString(),
//           'title': title.toString()
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           'id': id.toString(),
//           'name': 'Abou Ghaza',
//         },
//         'to': token
//       }),
//     );
//     print('FCM request for device sent!');
//   } catch (e) {
//     print(e);
//   }
// }

// getToken() {
//   fbm.getToken().then((value) {
//     myToken = value.toString();
//   });
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   getToken();
//   runApp(MaterialApp(
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('ar', 'AE'),
//       ],
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'AmiriR',
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           primary: colorPrimary,
//           secondary: colorSecondary,
//         ),
//       ),
//       builder: (context, child) => Stack(
//             children: [
//               child!,
//               const DropdownAlert(
//                 position: AlertPosition.TOP,
//                 duration: 6,
//               )
//             ],
//           ),
//       initialRoute: Login.root,
//       routes: {
//         Login.root: (context) => const Login(),
//         Registration.root: (context) => const Registration(),
//         Home.root: (context) => Home(utilisateur: Utilisateur.empty()),
//         Data.root: (context) => Data(utilisateur: Utilisateur.empty()),
//       }));
// }
