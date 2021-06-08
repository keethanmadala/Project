import 'dart:async';
import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/src/screens/home_screen.dart';
import 'package:Project/widget/navigationwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:workmanager/workmanager.dart';
import '../../main.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({Key key}) : super(key: key);

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final applicationBloc = ApplicationBloc();
  Geoflutterfire geo = Geoflutterfire();
  String id;
  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> donations;
  final Query collectionReference =
      FirebaseFirestore.instance.collection('user');
  TextEditingController dateCtl = TextEditingController();
  String foodName, address, description = ' ';
  int quantity, hours;
  bool postCreated = false;
  FToast fToast;
  GeoFirePoint point;
  var doc;

  @override
  initState() {
    fToast = FToast();
    fToast.init(context);
    getPostState();
    super.initState();
  }

  getPostState() async {
    doc = await FirebaseFirestore.instance
        .collection('Food_details')
        .doc(auth.currentUser.email)
        .get();
    setState(() {
      postCreated = doc.exists;
    });
    print(doc.get('name'));
  }

  @override
  void dispose() {
    //subscription.cancel();
    // TODO: implement dispose
    super.dispose();
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: (postCreated)
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Your present donation post ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              tileColor: Colors.grey[200],
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Name : ${doc.get('name')}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Description :  ${doc.get('description')}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Quantity : ${doc.get('quantity')}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Address : ${doc.get('address')}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Expiry date : ${datetime(doc.get('expiry'))[0]}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Expiry time : ${datetime(doc.get('expiry'))[1].substring(0, 8)}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: ElevatedButton(
                                  child: Text("Edit Post"),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            scrollable: true,
                                            title: Text('Food Quantity'),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Form(
                                                child: Column(
                                                  children: <Widget>[
                                                    TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Quantity',
                                                        icon: Icon(Icons
                                                            .format_list_numbered_sharp),
                                                      ),
                                                      onChanged: (value) {
                                                        quantity =
                                                            int.parse(value);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  child: Text("Change"),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'Food_details')
                                                        .doc(auth
                                                            .currentUser.email)
                                                        .update({
                                                      'quantity': quantity
                                                    }).then((value) {
                                                      _showSuccess(
                                                          'Quantity is changed');
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FoodDetails()))
                                                          .catchError(
                                                              (onError) {
                                                        print(Error);
                                                      });
                                                    }).catchError((Error) {
                                                      _showError(
                                                          Error.toString());
                                                    });
                                                  })
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: ElevatedButton(
                                  child: Text("Delete Post"),
                                  onPressed: () {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection('Food_details')
                                          .doc(auth.currentUser.email)
                                          .delete();
                                      setState(() {
                                        _showError('Post deleted');
                                        postCreated = false;
                                        notification.cancelAll();
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: ElevatedButton(
                              child: Text('Donation Completed Successfully'),
                              onPressed: () async {
                                notification.cancelAll();
                                await FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(auth.currentUser.email)
                                    .collection('donations')
                                    .doc()
                                    .set({
                                  'name': foodName,
                                  'quantity': quantity,
                                  'expiry': DateTime.now(),
                                  'address': address,
                                }).catchError((e) {
                                  print(e);
                                });
                                foodName = null;
                                quantity = null;
                                address = null;
                                hours = null;
                                description = ' ';
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('Food_details')
                                      .doc(auth.currentUser.email)
                                      .delete();
                                  _showSuccess(
                                      'Thankyou for being kind hearted');
                                  postCreated = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                        child: Container(
                          color: Colors.white,
                          child: Image(
                            image: AssetImage('assets/food_drive.jpeg'),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 10.0, bottom: 15.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Please fill the food details:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50,
                              ))
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Food Name',
                          prefixIcon: Icon(Icons.breakfast_dining),
                          hintStyle: TextStyle(color: Colors.blue),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          foodName = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Description',
                          prefixIcon: Icon(Icons.description),
                          hintStyle: TextStyle(color: Colors.blue),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          description = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                          prefixIcon: Icon(Icons.format_list_numbered_sharp),
                          hintStyle: TextStyle(color: Colors.blue),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          quantity = int.parse(value.trim());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                          hintStyle: TextStyle(color: Colors.blue),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          address = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Enter after how many hours food will be expired."),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Food expiry hours',
                          prefixIcon: Icon(Icons.access_alarm),
                          hintStyle: TextStyle(color: Colors.blue),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          hours = int.parse(value.trim());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        height: 1.4 * (MediaQuery.of(context).size.height / 20),
                        width: 5 * (MediaQuery.of(context).size.width / 10),
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (address != null &&
                                foodName != null &&
                                quantity != null &&
                                hours != null) {
                              point = geo.point(
                                  latitude:
                                      applicationBloc.currentLocation.latitude,
                                  longitude: applicationBloc
                                      .currentLocation.longitude);
                              await FirebaseFirestore.instance
                                  .collection('Food_details')
                                  .doc(auth.currentUser.email)
                                  .set({
                                'email': auth.currentUser.email,
                                'name': foodName,
                                'description': description,
                                'quantity': quantity,
                                'expiry':
                                    DateTime.now().add(Duration(hours: hours)),
                                'location': point.geoPoint,
                                'geohash': point.hash,
                                'address': address,
                              }).then((value) {
                                _showSuccess('Donation Posted');
                                setState(() {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetails()));
                                });
                                scheduleNotification(hours);
                                // Workmanager().registerOneOffTask(
                                //     '1', 'Delete_post',
                                //     inputData: {
                                //       'email': auth.currentUser.email
                                //     },
                                //     initialDelay: Duration(seconds: 10));
                              }).catchError((e) {
                                print(e);
                                _showError(e.toString());
                              });
                            } else {
                              _showError('Please fill all fields');
                            }
                          },
                          child: Text(
                            "Create Post",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 40),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        height: 1.4 * (MediaQuery.of(context).size.height / 20),
                        width: 5 * (MediaQuery.of(context).size.width / 10),
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Near By Search",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void scheduleNotification(int time) async {
    var notificationTime =
        DateTime.now().add(Duration(hours: time - 1, minutes: 30));

    var androidPlatformChannelSpecifications = AndroidNotificationDetails(
      'Post Notification',
      'Post Notification',
      'Your post',
      icon: 'ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      playSound: true,
      showWhen: true,
    );

    var IOSPlatformChannelSpecifications = IOSNotificationDetails(
        presentSound: true, presentAlert: true, presentBadge: true);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifications,
        iOS: IOSPlatformChannelSpecifications);

    // ignore: deprecated_member_use
    await notification.schedule(
        0,
        'HELP APP',
        'Your donation time is about to expire. Please delete the post ',
        notificationTime,
        platformChannelSpecifics);
  }

  List<String> datetime(Timestamp timestamp) {
    List<String> date = timestamp.toDate().toString().split(' ');
    return date;
  }
}
