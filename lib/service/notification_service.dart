import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'task_reminders',
    'Task Reminders',
    description: 'This channel is used for task deadline reminders',
    importance: Importance.high,
  );

  Future<void> init() async {
    // Khởi tạo timezone
    tz.initializeTimeZones();

    // Cấu hình cho Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Cấu hình cho iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Khởi tạo settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Khởi tạo local notifications
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Tạo notification channel cho Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Xin quyền thông báo
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Lắng nghe FCM messages khi app đang chạy
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Lấy và xử lý token FCM
    await getTokenFCM();
  }

  /// Lấy token FCM và lưu trữ
  Future<void> getTokenFCM() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        // Lưu token vào Firestore để sử dụng sau nếu cần
        await FirebaseFirestore.instance
            .collection('device_tokens')
            .doc(token)
            .set({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Lỗi lấy token FCM: $e');
    }
  }

  Future<void> scheduleTaskReminder(
      String taskId, String title, DateTime deadline) async {
    // Tính thời gian nhắc (1 giờ trước deadline)
    final reminderTime = deadline.subtract(const Duration(hours: 1));

    // Kiểm tra nếu thời gian nhắc đã qua
    if (reminderTime.isBefore(DateTime.now())) {
      return;
    }

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Lên lịch local notification
    await _localNotifications.zonedSchedule(
      taskId.hashCode,
      'Task Reminder',
      'Task "$title" is due in 1 hour!',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'task_$taskId',
      androidScheduleMode: AndroidScheduleMode.exact,
    );

    // Lưu reminder info vào Firestore
    await FirebaseFirestore.instance.collection('reminders').add({
      'taskId': taskId,
      'title': title,
      'reminderTime': reminderTime.toIso8601String(),
      'deviceToken': await _firebaseMessaging.getToken(),
    });
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final taskId = response.payload!.split('_')[1];
      // TODO: Navigate to task detail screen
      print('Navigate to task $taskId');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ),
      );
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Handling a background message: ${message.messageId}');
  }

  Future<void> cancelTaskReminder(String taskId) async {
    await _localNotifications.cancel(taskId.hashCode);

    // Xóa reminder từ Firestore
    final QuerySnapshot reminders = await FirebaseFirestore.instance
        .collection('reminders')
        .where('taskId', isEqualTo: taskId)
        .get();

    for (var doc in reminders.docs) {
      await doc.reference.delete();
    }
  }
}
