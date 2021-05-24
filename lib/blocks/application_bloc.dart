import 'dart:async';
import 'package:Project/models/geometry.dart';
import 'package:Project/models/location.dart';
import 'package:Project/models/nearbysearch.dart';
import 'package:Project/models/place.dart';
import 'package:Project/models/place_search.dart';
import 'package:Project/services/geolocator_service.dart';
import 'package:Project/services/marker_service.dart';
import 'package:Project/services/places_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeoLocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();
  final auth = FirebaseAuth.instance;
  User user;

  //Variables
  Position currentLocation;
  double meters;
  List<PlaceSearch> searchResults;
  List<NearBySearch> nearbySearchResults;
  StreamController<Place> selectedLocation =
      StreamController<Place>.broadcast();
  Place selectedLocationStatic;
  String placeType;
  // List<Marker> markers = List<Marker>();

  ApplicationBloc() {
    setCurrentLocation();
    initialize();
  }
  initialize() async {
    await Firebase.initializeApp();
  }

  logout() {
    auth.signOut();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  searchNearbyPlaces(String place) async {
    nearbySearchResults = await placesService.getPlaces(
        currentLocation.latitude, currentLocation.longitude, place);
    notifyListeners();
  }

  Future<double> distanceBetweenPlaces(double lat, double lng) async {
    meters = await geoLocatorService.getDistance(
        currentLocation.latitude, currentLocation.longitude, lat, lng);
    return meters;
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng,
          placeType);
      // markers = [];
    }
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
}
