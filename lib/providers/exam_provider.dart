// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../models/exam.dart';
// import '../services/location_service.dart';
// import '../services/notification_service.dart';
//
// class ExamProvider with ChangeNotifier {
//   final List<Exam> _exams = [];
//   final LocationService _locationService = LocationService();
//   final NotificationService _notificationService = NotificationService();
//   final Map<String, bool> _notifiedExams = {};
//   ExamProvider() {
//     _notificationService.initialize();
//     _locationService.startListening(_checkProximity);
//   }
//
//   List<Exam> get exams => [..._exams];
//
//   void addExam(String title, DateTime dateTime, LatLng location, String locationName) {
//     final newExam = Exam(
//       id: DateTime.now().toString(),
//       title: title,
//       dateTime: dateTime,
//       location: location,
//       locationName: locationName,
//     );
//     _exams.add(newExam);
//     _notifiedExams[newExam.id] = false;
//     notifyListeners();
//   }
//
//   List<Exam> getExamsForDate(DateTime date) {
//     return _exams
//         .where((exam) =>
//     exam.dateTime.year == date.year &&
//         exam.dateTime.month == date.month &&
//         exam.dateTime.day == date.day)
//         .toList();
//   }
//
//   void _checkProximity(Position position) async {
//     for (var exam in _exams) {
//       double distance = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         exam.location.latitude,
//         exam.location.longitude,
//       );
//       if (distance < 100 && !_notifiedExams[exam.id]!) {
//         await _notificationService.showNotification(
//           "Потсетник за полагање",
//           "Имате испит по ${exam.title} на 100 метри оддалеченост.",
//         );
//         _notifiedExams[exam.id] = true;
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/exam.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

class ExamProvider with ChangeNotifier {
  final List<Exam> _exams = [];
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();
  final Map<String, bool> _notifiedExams = {};

  ExamProvider() {
    _notificationService.initialize();
    _locationService.startListening(_checkProximity);
  }

  List<Exam> get exams => [..._exams];

  void addExam(String title, DateTime dateTime, LatLng location, String locationName) {
    final newExam = Exam(
      id: DateTime.now().toString(),
      title: title,
      dateTime: dateTime,
      location: location,
      locationName: locationName,
    );
    _exams.add(newExam);
    _notifiedExams[newExam.id] = false;
    notifyListeners();
  }

  List<Exam> getExamsForDate(DateTime date) {
    return _exams
        .where((exam) =>
    exam.dateTime.year == date.year &&
        exam.dateTime.month == date.month &&
        exam.dateTime.day == date.day)
        .toList();
  }

  void _checkProximity(Position position) async {
    for (var exam in _exams) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        exam.location.latitude,
        exam.location.longitude,
      );
      if (distance < 100 && !_notifiedExams[exam.id]!) {
        await _notificationService.showNotification(
          "Потсетник за полагање",
          "Имате испит по ${exam.title} на 100 метри оддалеченост.",
        );
        _notifiedExams[exam.id] = true;
      }
    }
  }
}
