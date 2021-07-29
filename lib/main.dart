import 'dart:async';
import 'dart:io';
import 'package:behealthy/constants.dart';
import 'package:behealthy/group_page.dart';
import 'package:behealthy/homePage.dart';
import 'package:behealthy/utils/global_variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'customise_plan.dart';
import 'lang/localization_service.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
    50: Color.fromRGBO(255, 150, 41, .1),
    100: Color.fromRGBO(255, 150, 41, .2),
    200: Color.fromRGBO(255, 150, 41, .3),
    300: Color.fromRGBO(255, 150, 41, .4),
    400: Color.fromRGBO(255, 150, 41, .5),
    500: Color.fromRGBO(255, 150, 41, .6),
    600: Color.fromRGBO(255, 150, 41, .7),
    700: Color.fromRGBO(255, 150, 41, .8),
    800: Color.fromRGBO(255, 150, 41, .9),
    900: Color.fromRGBO(255, 150, 41, 1),
  };
  MaterialColor colorCustom;

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorCustom = MaterialColor(0xffFF9629, color);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String name = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get("compName") == null) {
        setState(
          () {
            name = 'User';
          },
        );
      } else
        name = prefs.get("compName").toString();
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            '$name ${notification.title}',
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('${notification.title}'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });

    remoteMessages();
  }

  void remoteMessages() async{
    FirebaseMessaging fcm = FirebaseMessaging.instance;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    String token = await fcm.getToken() ?? "";
    print(token);
    fcmToken = token;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);


    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        // ViewUtils.showSuccessToast(notification.body);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                'This channel is used for important notifications.',
                icon: android?.smallIcon,
                importance: Importance.max,
                priority: Priority.high,
                ongoing: true,
                // other properties...
              ),
            ));
      }

    });


    if(Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }
  }
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  // void showNotification() {
  //   setState(() {
  //     _counter++;
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Testing $_counter",
  //       "How you doin ?",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               channel.id, channel.name, channel.description,
  //               importance: Importance.high,
  //               color: Colors.blue,
  //               playSound: true,
  //               icon: '@mipmap/ic_launcher')));
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocalizationService(), // your translations
      locale: LocalizationService()
          .getCurrentLocale(), // translations will be displayed in that locale
      fallbackLocale: Locale(
        'en',
        'US',
      ),
      title: 'Be Healthy',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      //add the login validation checker
      home: Splash(),//CustomisePlan(),//Splash(),
    );
  }

}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPage();
  }

  getPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('custID') != null) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        //use profile to go to desired section.
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => GroupPage()));
      });
    }
  }
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: BeHealthyTheme.kMainOrange,
      child: SafeArea(
        child: Stack(alignment: AlignmentDirectional.center, children: [
          Positioned(
              top: MediaQuery.of(context).size.height * 0.7,
              child: Image(
                image: AssetImage('assets/images/splash_background.png'),
                width: MediaQuery.of(context).size.width,
              )),
          Positioned(
              bottom: 10,
              child: Text(
                'Copyright by BeHealthy Kuwait 2021',
                style: BeHealthyTheme.kDhaaTextStyle,
              )),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: 219,
                    width: 219,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(150)),
                  ),
                  Container(
                    height: 182,
                    width: 182,
                    decoration: BoxDecoration(
                        color: BeHealthyTheme.kInsideCard,
                        borderRadius: BorderRadius.circular(150)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/bh_logo.png'),
                          height: 83,
                          width: 82,
                        ),
                        Text(
                          'كن بصحة جيدة',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 22),
                        ),
                        Text(
                          'Be Healthy',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Build 2.0.3\nDate: ${date.day}.${date.month}.${date.year}\nBy DE Kuwait',
                  textAlign: TextAlign.center,
                  style: BeHealthyTheme.kMainTextStyle
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

}
