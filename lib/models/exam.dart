import 'package:google_maps_flutter/google_maps_flutter.dart';

class Exam {
  final String id;
  final String title;
  final DateTime dateTime;
  final LatLng location;
  final String locationName;

  Exam({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.locationName,
  });
}
