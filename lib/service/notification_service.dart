

class NotificationService {
  static const localNotifChannelId = 'local_channel_id';

  static const localNotifChannelName = 'local_channel_name';

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  // final FlutterLocalNotificationsPlugin _flnPluggin =
  //     FlutterLocalNotificationsPlugin();
  //
  // Future<void> init() async {
  //   const AndroidInitializationSettings androidSettings =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   const InitializationSettings initSettings =
  //       InitializationSettings(android: androidSettings);

   // await _flnPluggin.initialize(initSettings);
  }

  Future<void> showLocalNotification(String title, String body) async {
    // const AndroidNotificationDetails androidDetails =
    //     AndroidNotificationDetails(localNotifChannelId, localNotifChannelName,
    //         importance: Importance.defaultImportance, priority: Priority.high);
    //
    // const NotificationDetails notificationDetails =
    //     NotificationDetails(android: androidDetails);

   // await _flnPluggin.show(0, title, body, notificationDetails);
  }
