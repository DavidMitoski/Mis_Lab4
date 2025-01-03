import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exam_provider.dart';
import 'screens/calendar_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Иницијализација на нотификациите
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'notification_channel',
        channelName: 'Обични нотификации',
        channelDescription: 'Канал за испити и потсетници',
        defaultColor: Colors.teal,
        ledColor: Colors.tealAccent,
        importance: NotificationImportance.High,
      ),
    ],
  );

  // Барање дозвола за испраќање нотификации
  AwesomeNotifications().isNotificationAllowed().then((granted) {
    if (!granted) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const ExamScheduleApp());
}

class ExamScheduleApp extends StatelessWidget {
  const ExamScheduleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExamProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Распоред на Испити',
        theme: ThemeData(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        home:  CalendarScreen(),
      ),
    );
  }
}
