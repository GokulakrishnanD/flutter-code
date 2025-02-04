import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thiran_tech_task/DatabaseHelper/databasehelper.dart';
import 'package:thiran_tech_task/Models/ticket.dart';
import 'package:thiran_tech_task/Service/ticket_service.dart';
import 'package:thiran_tech_task/Utils/CustomTextFormField.dart';
import '../Bloc/ticket_bloc.dart';
import '../Bloc/ticket_event.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  File? _selectedFile;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _scheduleNotification() async {
    tz.initializeTimeZones();

    const androidDetails = AndroidNotificationDetails(
      'ticket_channel',
      'Ticket Notifications',
      importance: Importance.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      0,
      'Ticket Created',
      'Your ticket has been successfully created.',
      tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  bool _isImageFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  void _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Creating the ticket
        Ticket ticket = Ticket(
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          date: DateTime.now().toString(),
          attachmentUrl:
              null, // Store as null or provide the attachment URL if needed
          status: 'Pending', // Default status
          createdBy: 'user_123456', // Replace with the actual user ID
        );

        // Save to Firestore (optional)
        // await addTicketToFirestore(ticket);

        // Save ticket to local SQLite database
        DatabaseHelper().insertTicket(ticket);

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your ticket is raised successfully!')),
        );

        _scheduleNotification();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to raise ticket: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Ticket")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: "Title",
                controller: _titleController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                labelText: "Description",
                controller: _descriptionController,
                validator: (value) => value == null || value.isEmpty
                    ? "Description is required"
                    : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                labelText: "Location",
                controller: _locationController,
                validator: (value) => value == null || value.isEmpty
                    ? "Location is required"
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Reported Date",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text("Upload Attachment"),
                  ),
                  const SizedBox(width: 10),
                  if (_selectedFile != null)
                    _isImageFile(_selectedFile!.path)
                        ? SizedBox(
                            width: 80,
                            height: 80,
                            child:
                                Image.file(_selectedFile!, fit: BoxFit.cover),
                          )
                        : Expanded(
                            child: Text(
                              _selectedFile!.path.split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                ],
              ),
              const SizedBox(height: 130),
              ElevatedButton(
                onPressed: _submitTicket,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
