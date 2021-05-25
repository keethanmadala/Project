import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/src/login.dart';
import 'package:Project/src/screens/food_details.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DecisionScreen extends StatelessWidget {
  const DecisionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {
                applicationBloc.logout();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Please Select your type:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.w400,
                      ))
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: Container(
                height: 1.4 * (MediaQuery.of(context).size.height / 20),
                width: 5 * (MediaQuery.of(context).size.width / 12),
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetails(),
                      ),
                    );
                  },
                  child: Text(
                    "Donator",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: ListTile(
                    tileColor: Colors.black12,
                    title: Text(
                        "You will be directed to Donator page where you can fill the food details and then you can see nearby orphanages and old age homes")),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 15, left: 20, right: 20),
              child: Container(
                height: 1.4 * (MediaQuery.of(context).size.height / 20),
                width: 5 * (MediaQuery.of(context).size.width / 12),
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DecisionScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Consumer",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                    tileColor: Colors.black12,
                    title: Text(
                        "You will be directed to Consumer page where you can see the nearby food donation details and you also get food details and location")),
              ),
              // text: TextSpan(children: [
              //   TextSpan(
              //     text:
              //         "   You will be directed to Consumer page where you can see the nearby food donation details and you also get food details and location",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: MediaQuery.of(context).size.height / 50,
              //     ),
              //   ),
              // ]),
            ),
          ],
        ),
      ),
    );
  }
}
