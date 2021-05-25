import 'package:Project/models/nearbysearch.dart';
import 'package:Project/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:Project/models/place_search.dart';

class PlacesService {
  final key = 'AIzaSyD4lvxKvyRwsSem1D36dF8k_M21ZJXjt_c';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<NearBySearch>> getPlaces(
      double lat, double lng, String placeType) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$placeType&location=$lat,$lng&rankby=distance&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['results'] as List;
    return jsonResult.map((place) => NearBySearch.fromJson(place)).toList();
  }
}
