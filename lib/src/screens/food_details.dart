import 'dart:async';
import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/src/screens/home_screen.dart';
import 'package:Project/widget/navigationwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

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
  String foodName, address;
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
    subscription.cancel();
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
                      ElevatedButton(
                        child: Text("Delete Post"),
                        onPressed: () {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection('Food_details')
                                .doc(auth.currentUser.email)
                                .delete();
                            setState(() {
                              postCreated = false;
                            });
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
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
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Food Name',
                        prefixIcon: Icon(Icons.breakfast_dining),
                        hintStyle: TextStyle(color: Colors.blue),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        foodName = value;
                      },
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
                          quantity = int.parse(value);
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
                          address = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
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
                          hours = int.parse(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Enter after how many hours food will be expired."),
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
                                'quantity': quantity,
                                'expiry':
                                    DateTime.now().add(Duration(hours: hours)),
                                'location': point.geoPoint,
                                'geohash': point.hash,
                                'address': address,
                              }).then((value) {
                                _showSuccess('Donation Posted');
                                setState(() {
                                  postCreated = true;
                                });
                              }).catchError((e) {
                                print(e);
                                _showError(e.toString());
                              });
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

  List<String> datetime(Timestamp timestamp) {
    List<String> date = timestamp.toDate().toString().split(' ');
    return date;
  }
}
