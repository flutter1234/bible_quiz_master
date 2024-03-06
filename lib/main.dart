import 'package:bible_quiz_master/AdPlugin/AdLoader/AdLoader.dart';
import 'package:bible_quiz_master/AdPlugin/Provider/AdpluginProvider.dart';
import 'package:bible_quiz_master/AdPlugin/Screen/SplashScreen.dart';
import 'package:bible_quiz_master/AdPlugin/Utils/Extensions.dart';
import 'package:bible_quiz_master/AdPlugin/Utils/NavigationService.dart';
import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/Home_screen/home_screen.dart';
import 'package:bible_quiz_master/Screen/Splash_screen/splash_screen.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:bible_quiz_master/Routes/Routes.dart' as r;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

GetStorage storage = GetStorage();
bool isIpad = false;
bool isSmall = false;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // Widget build(BuildContext context) {
  //   DartPingIOS.register();
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   if (screenWidth > 600) {
  //     isIpad = true;
  //   } else if (screenWidth < 420) {
  //     isSmall = true;
  //   }
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => Api()),
  //     ],
  //     child: ScreenUtilInit(
  //       designSize: const Size(360, 690),
  //       minTextAdapt: true,
  //       splitScreenMode: true,
  //       builder: (context, child) {
  //         return MaterialApp(
  //           onGenerateRoute: r.Router.onRouteGenrator,
  //           debugShowCheckedModeBanner: false,
  //           theme: ThemeData(
  //             scaffoldBackgroundColor: HexColor('#20483F'),
  //           ),
  //           home: splash_screen(),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    DartPingIOS.register();
    return AdpluginProvider(
      child: AdLoader(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => Api()),
          ],
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                home: AdSplashScreen(
                    onComplete: (context, mainJson) async {
                      "/splash_screen".performAction(
                        context: context,
                        onComplete: () {
                          Navigator.pushReplacementNamed(context, home_screen.routeName);
                        },
                      );
                    },
                    servers: const [
                      // "miracocopepsi.com",
                      "coinspinmaster.com",
                      // "trailerspot4k.com",
                    ],
                    jsonUrl: const [
                      // "https://miracocopepsi.com/admin/mayur/coc/office/github/ads_demo.json",
                      "https://coinspinmaster.com/viral/iosapp/jenis/bible_quiz/main.json",
                      // "https://trailerspot4k.com/raj/ios/anime/json/main.json"
                    ],
                    version: '1.0.0',
                    child: const splash_screen()),
                theme: ThemeData(
                  scaffoldBackgroundColor: HexColor('#20483F'),
                ),
                navigatorKey: NavigationService.navigatorKey,
                onGenerateRoute: r.Router.onRouteGenrator,
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
