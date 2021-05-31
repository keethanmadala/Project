import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/login.dart';
import 'package:Project/src/screens/decision_screen.dart';
import 'package:Project/src/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Project/constants.dart';
// import 'package:toast/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email, password, passwordRetype;
  final auth = FirebaseAuth.instance;
  FToast fToast;
  String error;
  final authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  check() {
    authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DecisionScreen()));
        // _showSuccess('Login successful');
        _showWelcome('Welcome ${fbUser.displayName}');
      }
    });
  }

  bool validatePasswordStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _showWelcome(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.prayingHands),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }

  _showMessage(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'HELP APP',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            email = value.trim();
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: mainColor,
            ),
            labelText: 'E - Mail'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        onChanged: (value) {
          setState(() {
            password = value.trim();
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: mainColor,
            ),
            labelText: 'Password'),
      ),
    );
  }

  Widget _buildReTypePasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        onChanged: (value) {
          setState(() {
            passwordRetype = value.trim();
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: mainColor,
            ),
            labelText: 'Retype Password'),
      ),
    );
  }

  _showPasswordNotMatched() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.clear),
          SizedBox(
            width: 12.0,
          ),
          Text("Passwords are not matched."),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }

  _showError(String err) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_outlined,
            size: 30,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            err,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            onPressed: () {
              (password == passwordRetype)
                  ? auth
                      .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      )
                      .then(
                        (_) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyScreen(),
                          ),
                        ),
                      )
                      .catchError((e) {
                      print(e);
                      (password.length < 6)
                          ? _showError('Password length is lessthan 6')
                          : _showError('Email is already in use.');
                    })
                  : _showPasswordNotMatched();
            },
            child: Text(
              "Sign Up",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    // final authBloc = Provider.of<ApplicationBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: TextButton(
            onPressed: () {
              auth.signInWithEmailAndPassword(email: email, password: password);
            },
            child: Row(
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height / 40,
                          fontWeight: FontWeight.w400,
                        )),
                  ]),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            "- OR -",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    // final authBloc = Provider.of<AuthBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            authBloc.loginGoogle();
            _showMessage('Logging in...');
            check();
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ]),
            child: Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                _buildReTypePasswordRow(),
                SizedBox(height: 10),
                _buildSignUpButton(),
                _buildOrRow(),
                _buildSocialBtnRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = Provider.of<ApplicationBloc>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xfff2f3f7),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(70),
                        bottomRight: const Radius.circular(70))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildLogo(),
                  _buildContainer(),
                  _buildLoginBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
