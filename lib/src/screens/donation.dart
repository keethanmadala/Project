import 'package:Project/widget/navigationwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({Key key}) : super(key: key);

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  List<DocumentSnapshot> donations;
  final auth = FirebaseAuth.instance;
  var snapshot;
  Timestamp timestamp;

  @override
  initState() {
    getDocs();
    super.initState();
  }

  getDocs() async {
    snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser.email)
        .collection('donations')
        .get()
        .then((value) {
      setState(() {
        donations = value.docs;
      });
    });
  }

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
      body: (donations != null)
          ? ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                return Card(
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text(
                        '${index + 1} .',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minLeadingWidth: 10,
                      horizontalTitleGap: 20,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Food name: ${donations[index].get('name')}'),
                          Text(
                              'Quantity : ${donations[index].get('quantity')}'),
                          Text(
                              'Date : ${datetime(donations[index].get('expiry'))[0]} , Time : ${datetime(donations[index].get('expiry'))[1].substring(0, 8)}'),
                          Text('Address : ${donations[index].get('address')}'),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  List<String> datetime(Timestamp timestamp) {
    List<String> date = timestamp.toDate().toString().split(' ');
    return date;
  }
}
