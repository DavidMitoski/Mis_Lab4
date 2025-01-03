import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../providers/exam_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Location _location = Location();
  LatLng? _currentLocation;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final locData = await _location.getLocation();
    setState(() {
      _currentLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  Future<void> _drawRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${_currentLocation!.longitude},${_currentLocation!.latitude};${destination.longitude},${destination.latitude}?geometries=polyline');

    final response = await http.get(url);

    print('URL: $url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData['routes'] != null &&
          decodedData['routes'].isNotEmpty &&
          decodedData['routes'][0]['geometry'] != null) {
        String encodedPolyline = decodedData['routes'][0]['geometry'];

        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result =
        polylinePoints.decodePolyline(encodedPolyline);

        final List<LatLng> points =
        result.map((point) => LatLng(point.latitude, point.longitude)).toList();

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: points,
              color: Colors.green,  // Зелената боја за патеката
              width: 6,
            ),
          );
        });
      } else {
        print("No valid route found!");
      }
    } else {
      print('Failed to fetch route');
    }
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мапа',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,  // Промена на бојата на лентата на апликацијата
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.9981, 21.4254),
              zoom: 13,
            ),
            markers: examProvider.exams
                .map(
                  (exam) => Marker(
                markerId: MarkerId(exam.id),
                position: exam.location,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),  // Промена на иконата на маркерот
                infoWindow: InfoWindow(
                  title: "Испит по: ${exam.title}",
                  snippet:
                  'Кликнете за насока!',
                  onTap: () {
                    _drawRoute(exam.location);
                  },
                ),
              ),
            )
                .toSet(),
            polylines: _polylines,
            myLocationEnabled: true,  // Вклучување на локацијата на корисникот
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
        ],
      ),
    );
  }
}
