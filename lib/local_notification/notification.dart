import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/model/model.dart';
import 'package:to_do_app/shared/components/functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';

class TODO_notification {
  final notification = FlutterLocalNotificationsPlugin();

  static final BehaviorSubject notificationListener =
      BehaviorSubject<String?>();

  void init_notification({
    required bool wantSceduleNotification,
  }) {
    ///خاصين بالجدولة فقط
    String locallocation;
    if (wantSceduleNotification) {
      tz.initializeTimeZones();
      FlutterNativeTimezone.getLocalTimezone().then((value) {
        locallocation = value;
        tz.setLocalLocation(tz.getLocation(locallocation));
      });
    }

    ///initialization settings for android
    final androidSettings = AndroidInitializationSettings('icon');

    ///initialization settings for ios
    final iosSetttings = IOSInitializationSettings();

    ///initialization settings for notification
    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSetttings,
    );

    notification.initialize(
      initializationSettings,

      ///what happen when click on notification
      onSelectNotification: (String? payload) {
        notificationListener.add(payload!);
      },
    ).then((value) {});
  }

  ///function returnes android notification details(how look like)
  Future<AndroidNotificationDetails> androidNotificationDetails() async {
    final bigPicturePath = await getNotificationPicture(
      url:
          'https://image.freepik.com/free-vector/illustration-list_53876-28518.jpg',
      filename: 'notification_bigPicturePath',
    );
    final largeIconPath = await getNotificationPicture(
      url:
          'https://image.freepik.com/free-photo/surprised-happy-bearded-man-shirt-pointing-away_171337-5021.jpg',
      filename: 'notification_large_icon',
    );

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    final sound = 'sound.wav';
    return AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      showWhen: true,
      indeterminate: true,
      visibility: NotificationVisibility.public,
      playSound: true,
      subText: 'TODO notification.',
      styleInformation: styleInformation,
      sound: RawResourceAndroidNotificationSound(sound.split('.').first),

      /// if you want it without sound  >>>>> ///playSound: false,

      ///when we disabled the importance >>> the banner will dont appear
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'TODO App',
    );
  }

  ///function returnes ios notification details(look like)
  iosNotificationDetails() {
    final sound = 'sound.wav';
    return IOSNotificationDetails(sound: sound);
  }

  ///function represent channel for Notification
  Future<NotificationDetails> notificationPlatform() async {
    return NotificationDetails(
      android: await androidNotificationDetails(),
      iOS: iosNotificationDetails(),
    );
  }

  void scheduleNotifications({
    required int hour,
    required int minutes,
    required taskModel note,
  }) async {
    await notification.zonedSchedule(
      note.id!,
      note.title,
      note.note,

      ///daily schedule
      scheduleDaily(
        hour: hour,
        minutes: minutes,
        remind: note.remind!,
        date: note.date!,
        repeat: note.repeat!,
      ),

      await notificationPlatform(),
      payload: note.id.toString(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  ///schedule Daily Function
  static tz.TZDateTime scheduleDaily({
    required int hour,
    required int minutes,
    required int remind,
    required String repeat,
    required String date,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    //يمثل يوم انشاء الملاحظة وهوي الذي نختاره من الحقل
    DateTime selectedDate = DateFormat.yMMMMd().parse(date);

    final formatedDate = tz.TZDateTime.from(selectedDate, tz.local);

    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, formatedDate.year,
        formatedDate.month, formatedDate.day, hour, minutes);

    ///reminder States
    if (remind == 5) {
      scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
    } else if (remind == 10) {
      scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
    } else if (remind == 15) {
      scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
    } else {
      scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
    }

    ///repeat States
    if (scheduleDate.isBefore(now)) {
      if (repeat == 'Daily') {
        scheduleDate = scheduleDate.add(Duration(days: 1));
      } else if (repeat == 'Weakly') {
        scheduleDate = tz.TZDateTime(tz.local, now.year, now.month,
            (selectedDate.day) + 7, hour, minutes);
      } else if (repeat == 'Monthly') {
        scheduleDate = tz.TZDateTime(tz.local, now.year,
            (selectedDate.month) + 1, selectedDate.day, hour, minutes);
      }

      ///reminder States >>> because we use hour and minutes above >>> we must recalculate the time

      if (remind == 5) {
        scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
      } else if (remind == 10) {
        scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
      } else if (remind == 15) {
        scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
      } else {
        scheduleDate = scheduleDate.subtract(Duration(minutes: remind));
      }
    }
    return scheduleDate;
  }
}
