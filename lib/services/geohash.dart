import 'package:geohash/geohash.dart';

class GeoHashService {
  List getGeoHashRange(double latitude, double longitude, double distance) {
    final lat = 0.0144927536231884; // degrees latitude per mile
    final lon = 0.0181818181818182; // degrees longitude per mile

    var lowerLat = latitude - lat * distance;
    var lowerLon = longitude - lon * distance;

    var upperLat = latitude + lat * distance;
    var upperLon = longitude + lon * distance;

    var lower = Geohash.encode(lowerLat, lowerLon);
    var upper = Geohash.encode(upperLat, upperLon);

    return [lower, upper];
  }
}
