import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/login.dart';
import 'package:Project/src/screens/decision_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin notification =
    FlutterLocalNotificationsPlugin();

void callBackDispatcher() {
  Workmanager().executeTask((taskName, input) async {
    FirebaseFirestore.instance
        .collection('Food_details')
        .doc(input['email'])
        .delete()
        .catchError((e) {
      print(e);
      return Future.value(false);
    });
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callBackDispatcher);
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await notification.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload :' + payload);
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final authBloc = AuthBloc();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => (ApplicationBloc()),
      child: MaterialApp(
        title: 'Project App',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: (auth.currentUser != null)
            ? (auth.currentUser.emailVerified)
                ? DecisionScreen()
                : LoginPage()
            : LoginPage(),
      ),
    );
  }
}
