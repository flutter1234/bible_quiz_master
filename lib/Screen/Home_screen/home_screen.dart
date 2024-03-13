import 'dart:io';
import 'dart:ui';
import 'package:bible_quiz_master/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_master/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_master/AdPlugin/MainJson/MainJson.dart';
import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/History_screen/history_screen.dart';
import 'package:bible_quiz_master/Screen/Levels_screen/levels_screen.dart';
import 'package:bible_quiz_master/Screen/Quiz_screen/quiz_screen.dart';
import 'package:bible_quiz_master/Screen/gems_collect_screen/gems_collect_screen.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class home_screen extends StatefulWidget {
  static const routeName = '/home_screen';

  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  bool dialogOpen = false;
  bool dialog = false;

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.soundOn = storage.read("soundOn") ?? true;
    dataProvider.musicOn = storage.read("musicOn") ?? true;
    dataProvider.currency = storage.read("currency") ?? 0;
    storeData().then((value) {
      firstData().then((value) {
        fetchData().then((value) {
          setState(() {});
        });
      });
    });
    if (dataProvider.musicOn == true) {
      dataProvider.initAudioPlayer();
    }
    super.initState();
  }

  Future<void> storeData() async {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.currency = storage.read("currency") ?? 0;
    dataProvider.tempData = storage.read("Reward") ??
        [
          {'day': 1, 'coins': 100, 'collected': false},
          {'day': 2, 'coins': 120, 'collected': false},
          {'day': 3, 'coins': 140, 'collected': false},
          {'day': 4, 'coins': 160, 'collected': false},
          {'day': 5, 'coins': 180, 'collected': false},
          {'day': 6, 'coins': 200, 'collected': false},
          {'day': 7, 'coins': 500, 'collected': false},
        ];
    if (dataProvider.tempData == null) {
      storage.write(
        "Reward",
        [
          {'day': 1, 'coins': 100, 'collected': false},
          {'day': 2, 'coins': 120, 'collected': false},
          {'day': 3, 'coins': 140, 'collected': false},
          {'day': 4, 'coins': 160, 'collected': false},
          {'day': 5, 'coins': 180, 'collected': false},
          {'day': 6, 'coins': 200, 'collected': false},
          {'day': 7, 'coins': 500, 'collected': false},
        ],
      );
    }
  }

  Future<void> firstData() async {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    bool first = await storage.read("isFirstTime") ?? true;

    if (first) {
      String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      storage.write("WeekDate", currentDate);
      var temp = await storage.read("WeekDate");
      print("FirstTime ============>>>${temp}");

      storage.write("isFirstTime", false);
    } else {
      var temp = await storage.read("WeekDate");
      // print("secondTime ============>>>${temp}");
      DateTime todayDate = DateTime.now();
      // print("dailyDate ============>>>>${todayDate}");

      DateTime storedDate = DateFormat("yyyy-MM-dd").parse(temp);
      todayDate = DateTime(todayDate.year, todayDate.month, todayDate.day);
      storedDate = DateTime(storedDate.year, storedDate.month, storedDate.day);

      dataProvider.difference = todayDate.difference(storedDate).inDays;

      if (dataProvider.difference >= 7) {
        dataProvider.difference = 0;
        dataProvider.tempData = [
          {'day': 1, 'coins': 100, 'collected': false},
          {'day': 2, 'coins': 120, 'collected': false},
          {'day': 3, 'coins': 140, 'collected': false},
          {'day': 4, 'coins': 160, 'collected': false},
          {'day': 6, 'coins': 200, 'collected': false},
          {'day': 5, 'coins': 180, 'collected': false},
          {'day': 7, 'coins': 500, 'collected': false},
        ];
        String currentDate = DateFormat("yyyy-MM-dd").format(todayDate);
        storage.write("WeekDate", currentDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return (dataProvider.tempData[dataProvider.difference]['collected'] == false && dialogOpen == false) || dialog == true
        ? Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(dataProvider.backgroundImage),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isIpad ? 40.sp : 25.sp),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: isIpad ? 380.sp : 410.sp,
                            width: 1.sw,
                            decoration: BoxDecoration(
                              color: dataProvider.settingColor,
                              border: Border.all(width: 1.5.w, color: Colors.white),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Container(
                                    height: isIpad ? 300.sp : 330.sp,
                                    width: isIpad ? 270.w : 350.w,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 20.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: isIpad ? 85.sp : 92.sp,
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1.w, color: Colors.white),
                                                      color: dataProvider.difference == 0 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                      borderRadius: BorderRadius.circular(5.r),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/day_container.png',
                                                              height: 25.sp,
                                                              color: dataProvider.difference == 0 ? HexColor('e69b00') : dataProvider.settingColor,
                                                            ),
                                                            Positioned(
                                                              bottom: isIpad ? 6.h : 2.h,
                                                              child: Text(
                                                                'Day 1',
                                                                style: GoogleFonts.abhayaLibre(
                                                                  fontSize: isIpad ? 13.sp : 16.sp,
                                                                  color: dataProvider.difference == 0 ? Colors.black : Colors.white,
                                                                  fontWeight: FontWeight.w900,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Image(
                                                          height: 28.sp,
                                                          image: AssetImage("assets/images/single_diamond.png"),
                                                        ),
                                                        Text(
                                                          '+100',
                                                          style: GoogleFonts.abhayaLibre(
                                                            fontSize: isIpad ? 15.sp : 18.sp,
                                                            color: dataProvider.difference == 0 ? Colors.black : Colors.white,
                                                            fontWeight: FontWeight.w900,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  dataProvider.tempData[0]['collected'] == true
                                                      ? Positioned.fill(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(5.r),
                                                            child: BackdropFilter(
                                                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                              child: Container(
                                                                color: Colors.transparent,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink(),
                                                  dataProvider.tempData[0]['collected'] == true
                                                      ? Positioned(
                                                          child: Center(
                                                            child: Image.asset(
                                                              "assets/images/check_image.png",
                                                              height: 45.sp,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: isIpad ? 85.sp : 92.sp,
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1.w, color: Colors.white),
                                                      color: dataProvider.difference == 1 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                      borderRadius: BorderRadius.circular(5.r),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/day_container.png',
                                                              height: 25.sp,
                                                              color: dataProvider.difference == 1 ? HexColor('e69b00') : dataProvider.settingColor,
                                                            ),
                                                            Positioned(
                                                              bottom: isIpad ? 6.h : 2.h,
                                                              child: Text(
                                                                'Day 2',
                                                                style: GoogleFonts.abhayaLibre(
                                                                  fontSize: isIpad ? 13.sp : 16.sp,
                                                                  color: dataProvider.difference == 1 ? Colors.black : Colors.white,
                                                                  fontWeight: FontWeight.w900,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Image(
                                                          height: 28.sp,
                                                          image: AssetImage("assets/images/single_diamond.png"),
                                                        ),
                                                        Text(
                                                          '+120',
                                                          style: GoogleFonts.abhayaLibre(
                                                            fontSize: isIpad ? 15.sp : 18.sp,
                                                            color: dataProvider.difference == 1 ? Colors.black : Colors.white,
                                                            fontWeight: FontWeight.w900,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  dataProvider.tempData[1]['collected'] == true
                                                      ? Positioned.fill(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(5.r),
                                                            child: BackdropFilter(
                                                              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                              child: Container(
                                                                color: Colors.transparent,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink(),
                                                  dataProvider.tempData[1]['collected'] == true
                                                      ? Positioned(
                                                          child: Center(
                                                            child: Image.asset(
                                                              "assets/images/check_image.png",
                                                              height: 45.sp,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: isIpad ? 85.sp : 92.sp,
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1.w, color: Colors.white),
                                                      color: dataProvider.difference == 2 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                      borderRadius: BorderRadius.circular(5.r),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/day_container.png',
                                                              height: 25.sp,
                                                              color: dataProvider.difference == 2 ? HexColor('e69b00') : dataProvider.settingColor,
                                                            ),
                                                            Positioned(
                                                              bottom: isIpad ? 6.h : 2.h,
                                                              child: Text(
                                                                'Day 3',
                                                                style: GoogleFonts.abhayaLibre(
                                                                  fontSize: isIpad ? 13.sp : 16.sp,
                                                                  color: dataProvider.difference == 2 ? Colors.black : Colors.white,
                                                                  fontWeight: FontWeight.w900,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Image(
                                                          height: 28.sp,
                                                          image: AssetImage("assets/images/single_diamond.png"),
                                                        ),
                                                        Text(
                                                          '+140',
                                                          style: GoogleFonts.abhayaLibre(
                                                            fontSize: isIpad ? 15.sp : 18.sp,
                                                            color: dataProvider.difference == 2 ? Colors.black : Colors.white,
                                                            fontWeight: FontWeight.w900,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  dataProvider.tempData[2]['collected'] == true
                                                      ? Positioned.fill(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(5.r),
                                                            child: BackdropFilter(
                                                              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                              child: Container(
                                                                color: Colors.transparent,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink(),
                                                  dataProvider.tempData[2]['collected'] == true
                                                      ? Positioned(
                                                          child: Center(
                                                            child: Image.asset(
                                                              "assets/images/check_image.png",
                                                              height: 45.sp,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5.h),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: isIpad ? 85.sp : 92.sp,
                                                      width: 80.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        color: dataProvider.difference == 3 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                        borderRadius: BorderRadius.circular(5.r),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/day_container.png',
                                                                height: 25.sp,
                                                                color: dataProvider.difference == 3 ? HexColor('e69b00') : dataProvider.settingColor,
                                                              ),
                                                              Positioned(
                                                                bottom: isIpad ? 6.h : 2.h,
                                                                child: Text(
                                                                  'Day 4',
                                                                  style: GoogleFonts.abhayaLibre(
                                                                    fontSize: isIpad ? 13.sp : 16.sp,
                                                                    color: dataProvider.difference == 3 ? Colors.black : Colors.white,
                                                                    fontWeight: FontWeight.w900,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Image(
                                                            height: 28.sp,
                                                            image: AssetImage("assets/images/multi_diamond.png"),
                                                          ),
                                                          Text(
                                                            '+160',
                                                            style: GoogleFonts.abhayaLibre(
                                                              fontSize: isIpad ? 15.sp : 18.sp,
                                                              color: dataProvider.difference == 3 ? Colors.black : Colors.white,
                                                              fontWeight: FontWeight.w900,
                                                              fontStyle: FontStyle.normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    dataProvider.tempData[3]['collected'] == true
                                                        ? Positioned.fill(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(5.r),
                                                              child: BackdropFilter(
                                                                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                child: Container(
                                                                  color: Colors.transparent,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    dataProvider.tempData[3]['collected'] == true
                                                        ? Positioned(
                                                            child: Center(
                                                              child: Image.asset(
                                                                "assets/images/check_image.png",
                                                                height: 45.sp,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink()
                                                  ],
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: isIpad ? 85.sp : 92.sp,
                                                      width: 80.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        color: dataProvider.difference == 4 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                        borderRadius: BorderRadius.circular(5.r),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/day_container.png',
                                                                height: 25.sp,
                                                                color: dataProvider.difference == 4 ? HexColor('e69b00') : dataProvider.settingColor,
                                                              ),
                                                              Positioned(
                                                                bottom: isIpad ? 6.h : 2.h,
                                                                child: Text(
                                                                  'Day 5',
                                                                  style: GoogleFonts.abhayaLibre(
                                                                    fontSize: isIpad ? 13.sp : 16.sp,
                                                                    color: dataProvider.difference == 4 ? Colors.black : Colors.white,
                                                                    fontWeight: FontWeight.w900,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Image(
                                                            height: 28.sp,
                                                            image: AssetImage("assets/images/multi_diamond.png"),
                                                          ),
                                                          Text(
                                                            '+180',
                                                            style: GoogleFonts.abhayaLibre(
                                                              fontSize: isIpad ? 15.sp : 18.sp,
                                                              color: dataProvider.difference == 4 ? Colors.black : Colors.white,
                                                              fontWeight: FontWeight.w900,
                                                              fontStyle: FontStyle.normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    dataProvider.tempData[4]['collected'] == true
                                                        ? Positioned.fill(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(5.r),
                                                              child: BackdropFilter(
                                                                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                child: Container(
                                                                  color: Colors.transparent,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    dataProvider.tempData[4]['collected'] == true
                                                        ? Positioned(
                                                            child: Center(
                                                              child: Image.asset(
                                                                "assets/images/check_image.png",
                                                                height: 45.sp,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink()
                                                  ],
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: isIpad ? 85.sp : 92.sp,
                                                      width: 80.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        color: dataProvider.difference == 5 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                        borderRadius: BorderRadius.circular(5.r),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/day_container.png',
                                                                height: 25.sp,
                                                                color: dataProvider.difference == 5 ? HexColor('e69b00') : dataProvider.settingColor,
                                                              ),
                                                              Positioned(
                                                                bottom: isIpad ? 6.h : 2.h,
                                                                child: Text(
                                                                  'Day 6',
                                                                  style: GoogleFonts.abhayaLibre(
                                                                    fontSize: isIpad ? 13.sp : 16.sp,
                                                                    color: dataProvider.difference == 5 ? Colors.black : Colors.white,
                                                                    fontWeight: FontWeight.w900,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Image(
                                                            height: 28.sp,
                                                            image: AssetImage("assets/images/multi_diamond.png"),
                                                          ),
                                                          Text(
                                                            '+200',
                                                            style: GoogleFonts.abhayaLibre(
                                                              fontSize: isIpad ? 15.sp : 18.sp,
                                                              color: dataProvider.difference == 5 ? Colors.black : Colors.white,
                                                              fontWeight: FontWeight.w900,
                                                              fontStyle: FontStyle.normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    dataProvider.tempData[5]['collected'] == true
                                                        ? Positioned.fill(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(5.r),
                                                              child: BackdropFilter(
                                                                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                child: Container(
                                                                  color: Colors.transparent,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    dataProvider.tempData[5]['collected'] == true
                                                        ? Positioned(
                                                            child: Center(
                                                              child: Image.asset(
                                                                "assets/images/check_image.png",
                                                                height: 45.sp,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink()
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5.h),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: isIpad ? 92.sp : 95.sp,
                                                  width: 300.w,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1.w, color: Colors.white),
                                                    color: dataProvider.difference == 6 ? HexColor('e6cc00') : dataProvider.settingBoxColor,
                                                    borderRadius: BorderRadius.circular(5.r),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/day_container.png',
                                                            height: 30.sp,
                                                            color: dataProvider.difference == 6 ? HexColor('e69b00') : dataProvider.settingColor,
                                                          ),
                                                          Positioned(
                                                            bottom: isIpad ? 10.h : 5.h,
                                                            child: Text(
                                                              'Day 7',
                                                              style: GoogleFonts.abhayaLibre(
                                                                fontSize: isIpad ? 13.sp : 16.sp,
                                                                color: dataProvider.difference == 6 ? Colors.black : Colors.white,
                                                                fontWeight: FontWeight.w900,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: isIpad ? 115.w : 120.w,
                                                              child: Row(
                                                                children: [
                                                                  Image(
                                                                    height: 60.sp,
                                                                    width: 60.w,
                                                                    image: AssetImage("assets/images/multi_diamond.png"),
                                                                  ),
                                                                  Text(
                                                                    'x200',
                                                                    style: GoogleFonts.abhayaLibre(
                                                                      fontSize: isIpad ? 15.sp : 18.sp,
                                                                      color: dataProvider.difference == 6 ? Colors.black : Colors.white,
                                                                      fontWeight: FontWeight.w900,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 55.sp,
                                                              width: 1.w,
                                                              color: Colors.black54,
                                                            ),
                                                            Container(
                                                              width: isIpad ? 115.w : 120.w,
                                                              child: Row(
                                                                children: [
                                                                  Image(
                                                                    height: 60.sp,
                                                                    width: 60.w,
                                                                    image: AssetImage("assets/images/chest_diamond.png"),
                                                                  ),
                                                                  Text(
                                                                    'x300',
                                                                    style: GoogleFonts.abhayaLibre(
                                                                      fontSize: isIpad ? 15.sp : 18.sp,
                                                                      color: dataProvider.difference == 6 ? Colors.black : Colors.white,
                                                                      fontWeight: FontWeight.w900,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                ),
                                                dataProvider.tempData[6]['collected'] == true
                                                    ? Positioned.fill(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5.r),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                            child: Container(
                                                              color: Colors.transparent,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                                dataProvider.tempData[6]['collected'] == true
                                                    ? Positioned(
                                                        child: Center(
                                                          child: Image.asset(
                                                            "assets/images/check_image.png",
                                                            height: 45.sp,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox.shrink()
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                dataProvider.tempData[dataProvider.difference]['collected'] == false
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (dataProvider.difference == 0) {
                                            dataProvider.coinDaily = dataProvider.tempData[0]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[0]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 1 ===========>>>${dataProvider.coin}");
                                          } else if (dataProvider.difference == 1) {
                                            dataProvider.coinDaily = dataProvider.tempData[1]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[1]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 2 ===========>>>${dataProvider.coin}");
                                          } else if (dataProvider.difference == 2) {
                                            dataProvider.coinDaily = dataProvider.tempData[2]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[2]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 3 ===========>>>${dataProvider.coin}");
                                          } else if (dataProvider.difference == 3) {
                                            dataProvider.coinDaily = dataProvider.tempData[3]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[3]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 4 ===========>>>${dataProvider.coin}");
                                          } else if (dataProvider.difference == 4) {
                                            dataProvider.coinDaily = dataProvider.tempData[4]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[4]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 5 ===========>>>${dataProvider.coin}");
                                          } else if (dataProvider.difference == 5) {
                                            dataProvider.coinDaily = dataProvider.tempData[5]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[5]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 6 ===========>>>${dataProvider.coin}");
                                          } else if (dataProvider.difference == 6) {
                                            dataProvider.coinDaily = dataProvider.tempData[6]['coins'];
                                            dataProvider.currency = dataProvider.currency + dataProvider.coinDaily;
                                            await storage.write("currency", dataProvider.currency);
                                            dataProvider.tempData[6]['collected'] = true;
                                            storage.write("Reward", dataProvider.tempData);
                                            // print("Dialog ==============>>>>${dataProvider.tempData}");
                                            setState(() {});
                                            // print("Day 7 ===========>>>${dataProvider.coin}");
                                          }
                                          dialogOpen = true;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: isIpad ? 35.sp : 40.sp,
                                          width: 200.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2.w, color: Colors.white),
                                            color: Colors.yellow.shade700,
                                            borderRadius: BorderRadius.circular(6.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Tap to Collect',
                                              style: GoogleFonts.notoSans(
                                                fontSize: isIpad ? 17.sp : 20.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: isIpad ? 45.sp : 40.sp,
                                        width: 200.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2.w, color: Colors.white),
                                          color: Colors.yellow.shade700,
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Already Collected',
                                            style: GoogleFonts.b612(
                                              fontSize: 18.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: isIpad ? -20.h : -14.h,
                            child: Container(
                              height: isIpad ? 25.sp : 35.sp,
                              width: 180.w,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.w, color: dataProvider.borderColor),
                                color: dataProvider.settingBoxColor,
                                // color: HexColor('3d251e'),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'DAILY REWARD',
                                  style: GoogleFonts.sanchez(
                                    fontSize: isIpad ? 16.sp : 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: isIpad ? 27.w : 15.w,
                top: isIpad
                    ? 55.h
                    : isSmall
                        ? 110.h
                        : 150.h,
                child: GestureDetector(
                  onTap: () {
                    if (dataProvider.soundOn == true) {
                      dataProvider.initOnTap();
                    }
                    dialogOpen = true;
                    dialog = false;
                    setState(() {});
                  },
                  child: Container(
                    width: isIpad ? 30.sp : 35.sp,
                    height: isIpad ? 30.sp : 35.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.w, color: Colors.white),
                      color: Colors.red.shade600,
                    ),
                    child: Icon(
                      Icons.close,
                      size: isIpad ? 22.sp : 25.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        : Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(dataProvider.backgroundImage),
                ),
              ),
              child: Stack(
                children: [
                  BannerWrapper(
                    parentContext: context,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: isSmall
                            ? 25.h
                            : isIpad
                                ? 20.h
                                : 50.h,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (dataProvider.soundOn == true) {
                                      dataProvider.initOnTap();
                                    }
                                    dataProvider.settingDialog = true;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.settings,
                                    size: isIpad ? 25.sp : 30.sp,
                                    color: Colors.yellow.shade700,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: isIpad ? 20.sp : 26.sp,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.w, color: dataProvider.borderColor),
                                          color: dataProvider.currencyBoxColor,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${dataProvider.currency}',
                                            style: GoogleFonts.lora(
                                              fontSize: isIpad ? 13.sp : 16.sp,
                                              color: dataProvider.currencyTextColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: -12.w,
                                        child: Image(
                                          image: AssetImage('assets/images/single_diamond.png'),
                                          height: isIpad ? 22.sp : 28.sp,
                                          width: 35.w,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Container(
                              height: isIpad ? 130.sp : 180.sp,
                              width: isIpad ? 250.w : 300.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/images/home_quiz_book.png'),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (dataProvider.soundOn == true) {
                                          dataProvider.initOnTap();
                                        }
                                        dataProvider.themeChangeDialog = true;
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/theme_change.png',
                                      height: isIpad ? 40.sp : 50.sp,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -7.h,
                                    child: Text(
                                      "Theme",
                                      style: GoogleFonts.nobile(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.w, top: 20.h),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  AdsRN().showFullScreen(
                                    context: context,
                                    onComplete: () {
                                      if (dataProvider.soundOn == true) {
                                        dataProvider.initOnTap();
                                      }
                                      Navigator.pushNamed(context, history_screen.routeName);
                                    },
                                  );

                                  setState(() {});
                                },
                                child: Image.asset(
                                  color: Colors.yellow.shade800,
                                  'assets/images/history_image.png',
                                  height: isIpad
                                      ? 35.sp
                                      : isSmall
                                          ? 45.sp
                                          : 45.sp,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.w, top: 20.h),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  AdsRN().showFullScreen(
                                    context: context,
                                    onComplete: () {
                                      if (dataProvider.soundOn == true) {
                                        dataProvider.initOnTap();
                                      }
                                      dialog = true;
                                      setState(() {});
                                    },
                                  );
                                  setState(() {});
                                },
                                child: Image.asset(
                                  'assets/images/daily_gems_image.png',
                                  height: isIpad ? 40.sp : 45.sp,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              AdsRN().showFullScreen(
                                context: context,
                                onComplete: () {
                                  if (dataProvider.soundOn == true) {
                                    dataProvider.initOnTap();
                                  }
                                  Navigator.pushNamed(context, quiz_screen.routeName);
                                },
                              );
                            },
                            child: Container(
                              height: isIpad ? 45.sp : 50.sp,
                              width: 200.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/play_button.png'), fit: BoxFit.fill),
                                // border: Border.all(width: 1.w, color: dataProvider.borderColor),
                                // gradient: LinearGradient(
                                //   begin: Alignment.bottomCenter,
                                //   end: Alignment.topCenter,
                                //   colors: [
                                //     HexColor('08A045'),
                                //     HexColor('6BBF59'),
                                //   ],
                                // ),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Play",
                                  style: TextStyle(
                                    fontSize: isIpad ? 30.sp : 26.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(color: Colors.black, offset: Offset(4, 2), blurRadius: 2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {
                              AdsRN().showFullScreen(
                                context: context,
                                onComplete: () {
                                  if (dataProvider.soundOn == true) {
                                    dataProvider.initOnTap();
                                  }
                                  Navigator.pushNamed(context, gems_collect_screen.routeName);
                                },
                              );
                            },
                            child: Container(
                              height: isIpad ? 45.sp : 50.sp,
                              width: 200.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/collect_button.png'), fit: BoxFit.fill),
                                // border: Border.all(width: 1.w, color: dataProvider.borderColor),
                                // gradient: LinearGradient(
                                //   begin: Alignment.bottomCenter,
                                //   end: Alignment.topCenter,
                                //   colors: [
                                //     HexColor('e69b00'),
                                //     HexColor('e6b400'),
                                //   ],
                                // ),
                                // borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Collect",
                                  style: TextStyle(
                                    fontSize: isIpad ? 30.sp : 26.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(color: Colors.black, offset: Offset(4, 2), blurRadius: 2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  dataProvider.settingDialog == true
                      ? Scaffold(
                          backgroundColor: Colors.black54.withOpacity(0.8),
                          body: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 1.sh,
                                width: 1.sw,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 25.sp),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: dataProvider.settingBoxColor,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: isIpad ? 30.sp : 35.sp,
                                              width: 1.sw,
                                              decoration: BoxDecoration(
                                                color: dataProvider.settingColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.r),
                                                  topRight: Radius.circular(10.r),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "SETTING",
                                                  style: GoogleFonts.lato(
                                                    fontSize: isIpad
                                                        ? 20.sp
                                                        : isSmall
                                                            ? 19.sp
                                                            : 22.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      dataProvider.musicOn = !dataProvider.musicOn;
                                                      storage.write("musicOn", dataProvider.musicOn);
                                                      if (dataProvider.musicOn == true) {
                                                        dataProvider.audioPlayerBackground.play();
                                                      } else {
                                                        dataProvider.audioPlayerBackground.pause();
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: isIpad ? 45.sp : 50.sp,
                                                          width: isIpad ? 45.sp : 50.sp,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(dataProvider.lifeLineImage),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              dataProvider.musicOn == true ? Icons.music_note_sharp : Icons.music_off_rounded,
                                                              color: dataProvider.iconColor,
                                                              size: 28.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Music",
                                                          style: GoogleFonts.lato(
                                                            fontSize: isIpad ? 12.sp : 14.sp,
                                                            color: Colors.white70,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      dataProvider.soundOn = !dataProvider.soundOn;
                                                      storage.write("soundOn", dataProvider.soundOn);
                                                      if (dataProvider.soundOn == true) {
                                                        dataProvider.initOnTap();
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: isIpad ? 45.sp : 50.sp,
                                                          width: isIpad ? 45.sp : 50.sp,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(dataProvider.lifeLineImage),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              dataProvider.soundOn == true ? Icons.volume_up_rounded : Icons.volume_off_outlined,
                                                              color: dataProvider.iconColor,
                                                              size: 28.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Sound",
                                                          style: GoogleFonts.lato(
                                                            fontSize: isIpad ? 12.sp : 14.sp,
                                                            color: Colors.white70,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (dataProvider.soundOn == true) {
                                                            dataProvider.initOnTap();
                                                          }
                                                          setState(() {
                                                            exit(0);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: isIpad ? 45.sp : 50.sp,
                                                          width: isIpad ? 45.sp : 50.sp,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(dataProvider.lifeLineImage),
                                                            ),
                                                          ),
                                                          child: Icon(
                                                            Icons.exit_to_app_rounded,
                                                            color: dataProvider.iconColor,
                                                            size: 28.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Exit App",
                                                        style: GoogleFonts.lato(
                                                          fontSize: isIpad ? 12.sp : 14.sp,
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (dataProvider.soundOn == true) {
                                                            dataProvider.initOnTap();
                                                          }
                                                          setState(() {
                                                            dataProvider.url = context.read<MainJson>().data!['assets']['contactUs'];
                                                          });
                                                          dataProvider.launchurl();
                                                        },
                                                        child: Container(
                                                          height: isIpad ? 45.sp : 50.sp,
                                                          width: isIpad ? 45.sp : 50.sp,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(dataProvider.lifeLineImage),
                                                            ),
                                                          ),
                                                          child: Icon(
                                                            Icons.mail,
                                                            color: dataProvider.iconColor,
                                                            size: 28.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Support",
                                                        style: GoogleFonts.lato(
                                                          fontSize: isIpad ? 12.sp : 14.sp,
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (dataProvider.soundOn == true) {
                                                  dataProvider.initOnTap();
                                                }
                                                dataProvider.settingDialog = false;
                                                Navigator.pushNamed(context, levels_screen.routeName);

                                                setState(() {});
                                              },
                                              child: Container(
                                                height: isIpad ? 40.sp : 45.sp,
                                                width: 200.w,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/images/recovery_image.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Icon(
                                                        Icons.list,
                                                        size: isIpad ? 22.sp : 25.sp,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Levels",
                                                        style: GoogleFonts.lato(
                                                          fontSize: isIpad ? 18.sp : 22.sp,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w800,
                                                        ),
                                                      ),
                                                      SizedBox(width: 15.w)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: isIpad ? 5.h : 20.h),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  dataProvider.url = context.read<MainJson>().data!['assets']['privacyPolicy'];
                                                });
                                                dataProvider.launchurl();
                                              },
                                              child: Text(
                                                "Privacy Policy",
                                                style: GoogleFonts.lato(
                                                  fontSize: isIpad ? 14.sp : 16.sp,
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 100.sp),
                                              child: Container(height: 0.8.h, color: Colors.white),
                                            ),
                                            SizedBox(height: 10.h)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 15.w,
                                top: isIpad
                                    ? 197.h
                                    : isSmall
                                        ? 212.h
                                        : 232.h,
                                child: GestureDetector(
                                  onTap: () {
                                    if (dataProvider.soundOn == true) {
                                      dataProvider.initOnTap();
                                    }
                                    dataProvider.settingDialog = false;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: isIpad ? 25.sp : 30.sp,
                                    width: isIpad ? 25.sp : 30.sp,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 0.5.w, color: Colors.white),
                                      color: dataProvider.settingBoxColor,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.yellow,
                                      size: isIpad ? 20.sp : 25.sp,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  dataProvider.themeChangeDialog == true
                      ? Scaffold(
                          backgroundColor: Colors.black54.withOpacity(0.6),
                          body: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 1.sh,
                                width: 1.sw,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 25.sp),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2.w, color: Colors.white),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              HexColor('446879'),
                                              HexColor('608da2'),
                                              HexColor('8eb1b2'),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: isIpad ? 30.sp : 40.sp,
                                              width: 1.sw,
                                              decoration: BoxDecoration(
                                                color: HexColor('253f4b'),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.r),
                                                  topRight: Radius.circular(10.r),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(width: 25.w),
                                                    Text(
                                                      "THEME",
                                                      style: GoogleFonts.notoSans(
                                                        fontSize: isIpad ? 18.sp : 22.sp,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (dataProvider.soundOn == true) {
                                                            dataProvider.initOnTap();
                                                          }
                                                          dataProvider.themeChangeDialog = false;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        size: isIpad ? 25.sp : 28.sp,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: isIpad ? 8.sp : 10.sp),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      dataProvider.backgroundImage = "assets/images/quiz_bg_image.jpeg";
                                                      storage.write("backgroundImage", dataProvider.backgroundImage);
                                                      dataProvider.optionImage = "assets/images/theme1_option_image.png";
                                                      storage.write("optionImage", dataProvider.optionImage);
                                                      dataProvider.correctOptionImage = "assets/images/theme1_option_green.png";
                                                      storage.write("correctOptionImage", dataProvider.correctOptionImage);
                                                      dataProvider.wrongOptionImage = "assets/images/theme1_option_red.png";
                                                      storage.write("wrongOptionImage", dataProvider.wrongOptionImage);
                                                      dataProvider.questionImage = "assets/images/theme1_question_image.jpeg";
                                                      storage.write("questionImage", dataProvider.questionImage);
                                                      dataProvider.lifeLineImage = "assets/images/lifeline_image.png";
                                                      storage.write("lifeLineImage", dataProvider.lifeLineImage);
                                                      dataProvider.textColor = Colors.black;
                                                      storage.write("textColor", dataProvider.textColor.value.toRadixString(16));
                                                      dataProvider.lifeLineBoxColor = Colors.brown.shade100;
                                                      storage.write("lifeLineBoxColor", dataProvider.lifeLineBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyBoxColor = HexColor('CFB595');
                                                      storage.write("currencyBoxColor", dataProvider.currencyBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyTextColor = Colors.brown.shade700;
                                                      storage.write("currencyTextColor", dataProvider.currencyTextColor.value.toRadixString(16));
                                                      dataProvider.timeBoxColor = Colors.brown.shade800;
                                                      storage.write("timeBoxColor", dataProvider.timeBoxColor.value.toRadixString(16));
                                                      dataProvider.questionTextColor = Colors.black;
                                                      storage.write("questionTextColor", dataProvider.questionTextColor.value.toRadixString(16));
                                                      dataProvider.iconColor = Colors.black;
                                                      storage.write("iconColor", dataProvider.iconColor.value.toRadixString(16));
                                                      dataProvider.second = Colors.black;
                                                      storage.write("second", dataProvider.second.value.toRadixString(16));
                                                      dataProvider.borderColor = Colors.brown.shade700;
                                                      storage.write("borderColor", dataProvider.borderColor.value.toRadixString(16));
                                                      dataProvider.settingColor = HexColor('6f473e');
                                                      storage.write("settingColor", dataProvider.settingColor.value.toRadixString(16));
                                                      dataProvider.settingBoxColor = HexColor('8c5d50');
                                                      storage.write("settingBoxColor", dataProvider.settingBoxColor.value.toRadixString(16));
                                                      dataProvider.quColor = Colors.white;
                                                      storage.write("quColor", dataProvider.quColor.value.toRadixString(16));
                                                      dataProvider.seColor = HexColor('7a4231');
                                                      storage.write("seColor", dataProvider.seColor.value.toRadixString(16));
                                                      dataProvider.noSeColor = HexColor('975942');
                                                      storage.write("noSeColor", dataProvider.noSeColor.value.toRadixString(16));
                                                      dataProvider.themeChangeDialog = false;

                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height: isIpad ? 150.sp : 170.sp,
                                                      width: 140.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        borderRadius: BorderRadius.circular(10.r),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage('assets/images/quiz_bg_image.jpeg'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      dataProvider.backgroundImage = "assets/images/green_theme/green_bg_image.jpeg";
                                                      storage.write("backgroundImage", dataProvider.backgroundImage);
                                                      dataProvider.optionImage = "assets/images/green_theme/theme2_option_image.png";
                                                      storage.write("optionImage", dataProvider.optionImage);
                                                      dataProvider.correctOptionImage = "assets/images/green_theme/theme2_correct_answer.png";
                                                      storage.write("correctOptionImage", dataProvider.correctOptionImage);
                                                      dataProvider.wrongOptionImage = "assets/images/green_theme/theme2_wrong_answer.png";
                                                      storage.write("wrongOptionImage", dataProvider.wrongOptionImage);
                                                      dataProvider.questionImage = "assets/images/green_theme/theme2_question_image.png";
                                                      storage.write("questionImage", dataProvider.questionImage);
                                                      dataProvider.lifeLineImage = "assets/images/green_theme/theme2_lifeLine_image.png";
                                                      storage.write("lifeLineImage", dataProvider.lifeLineImage);
                                                      dataProvider.textColor = Colors.white;
                                                      storage.write("textColor", dataProvider.textColor.value.toRadixString(16));
                                                      dataProvider.lifeLineBoxColor = HexColor('EDC967');
                                                      storage.write("lifeLineBoxColor", dataProvider.lifeLineBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyBoxColor = HexColor('AE8625');
                                                      storage.write("currencyBoxColor", dataProvider.currencyBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyTextColor = Colors.white;
                                                      storage.write("currencyTextColor", dataProvider.currencyTextColor.value.toRadixString(16));
                                                      dataProvider.timeBoxColor = HexColor('AE8625');
                                                      storage.write("timeBoxColor", dataProvider.timeBoxColor.value.toRadixString(16));
                                                      dataProvider.timeBoxColor = HexColor('AE8625');
                                                      dataProvider.questionTextColor = Colors.black;
                                                      storage.write("questionTextColor", dataProvider.questionTextColor.value.toRadixString(16));
                                                      dataProvider.iconColor = Colors.black;
                                                      storage.write("iconColor", dataProvider.iconColor.value.toRadixString(16));
                                                      dataProvider.second = Colors.black;
                                                      storage.write("second", dataProvider.second.value.toRadixString(16));
                                                      dataProvider.borderColor = Colors.white;
                                                      storage.write("borderColor", dataProvider.borderColor.value.toRadixString(16));
                                                      dataProvider.settingColor = HexColor('14452F');
                                                      storage.write("settingColor", dataProvider.settingColor.value.toRadixString(16));
                                                      dataProvider.settingBoxColor = HexColor('0F5132');
                                                      storage.write("settingBoxColor", dataProvider.settingBoxColor.value.toRadixString(16));
                                                      dataProvider.quColor = Colors.white;
                                                      storage.write("quColor", dataProvider.quColor.value.toRadixString(16));
                                                      dataProvider.seColor = HexColor('3a4c40');
                                                      storage.write("seColor", dataProvider.seColor.value.toRadixString(16));
                                                      dataProvider.noSeColor = HexColor('507963');
                                                      storage.write("noSeColor", dataProvider.noSeColor.value.toRadixString(16));
                                                      dataProvider.themeChangeDialog = false;

                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height: isIpad ? 150.sp : 170.sp,
                                                      width: 140.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.r),
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage('assets/images/green_theme/green_bg_image.jpeg'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: isIpad ? 8.sp : 10.sp),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      dataProvider.backgroundImage = "assets/images/black_theme/black_bg_image.jpeg";
                                                      storage.write("backgroundImage", dataProvider.backgroundImage);
                                                      dataProvider.optionImage = "assets/images/black_theme/theme3_option_image.png";
                                                      storage.write("optionImage", dataProvider.optionImage);
                                                      dataProvider.correctOptionImage = "assets/images/black_theme/theme3_correct_image.png";
                                                      storage.write("correctOptionImage", dataProvider.correctOptionImage);
                                                      dataProvider.wrongOptionImage = "assets/images/black_theme/theme3_wrong_image.png";
                                                      storage.write("wrongOptionImage", dataProvider.wrongOptionImage);
                                                      dataProvider.questionImage = "assets/images/black_theme/theme3_question_image.png";
                                                      storage.write("questionImage", dataProvider.questionImage);
                                                      dataProvider.lifeLineImage = "assets/images/black_theme/theme3_lifeLine_image.png";
                                                      storage.write("lifeLineImage", dataProvider.lifeLineImage);
                                                      dataProvider.textColor = Colors.black;
                                                      storage.write("textColor", dataProvider.textColor.value.toRadixString(16));
                                                      dataProvider.lifeLineBoxColor = Colors.black54;
                                                      storage.write("lifeLineBoxColor", dataProvider.lifeLineBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyBoxColor = Colors.black54;
                                                      storage.write("currencyBoxColor", dataProvider.currencyBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyTextColor = Colors.white;
                                                      storage.write("currencyTextColor", dataProvider.currencyTextColor.value.toRadixString(16));
                                                      dataProvider.timeBoxColor = Colors.black;
                                                      storage.write("timeBoxColor", dataProvider.timeBoxColor.value.toRadixString(16));
                                                      dataProvider.questionTextColor = Colors.white;
                                                      storage.write("questionTextColor", dataProvider.questionTextColor.value.toRadixString(16));
                                                      dataProvider.iconColor = Colors.white;
                                                      storage.write("iconColor", dataProvider.iconColor.value.toRadixString(16));
                                                      dataProvider.second = Colors.white;
                                                      storage.write("second", dataProvider.second.value.toRadixString(16));
                                                      dataProvider.borderColor = Colors.white;
                                                      storage.write("borderColor", dataProvider.borderColor.value.toRadixString(16));
                                                      dataProvider.settingColor = HexColor('616E7C');
                                                      storage.write("settingColor", dataProvider.settingColor.value.toRadixString(16));
                                                      dataProvider.settingBoxColor = HexColor('3E4C59');
                                                      storage.write("settingBoxColor", dataProvider.settingBoxColor.value.toRadixString(16));
                                                      dataProvider.quColor = Colors.black;
                                                      storage.write("quColor", dataProvider.quColor.value.toRadixString(16));
                                                      dataProvider.seColor = HexColor('5C6B73');
                                                      storage.write("seColor", dataProvider.seColor.value.toRadixString(16));
                                                      dataProvider.noSeColor = HexColor('CED0CE');
                                                      storage.write("noSeColor", dataProvider.noSeColor.value.toRadixString(16));
                                                      dataProvider.themeChangeDialog = false;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height: isIpad ? 150.sp : 170.sp,
                                                      width: 140.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        borderRadius: BorderRadius.circular(10.r),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage('assets/images/black_theme/black_bg_image.jpeg'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      dataProvider.backgroundImage = "assets/images/blue_theme/theme4_bg_image.jpeg";
                                                      storage.write("backgroundImage", dataProvider.backgroundImage);
                                                      dataProvider.optionImage = "assets/images/blue_theme/theme4_option_image.png";
                                                      storage.write("optionImage", dataProvider.optionImage);
                                                      dataProvider.correctOptionImage = "assets/images/blue_theme/theme4_correct_image.png";
                                                      storage.write("correctOptionImage", dataProvider.correctOptionImage);
                                                      dataProvider.wrongOptionImage = "assets/images/blue_theme/theme4_wrong_image.png";
                                                      storage.write("wrongOptionImage", dataProvider.wrongOptionImage);
                                                      dataProvider.questionImage = "assets/images/blue_theme/theme4_question_image1.jpeg";
                                                      storage.write("questionImage", dataProvider.questionImage);
                                                      dataProvider.lifeLineImage = "assets/images/blue_theme/theme4_lifeline_image.png";
                                                      storage.write("lifeLineImage", dataProvider.lifeLineImage);
                                                      dataProvider.textColor = Colors.white;
                                                      storage.write("textColor", dataProvider.textColor.value.toRadixString(16));
                                                      dataProvider.lifeLineBoxColor = Colors.black54;
                                                      storage.write("lifeLineBoxColor", dataProvider.lifeLineBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyBoxColor = Colors.black54;
                                                      storage.write("currencyBoxColor", dataProvider.currencyBoxColor.value.toRadixString(16));
                                                      dataProvider.currencyTextColor = Colors.white;
                                                      storage.write("currencyTextColor", dataProvider.currencyTextColor.value.toRadixString(16));
                                                      dataProvider.timeBoxColor = Colors.black;
                                                      storage.write("timeBoxColor", dataProvider.timeBoxColor.value.toRadixString(16));
                                                      dataProvider.questionTextColor = Colors.white;
                                                      storage.write("questionTextColor", dataProvider.questionTextColor.value.toRadixString(16));
                                                      dataProvider.iconColor = Colors.white;
                                                      storage.write("iconColor", dataProvider.iconColor.value.toRadixString(16));
                                                      dataProvider.second = Colors.white;
                                                      storage.write("second", dataProvider.second.value.toRadixString(16));
                                                      dataProvider.borderColor = Colors.white;
                                                      storage.write("borderColor", dataProvider.borderColor.value.toRadixString(16));
                                                      dataProvider.settingColor = HexColor('4d2d61');
                                                      storage.write("settingColor", dataProvider.settingColor.value.toRadixString(16));
                                                      dataProvider.settingBoxColor = HexColor('5d3a6f');
                                                      storage.write("settingBoxColor", dataProvider.settingBoxColor.value.toRadixString(16));
                                                      dataProvider.quColor = Colors.white;
                                                      storage.write("quColor", dataProvider.quColor.value.toRadixString(16));
                                                      dataProvider.seColor = HexColor('442858');
                                                      storage.write("seColor", dataProvider.seColor.value.toRadixString(16));
                                                      dataProvider.noSeColor = HexColor('725483');
                                                      storage.write("noSeColor", dataProvider.noSeColor.value.toRadixString(16));
                                                      dataProvider.themeChangeDialog = false;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height: isIpad ? 150.sp : 170.sp,
                                                      width: 140.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.r),
                                                        border: Border.all(width: 1.w, color: Colors.white),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage('assets/images/blue_theme/theme4_bg_image.jpeg'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
  }

  Future<void> fetchData() async {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.backgroundImage = storage.read("backgroundImage") ?? dataProvider.backgroundImage;
    dataProvider.optionImage = storage.read("optionImage") ?? dataProvider.optionImage;
    dataProvider.correctOptionImage = storage.read("correctOptionImage") ?? dataProvider.correctOptionImage;
    dataProvider.wrongOptionImage = storage.read("wrongOptionImage") ?? dataProvider.wrongOptionImage;
    dataProvider.questionImage = storage.read("questionImage") ?? dataProvider.questionImage;
    dataProvider.lifeLineImage = storage.read("lifeLineImage") ?? dataProvider.lifeLineImage;
    String? storedTextColor = storage.read("textColor");
    String? storedCurrencyColor = storage.read("currencyTextColor");
    String? storedLifeLineColor = storage.read("lifeLineBoxColor");
    String? storedBoxColor = storage.read("currencyBoxColor");
    String? storedTimeBoxColor = storage.read("timeBoxColor");
    String? storedQuestionText = storage.read("questionTextColor");
    String? storedIconColor = storage.read("iconColor");
    String? storedSecondColor = storage.read("second");
    String? storedBorderColor = storage.read("borderColor");
    String? storedSettingColor = storage.read("settingColor");
    String? storedSettingBoxColor = storage.read("settingBoxColor");
    String? storedQuColor = storage.read("quColor");
    String? storedSeColor = storage.read("seColor");
    String? storedNoseColor = storage.read("noSeColor");
    if (storedTextColor != null &&
        storedCurrencyColor != null &&
        storedLifeLineColor != null &&
        storedBoxColor != null &&
        storedTimeBoxColor != null &&
        storedQuestionText != null &&
        storedIconColor != null &&
        storedSecondColor != null &&
        storedBorderColor != null &&
        storedSettingColor != null &&
        storedSettingBoxColor != null &&
        storedQuColor != null &&
        storedSeColor != null &&
        storedNoseColor != null) {
      dataProvider.textColor = Color(int.parse(storedTextColor, radix: 16));
      dataProvider.currencyTextColor = Color(int.parse(storedCurrencyColor, radix: 16));
      dataProvider.lifeLineBoxColor = Color(int.parse(storedLifeLineColor, radix: 16));
      dataProvider.currencyBoxColor = Color(int.parse(storedBoxColor, radix: 16));
      dataProvider.timeBoxColor = Color(int.parse(storedTimeBoxColor, radix: 16));
      dataProvider.questionTextColor = Color(int.parse(storedQuestionText, radix: 16));
      dataProvider.iconColor = Color(int.parse(storedIconColor, radix: 16));
      dataProvider.second = Color(int.parse(storedSecondColor, radix: 16));
      dataProvider.borderColor = Color(int.parse(storedBorderColor, radix: 16));
      dataProvider.settingColor = Color(int.parse(storedSettingColor, radix: 16));
      dataProvider.settingBoxColor = Color(int.parse(storedSettingBoxColor, radix: 16));
      dataProvider.quColor = Color(int.parse(storedQuColor, radix: 16));
      dataProvider.seColor = Color(int.parse(storedSeColor, radix: 16));
      dataProvider.noSeColor = Color(int.parse(storedNoseColor, radix: 16));
    } else {
      dataProvider.textColor = Colors.black;
      dataProvider.currencyTextColor = Colors.brown.shade700;
      dataProvider.lifeLineBoxColor = Colors.brown.shade100;
      dataProvider.currencyBoxColor = HexColor('CFB595');
      dataProvider.timeBoxColor = Colors.brown.shade800;
      dataProvider.questionTextColor = Colors.black;
      dataProvider.iconColor = Colors.black;
      dataProvider.second = Colors.black;
      dataProvider.borderColor = Colors.brown.shade700;
      dataProvider.settingColor = HexColor('6f473e');
      dataProvider.settingBoxColor = HexColor('8c5d50');
      dataProvider.quColor = Colors.white;
      dataProvider.seColor = HexColor('7a4231');
      dataProvider.noSeColor = HexColor('975942');
    }
    setState(() {
      dataProvider.isLoading = false;
    });
  }
}
