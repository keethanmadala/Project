import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/screens/decision_screen.dart';
import 'package:Project/src/screens/reset.dart';
import 'package:Project/src/screens/signup.dart';
import 'package:Project/src/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Project/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authBloc = AuthBloc();
  String email, password;
  final auth = FirebaseAuth.instance;
  FToast fToast;

  @override
  initState() {
    fToast = FToast();
    fToast.init(context);
    // if (auth.currentUser != null) {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => DecisionScreen()));
    // }
    super.initState();
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

  _showError(String err) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_outlined),
          SizedBox(
            width: 12.0,
          ),
          Text(err),
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

  _showSuccess(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
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

  Widget _buildForgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ResetScreen())),
          child: Text("Forgot Password"),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            onPressed: () {
              (auth.currentUser.emailVerified)
                  ? auth
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then(
                      (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DecisionScreen(),
                          ),
                        );
                        _showSuccess('Login Successful');
                      },
                    ).catchError((err) {
                      print(err);
                      _showError("Enter valid email and password.");
                    })
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VerifyScreen()));
            },
            child: Text(
              "Login",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    // final authBloc = Provider.of<ApplicationBloc>(context);
    // Future<UserCredential> result;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Don't have an account? ",
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
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text(
                  "Sign Up",
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
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                _buildForgotPasswordButton(),
                _buildLoginButton(),
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
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(70),
                      bottomRight: const Radius.circular(70))),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),
              _buildContainer(),
              _buildSignUpBtn(),
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
