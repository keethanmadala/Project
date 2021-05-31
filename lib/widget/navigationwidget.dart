import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/login.dart';
import 'package:Project/src/screens/decision_screen.dart';
import 'package:Project/src/screens/donation.dart';
import 'package:Project/src/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key key}) : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 10);
  final applicationBloc = ApplicationBloc();
  final authBloc = AuthBloc();
  final auth = FirebaseAuth.instance;
  var url;
  final _storage = FirebaseStorage.instance;

  @override
  void initState() {
    getImageUrl();
    // TODO: implement initState
    super.initState();
  }

  getImageUrl() async {
    (auth.currentUser.photoURL != null)
        ? await _storage
            .ref()
            .child('${auth.currentUser.email}/userDP')
            .getDownloadURL()
            .then((value) {
            setState(() {
              url = value;
            });
          }).catchError(() {
            setState(() async {
              url = await _storage
                  .ref()
                  .child('default/default.jpeg')
                  .getDownloadURL();
            });
          })
        : url = auth.currentUser.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.lightBlue,
        child: ListView(
          children: <Widget>[
            buildHeader(
                name: (auth.currentUser.displayName != null)
                    ? auth.currentUser.displayName
                    : auth.currentUser.email
                        .substring(0, auth.currentUser.email.length - 10),
                email: auth.currentUser.email,
                image: (auth.currentUser.photoURL != null)
                    ? auth.currentUser.photoURL
                    : _storage
                        .ref()
                        .child('${auth.currentUser.email}/userDP')
                        .getDownloadURL()
                        .toString(),
                onClicked: () {}),
            Divider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            buildMenuItem(
                text: 'Home',
                icon: Icons.home,
                onClicked: () => selectedItem(context, 0)),
            Divider(
              color: Colors.white70,
            ),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                text: 'My Donations',
                icon: Icons.favorite_border,
                onClicked: () => selectedItem(context, 1)),
            Divider(
              color: Colors.white70,
            ),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () => selectedItem(context, 2)),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(
          {String name,
          String email,
          final String image,
          VoidCallback onClicked}) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 50)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(image),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(
                  Icons.edit,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem({String text, IconData icon, VoidCallback onClicked}) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DecisionScreen()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DonationPage()));
        break;
      case 2:
        applicationBloc.logout();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }
  }
}
