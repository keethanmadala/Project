import 'package:Project/models/geometry.dart';

class NearBySearch {
  final String name;
  final String address;
  final double rating;
  final Geometry geometry;

  NearBySearch({this.name, this.address, this.rating, this.geometry});

  factory NearBySearch.fromJson(Map<String, dynamic> parsedJson) {
    return NearBySearch(
      name: parsedJson['name'],
      address: parsedJson['formatted_address'],
      rating: (parsedJson['rating'] != null)
          ? parsedJson['rating'].toDouble()
          : null,
      geometry: Geometry.fromJson(parsedJson['geometry']),
    );
  }
}
