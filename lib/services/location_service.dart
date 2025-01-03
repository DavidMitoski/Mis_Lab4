// import 'package:geolocator/geolocator.dart';
//
// class LocationService {
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   Future<void> startListening(Function(Position) onLocationChanged) async {
//     Geolocator.getPositionStream().listen((Position position) {
//       onLocationChanged(position);
//     });
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final String googleApiKey = 'YOUR_GOOGLE_API_KEY'; // Заменете го со својот API клуч

  // Функција за земање на тековната локација
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Функција за започнување на слушање на локацијата
  StreamSubscription<Position>? _positionStream;

  void startListening(Function(Position) onLocationChanged) {
    _positionStream = Geolocator.getPositionStream().listen((Position position) {
      onLocationChanged(position);
    });
  }

  // Функција за зауставување на слушањето на локацијата
  void stopListening() {
    _positionStream?.cancel();
  }

  // Функција за проверка дали локацијата е во близина на целта
  bool isWithinProximity(LatLng currentLocation, LatLng targetLocation, double distanceThreshold) {
    double distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      targetLocation.latitude,
      targetLocation.longitude,
    );
    return distance <= distanceThreshold;
  }

  // Функција за добивање на координати за најкратката рута помеѓу две локации
  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$googleApiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      return decodePolyline(points);
    } else {
      throw Exception('Failed to load route');
    }
  }

  // Помошна функција за декодирање на полигонот од API
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
