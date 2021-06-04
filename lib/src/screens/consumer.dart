import 'dart:async';
import 'dart:math';
import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/services/geohash.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:Project/widget/navigationwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsumerPage extends StatefulWidget {
  const ConsumerPage({Key key}) : super(key: key);

  @override
  _ConsumerPageState createState() => _ConsumerPageState();
}

class _ConsumerPageState extends State<ConsumerPage> {
  List<DocumentSnapshot> donations;
  Completer<GoogleMapController> _mapController = Completer();

  var markers;
  final geohashService = GeoHashService();
  final geo = Geoflutterfire();
  final applicationBloc = ApplicationBloc();
  final Query collectionReference =
      FirebaseFirestore.instance.collection('Food_details');

  @override
  void initState() {
    callme();
    super.initState();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getPosts();
    });
  }

  getPosts() async {
    var range = geohashService.getGeoHashRange(
        applicationBloc.currentLocation.latitude,
        applicationBloc.currentLocation.longitude,
        100);
    FirebaseFirestore.instance
        .collection("Food_details")
        .where("geohash", isGreaterThanOrEqualTo: range[0])
        .where("geohash", isLessThanOrEqualTo: range[1])
        .snapshots()
        .listen((data) {
      setState(() {
        donations = data.docs;
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    super.dispose();
  }

  //Haversine Formula
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
  }

  Future<void> _goToNearbyPlace(GeoPoint point) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(point.latitude, point.longitude),
      zoom: 18.0,
    )));
    getMarkers(point);
  }

  void getMarkers(GeoPoint point) {
    setState(() {
      markers = Marker(
        markerId: MarkerId('Donation Place'),
        draggable: false,
        position: LatLng(point.latitude, point.longitude),
      );
    });
  }

  Future<void> _launchMapsUrl(String hash) async {
    var latLng = Geohash.decode(hash);
    final url =
        'https://www.google.com/maps/search/?api=1&query=${latLng.x},${latLng.y}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    bool buttonPressed = false;
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawerWidget(),
      body: (applicationBloc.currentLocation != null)
          ? Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: (donations != null)
                      ? ListView.builder(
                          itemCount: donations == null ? 0 : donations.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    donations[index].get('name'),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Column(),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.directions,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      _launchMapsUrl(
                                          donations[index].get('geohash'));
                                    },
                                  ),
                                  onTap: () {
                                    _goToNearbyPlace(
                                        donations[index].get('location'));
                                  },
                                ),
                              ),
                            );
                          })
                      : Container(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(applicationBloc.currentLocation.latitude,
                            applicationBloc.currentLocation.longitude),
                        zoom: 16.0),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                      markers:
                      (markers != null)
                          ? Set<Marker>.of(markers)
                          : Set<Marker>();
                    },
                  ),
                ),
              ],
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
