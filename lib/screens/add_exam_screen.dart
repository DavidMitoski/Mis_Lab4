import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'location_picker_screen.dart';

class AddExamScreen extends StatefulWidget {
  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _titleController = TextEditingController();
  final _locationNameController = TextEditingController();
  DateTime? _selectedDateTime;
  LatLng? _selectedLocation;

  void _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _pickLocation() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (ctx) => LocationPickerScreen()),
    );
    if (pickedLocation == null) return;
    setState(() {
      _selectedLocation = pickedLocation;
    });
  }

  void _saveExam() {
    if (_titleController.text.isEmpty ||
        _selectedDateTime == null ||
        _selectedLocation == null ||
        _locationNameController.text.isEmpty) {
      return;
    }
    Provider.of<ExamProvider>(context, listen: false).addExam(
      _titleController.text,
      _selectedDateTime!,
      _selectedLocation!,
      _locationNameController.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const appBarColor = Colors.teal; // Teal боја

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Додади испит',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: appBarColor,
      ),
      backgroundColor: Colors.teal[50], // Истата позадинска боја како CalendarScreen
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: ListView(
          children: [
            _buildTextField(_titleController, 'Име на Испит'),
            const SizedBox(height: 12),
            _buildTextField(_locationNameController, 'Име на Локација'),
            const SizedBox(height: 12),
            _buildDateTimePicker(),
            const SizedBox(height: 12),
            _buildLocationPicker(),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.teal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.teal),
          onPressed: _pickDateTime,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _selectedDateTime != null
                ? '${_selectedDateTime!.toLocal().toString().split(' ')[0]} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}'
                : 'Не е избран датум и време',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPicker() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.teal),
          onPressed: _pickLocation,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _selectedLocation != null
                ? '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}'
                : 'Не е избрана локација',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveExam,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Зачувај',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
