import 'dart:io';

import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/login.dart';
import 'package:Project/widget/navigationwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authBloc = AuthBloc();
  final auth = FirebaseAuth.instance;
  String imageUrl;
  // final applicationBloc = Provider.of<ApplicationBloc>(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      endDrawer: NavigationDrawerWidget(),
      body: Column(
        children: <Widget>[
          (imageUrl != null)
              ? Image.network(imageUrl)
              : Placeholder(
                  fallbackHeight: 200.0, fallbackWidth: double.infinity),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: Text('Upload Image'),
            onPressed: () => uploadImage(),
          )
        ],
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    // //Check Permissions
    // await Permission.photos.request();
    //
    // var permissionStatus = await Permission.photos.status;

    if (true) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('${auth.currentUser.email}/userDP')
            .putFile(file);

        var downloadUrl = await _storage
            .ref()
            .child('${auth.currentUser.email}/userDP')
            .getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
