import 'package:Project/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class FoodDetails extends StatelessWidget {
  const FoodDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
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
                        fontSize: MediaQuery.of(context).size.height / 50,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Expiry Time',
                  prefixIcon: Icon(Icons.access_alarm),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5),
                  ),
                ),
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
                        fontSize: MediaQuery.of(context).size.height / 40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
