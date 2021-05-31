import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/login.dart';
import 'package:Project/src/screens/decision_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
