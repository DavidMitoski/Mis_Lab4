import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Избери Локација',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          if (_pickedLocation != null)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Пребарување на локација',
                labelStyle: TextStyle(color: Colors.teal),
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              onSubmitted: (value) {
                // Логика за пребарување, може да користите API за геокодирање.
                print('Пребарување за: $value');
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.9981, 21.4254), // Скопје, Македонија
                zoom: 13,
              ),
              onTap: _selectLocation,
              markers: _pickedLocation == null
                  ? {}
                  : {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: _pickedLocation!,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import '../services/location_service.dart';
//
// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }
//
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   LatLng? _pickedLocation;
//   LatLng? _currentLocation;
//   final LocationService _locationService = LocationService();
//   GoogleMapController? _mapController;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   // Функција за добивање на моменталната локација
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await _locationService.getCurrentLocation();
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//       });
//       if (_mapController != null && _currentLocation != null) {
//         _mapController!.animateCamera(
//           CameraUpdate.newLatLng(_currentLocation!),
//         );
//       }
//     } catch (e) {
//       print('Error getting current location: $e');
//     }
//   }
//
//   // Функција за избирање локација
//   void _selectLocation(LatLng location) {
//     setState(() {
//       _pickedLocation = location;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Избери Локација',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.teal,
//         actions: [
//           if (_pickedLocation != null)
//             IconButton(
//               icon: const Icon(Icons.check, color: Colors.white),
//               onPressed: () {
//                 Navigator.of(context).pop(_pickedLocation);
//               },
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Пребарување на локација',
//                 labelStyle: TextStyle(color: Colors.teal),
//                 prefixIcon: Icon(Icons.search, color: Colors.teal),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide(color: Colors.teal),
//                 ),
//               ),
//               onSubmitted: (value) {
//                 // Логика за пребарување, може да користите API за геокодирање.
//                 print('Пребарување за: $value');
//               },
//             ),
//           ),
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _currentLocation ?? LatLng(41.9981, 21.4254), // Скопје, Македонија
//                 zoom: 13,
//               ),
//               onTap: _selectLocation,
//               markers: _pickedLocation == null
//                   ? (_currentLocation == null
//                   ? {}
//                   : {
//                 Marker(
//                   markerId: const MarkerId('current-location'),
//                   position: _currentLocation!,
//                 ),
//               })
//                   : {
//                 Marker(
//                   markerId: const MarkerId('selected-location'),
//                   position: _pickedLocation!,
//                 ),
//               },
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


