import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'home_screen.dart';
import 'login.dart';

Future<void> main() async {
  await GetStorage.init();
  await SqfliteDatabaseHelper.instance.db;

  runApp(MyApp());
  //configLoading();
}

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.green
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.blue.withOpacity(0.5)
//     ..userInteractions = true
//     ..dismissOnTap = false;
// }

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userdata = GetStorage();

  List? list;
  bool loading = true;
  // Future userList() async {
  //   list = await Controller().fetchData();
  //   setState(() {
  //     loading = false;
  //   });
  //   //print(list);
  // }

  // Future syncToMysql() async {
  //   await SyncronizationData().fetchAllInfo().then((userList) async {
  //     EasyLoading.show(status: 'Dont close app. we are sync...');
  //     await SyncronizationData().saveToMysqlWith(userList);
  //     EasyLoading.showSuccess('Successfully saved');
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // userList();
    // isInteret();

    GetStorage().writeIfNull('isLogged', false);

    Future.delayed(Duration.zero, () async {
      checkLogged();
    });
  }

  final _inputKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  String inputText = "";

  String appendString() {
    setState(() {
      inputText += inputText;
    });
    return inputText;
  }

  // Future isInteret() async {
  //   await SyncronizationData.isInternet().then((connection) {
  //     if (connection) {

  //     } else {
  //       _messangerKey.currentState!.showSnackBar(const SnackBar(
  //         content:  Text('No internet connection'),
  //       ));
  //       //    .showSnackBar(const SnackBar(content: Text("No Internet")));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: _messangerKey,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('in', 'IN'),
        Locale('en', 'US'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale!.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },
      locale: const Locale('in'),

      debugShowCheckedModeBanner: false,

      //  initialBinding: HomeBinding(),
      home: AnimatedSplashScreen(
        splash: Container(
            decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/logo.png',
            ),
          ),
        )),
        nextScreen: Signin2Page(),
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: Colors.white,
        duration: 180,
      ),
    );
  }

  void checkLogged() async {
    if (GetStorage().read('isLogged')) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      var version = await insertVersion(
          uid: GetStorage().read('userId'), version: packageInfo.version);
    }

    GetStorage().read('isLogged')
        ? Get.offAll(() => const HomeScreen())
        : Get.offAll(() => Signin2Page());
  }
}
