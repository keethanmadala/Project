import 'dart:async';
import 'package:Project/blocks/application_bloc.dart';
import 'package:Project/blocks/auth_block.dart';
import 'package:Project/models/nearbysearch.dart';
import 'package:Project/models/place.dart';
import 'package:Project/services/geolocator_service.dart';
import 'package:Project/services/marker_service.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:Project/widget/navigationwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;
  String place;
  double m;
  Future<double> meters;
  Position currentLocation;
  final geoLocatorService = GeoLocatorService();
  final authBloc = AuthBloc();

  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markerService = MarkerService();
    var markers = <Marker>[];
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawerWidget(),
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Location...',
                      suffixIcon: Icon(Icons.search),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (value) => applicationBloc.searchPlaces(value),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                applicationBloc.currentLocation.latitude,
                                applicationBloc.currentLocation.longitude),
                            zoom: 16.0),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                        },
                        markers: Set<Marker>.of(markers),
                      ),
                    ),
                    if (applicationBloc.searchResults != null &&
                        applicationBloc.searchResults.length != 0)
                      Container(
                        height: 300.00,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.6),
                          backgroundBlendMode: BlendMode.darken,
                        ),
                      ),
                    if (applicationBloc.searchResults != null &&
                        applicationBloc.searchResults.length != 0)
                      Container(
                        height: 300.0,
                        child: ListView.builder(
                          itemCount: applicationBloc.searchResults == null
                              ? 0
                              : applicationBloc.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                applicationBloc
                                    .searchResults[index].description,
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                applicationBloc.setSelectedLocation(
                                    applicationBloc
                                        .searchResults[index].placeId);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
                Container(
                  child: ElevatedButton(
                    child: Text('Near By Orphanages'),
                    onPressed: () {
                      markers = (applicationBloc.nearbySearchResults != null)
                          ?
                          // ignore: deprecated_member_use
                          markerService
                              .getMarkers(applicationBloc.nearbySearchResults)
                          : <Marker>[];
                      applicationBloc.searchNearbyPlaces('orphanages');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text("Searches are Ordered by shortest distance."),
                ),
                if (applicationBloc.nearbySearchResults != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: ListView.builder(
                        itemCount: applicationBloc.nearbySearchResults == null
                            ? 0
                            : applicationBloc.nearbySearchResults.length,
                        itemBuilder: (context, index) {
                          return FutureProvider(
                            create: (context) {
                              return null;
                            },
                            initialData: (context, index) {},
                            child: SingleChildScrollView(
                              child: Card(
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Text(
                                      '${index + 1} .',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    minLeadingWidth: 5,
                                    tileColor: Colors.white60,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    title: Text(
                                      applicationBloc
                                          .nearbySearchResults[index].name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          applicationBloc
                                              .nearbySearchResults[index]
                                              .address,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        (applicationBloc
                                                    .nearbySearchResults[index]
                                                    .rating !=
                                                null)
                                            ? Row(
                                                children: <Widget>[
                                                  RatingBarIndicator(
                                                    rating: applicationBloc
                                                        .nearbySearchResults[
                                                            index]
                                                        .rating,
                                                    itemCount: 5,
                                                    itemSize: 25.0,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text("No Rating"),
                                        Text(
                                          'Distance : ${calculateDistance(applicationBloc.currentLocation.latitude, applicationBloc.currentLocation.longitude, applicationBloc.nearbySearchResults[index].geometry.location.lat, applicationBloc.nearbySearchResults[index].geometry.location.lng)} km(s)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.directions,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        _launchMapsUrl(
                                            applicationBloc
                                                .nearbySearchResults[index]
                                                .geometry
                                                .location
                                                .lat,
                                            applicationBloc
                                                .nearbySearchResults[index]
                                                .geometry
                                                .location
                                                .lng);
                                      },
                                    ),
                                    onTap: () {
                                      _goToNearbyPlace(applicationBloc
                                          .nearbySearchResults[index]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 17.0)));
  }

  Future<void> _goToNearbyPlace(NearBySearch place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 18.0)));
  }

  Future<void> _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
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
}
