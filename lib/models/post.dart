import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String name;
  final String address;
  final Timestamp expiry;
  final int quantity;
  final String geoHash;
  final GeoPoint location;

  Post(
      {this.name,
      this.address,
      this.expiry,
      this.quantity,
      this.geoHash,
      this.location});

  factory Post.fromJson(Map<dynamic,dynamic> parsedJson){
    return Post(
      name: parsedJson['']
    );
  }
}
