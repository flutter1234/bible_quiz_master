import 'package:bible_quiz_master/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_master/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_master/AdPlugin/Ads/Native/NativeRN.dart';
import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/Quiz_screen/quiz_screen.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class levels_screen extends StatefulWidget {
  static const routeName = "/levels_screen";

  const levels_screen({super.key});

  @override
  State<levels_screen> createState() => _levels_screenState();
}

class _levels_screenState extends State<levels_screen> {
  int chapter = 0;
  List quizChapters = [];
  List chapterLevels = [];
  List levelQuestions = [];
  bool levelShow = false;
  List levelShowList = [];
  List cheLevel = [];

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.levelIndex = storage.read("levelIndex") ?? 0;
    levelShowList = storage.read("levelShowList") ?? List.filled(dataProvider.bibleList['data'].length, false);
    levelShowList[dataProvider.chapterIndex] = true;
    dataProvider.tempList = storage.read("tempList") ??
        List.generate(
          dataProvider.bibleList['data'].length,
          (chapterIndex) => List.generate(dataProvider.bibleList['data'][chapterIndex]['Chapter'].length, (listIndex) => false),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return BannerWrapper(
      parentContext: context,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(dataProvider.backgroundImage),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: isSmall
                  ? 20.h
                  : isIpad
                      ? 15.h
                      : 40.h,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: isIpad ? 22.sp : 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                      Text(
                        'Levels',
                        style: GoogleFonts.breeSerif(
                          fontSize: isIpad ? 22.sp : 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Spacer(),
                      Stack(
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
                                style: GoogleFonts.breeSerif(
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
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 15.h),
                    itemCount: dataProvider.bibleList['data'].length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          index == 3 ? NativeRN(parentContext: context) : SizedBox(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 2.sp),
                            child: GestureDetector(
                              onTap: () {
                                levelShowList[index] = !levelShowList[index];
                                setState(() {});
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: isIpad ? 50.sp : 55.sp,
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(dataProvider.optionImage),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 55.w),
                                          child: Text(
                                            'Chapter ${index + 1}',
                                            style: GoogleFonts.breeSerif(
                                              fontSize: isIpad ? 16.sp : 18.sp,
                                              color: dataProvider.textColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                        ),
                                        Text(
                                          '${(index + 1) * 3 - 2} - ${(index + 1) * 3}',
                                          style: GoogleFonts.breeSerif(
                                            fontSize: isIpad ? 16.sp : 18.sp,
                                            color: dataProvider.textColor,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        if (levelShowList[index]) ...{
                                          Padding(
                                            padding: EdgeInsets.only(right: 40.w),
                                            child: Icon(
                                              Icons.keyboard_arrow_up,
                                              size: 25.sp,
                                              color: dataProvider.textColor,
                                            ),
                                          )
                                        } else ...{
                                          Padding(
                                            padding: EdgeInsets.only(right: 40.w),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 25.sp,
                                              color: dataProvider.textColor,
                                            ),
                                          )
                                        }
                                      ],
                                    ),
                                  ),
                                  levelShowList[index] == true
                                      ? Container(
                                          height: isIpad ? 85.sp : 100.sp,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: dataProvider.bibleList['data'][index]['Chapter'].length,
                                            itemBuilder: (context, index2) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 2.sp),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (dataProvider.tempList[index][index2] ||
                                                        (index == 0 && index2 == 0) ||
                                                        (index2 > 0 && dataProvider.tempList[index][index2 - 1]) ||
                                                        (index == 0 ? dataProvider.tempList[index][index2 - 1] : dataProvider.tempList[index - 1][2])) {
                                                      dataProvider.passLevel = dataProvider.tempList[index][index2];
                                                      dataProvider.levelIndex = index2;
                                                      dataProvider.chapterIndex = index;
                                                      AdsRN().showFullScreen(
                                                        context: context,
                                                        onComplete: () {
                                                          Navigator.pushNamed(context, quiz_screen.routeName);
                                                        },
                                                      );

                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    height: isIpad ? 25.sp : 30.sp,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.r),
                                                      border: Border.all(width: 0.5, color: dataProvider.borderColor),
                                                      color: dataProvider.currencyBoxColor,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${dataProvider.bibleList['data'][index]['Chapter'][index2]['Levels']}',
                                                            style: GoogleFonts.breeSerif(
                                                              fontSize: isIpad ? 16.sp : 18.sp,
                                                              color: dataProvider.currencyTextColor,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Icon(
                                                            dataProvider.tempList[index][index2] == true
                                                                ? Icons.check
                                                                : (index == 0 && index2 == 0)
                                                                    ? Icons.play_arrow
                                                                    : (index2 > 0 && (dataProvider.tempList[index][index2 - 1] == true)) ||
                                                                            (index == 0
                                                                                ? dataProvider.tempList[index][index2 - 1] == true
                                                                                : (dataProvider.tempList[index - 1][2] == true && index2 == 0))
                                                                        ? Icons.play_arrow
                                                                        : Icons.lock,
                                                            color: Colors.green,
                                                            size: isIpad ? 20.sp : 22.sp,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
