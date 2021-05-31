import 'package:Project/blocks/auth_block.dart';
import 'package:Project/src/screens/consumer.dart';
import 'package:Project/src/screens/food_details.dart';
import 'package:Project/widget/navigationwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DecisionScreen extends StatefulWidget {
  const DecisionScreen({Key key}) : super(key: key);

  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  final authBloc = AuthBloc();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Color dColor = Colors.orange;
    Color cColor = Colors.blue;
    // final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      drawer: NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            alignment: Alignment.center,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: RawMaterialButton(
                              shape: CircleBorder(),
                              fillColor: dColor,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FoodDetails()));
                              },
                              child: Icon(
                                Icons.food_bank,
                                size: 50,
                              ),
                            ),
                          ),
                          Text(
                            'Donate',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            '''
By clicking on donate, you will be redirected to "Donation Page" where you can enter food details or can search for near by orphanages.''',
                            style: TextStyle(),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: dColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: RawMaterialButton(
                              shape: CircleBorder(),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ConsumerPage()));
                              },
                              fillColor: cColor,
                              child: Icon(
                                Icons.search,
                                size: 50,
                              ),
                            ),
                          ),
                          Text(
                            'Consumer',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  '''
By clicking on consumer, you will be directed to "Consumer Page" where you will have to select the nearest food donating center's.''',
                                  style: TextStyle(),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Image(
                        image: AssetImage('assets/consumer.jpeg'),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
