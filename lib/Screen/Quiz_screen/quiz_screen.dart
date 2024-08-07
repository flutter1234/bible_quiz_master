import 'dart:async';
import 'dart:ui';
import 'package:bible_quiz_master/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_master/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_master/AdPlugin/MainJson/MainJson.dart';
import 'package:bible_quiz_master/AdPlugin/Utils/Extensions.dart';
import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math' as math;

class quiz_screen extends StatefulWidget {
  static const routeName = '/quiz_screen';

  const quiz_screen({super.key});

  @override
  State<quiz_screen> createState() => _quiz_screenState();
}

class _quiz_screenState extends State<quiz_screen> {
  bool isLoading = true;
  int start = 30;
  int totalStepCount = 30;
  int questionIndex = 0;
  bool colorChange = false;
  bool answerTap = false;
  String selectAnswer = "";
  String trueAnswer = "";
  String ABCD = 'ABCD';
  late Timer timer;
  bool falseDialog = false;
  bool tryAgainDialog = false;
  bool halfOption = false;
  bool levelComplete = false;

  timeHandle() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (start == 0) {
        timer.cancel();
        tryAgainDialog = true;
        setState(() {});
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void initState() {
    dataLoad().then((value) {
      isLoading = false;
    });
    super.initState();
  }

  Future<void> dataLoad() async {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    context.read<Api>().multiQuiz(context.read<MainJson>().data!['assets']['multiQuiz']).then(
      (value) {
        timeHandle();
        dataProvider.currency = storage.read("currency") ?? 0;
        dataProvider.wrongAnswersDetailsList = storage.read("wrongAnswersDetailsList") ?? [];
        dataProvider.correctAnswersDetailsList = storage.read("correctAnswersDetailsList") ?? [];
        if (dataProvider.passLevel) {
        } else {
          dataProvider.levelIndex = storage.read("levelIndex") ?? 0;
          dataProvider.chapterIndex = storage.read("chapterIndex") ?? 0;
        }
        dataProvider.tempList = storage.read("tempList") ??
            List.generate(
              dataProvider.bibleList['data'].length,
              (chapterIndex) => List.generate(dataProvider.bibleList['data'][chapterIndex]['Chapter'].length, (listIndex) => false),
            );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return BannerWrapper(
      parentContext: context,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(dataProvider.backgroundImage),
                ),
              ),
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.white,
                        size: isIpad ? 40.sp : 50.sp,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        top: isSmall
                            ? 20.h
                            : isIpad
                                ? 13.h
                                : 40.h,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: isIpad ? 20.sp : 26.sp,
                                  width: 80.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.w, color: dataProvider.borderColor),
                                    color: dataProvider.currencyBoxColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Levels']}',
                                      style: GoogleFonts.breeSerif(
                                        fontSize: isIpad ? 12.sp : 16.sp,
                                        color: dataProvider.currencyTextColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                CircularStepProgressIndicator(
                                  totalSteps: totalStepCount,
                                  circularDirection: CircularDirection.counterclockwise,
                                  currentStep: start,
                                  padding: math.pi / 60,
                                  unselectedColor: Colors.black,
                                  selectedColor: Colors.yellow.shade700,
                                  selectedStepSize: 3.sp,
                                  unselectedStepSize: 3.sp,
                                  width: isSmall
                                      ? 50.sp
                                      : isIpad
                                          ? 45.sp
                                          : 55.sp,
                                  height: isSmall
                                      ? 50.sp
                                      : isIpad
                                          ? 45.sp
                                          : 55.sp,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.sp),
                                    child: Container(
                                      height: 50.sp,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: dataProvider.timeBoxColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${start}',
                                          style: GoogleFonts.breeSerif(
                                            fontSize: isSmall
                                                ? 20.sp
                                                : isIpad
                                                    ? 18.sp
                                                    : 23.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 1.w),
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
                          Padding(
                            padding: EdgeInsets.only(top: isSmall ? 25.h : 30.h),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: isSmall
                                      ? 145.sp
                                      : isIpad
                                          ? 110.sp
                                          : 180.sp,
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(dataProvider.questionImage),
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 22.sp),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        '${dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['question']}',
                                        style: GoogleFonts.raleway(
                                          fontSize: isSmall
                                              ? 18.sp
                                              : isIpad
                                                  ? 15.sp
                                                  : 20.sp,
                                          color: dataProvider.questionTextColor,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: isSmall
                                      ? -25.h
                                      : isIpad
                                          ? -30.h
                                          : -25.h,
                                  child: Container(
                                    height: isSmall
                                        ? 60.sp
                                        : isIpad
                                            ? 50.sp
                                            : 70.sp,
                                    width: isIpad ? 180.w : 220.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/question_index.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Question',
                                            style: GoogleFonts.raleway(
                                              fontSize: isSmall
                                                  ? 14.sp
                                                  : isIpad
                                                      ? 10.sp
                                                      : 16.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            '${questionIndex + 1}/${dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'].length}',
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: isSmall
                                                  ? 16.sp
                                                  : isIpad
                                                      ? 13.sp
                                                      : 18.sp,
                                              color: Colors.yellow,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: isIpad ? 5.h : 15.h),
                              itemCount: dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['answers'].length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                int trueIndex = dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['correct_answer'] - 1;
                                int hideindex1 = 0;
                                if (trueIndex == 0) {
                                  hideindex1 = 1;
                                } else if (trueIndex == 1) {
                                  hideindex1 = 2;
                                } else if (trueIndex == 2) {
                                  hideindex1 = 3;
                                } else if (trueIndex == 3) {
                                  hideindex1 = 0;
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: isIpad ? 2.sp : 3.sp),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!answerTap) {
                                        setState(() {
                                          selectAnswer = dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['answers'][index];
                                          if (dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['correct_answer'] == index + 1) {
                                            if (dataProvider.soundOn == true) {
                                              dataProvider.initCorrect();
                                            }
                                            colorChange = true;
                                            answerTap = true;
                                            storeCorrectAnswerDetails(dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]);
                                            // print("correctAnswer =========>>>>${dataProvider.correctAnswersDetailsList}");
                                            timer.cancel();
                                            Future.delayed(Duration(seconds: 2)).then((value) {
                                              colorChange = false;
                                              answerTap = false;
                                              halfOption = false;
                                              if (questionIndex < dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'].length - 1) {
                                                questionIndex++;
                                                start = 30;
                                                timeHandle();
                                              } else {
                                                levelComplete = true;
                                              }
                                              setState(() {});
                                            });
                                          } else {
                                            if (dataProvider.soundOn == true) {
                                              dataProvider.initWrong();
                                            }
                                            colorChange = true;
                                            answerTap = true;
                                            storeWrongAnswerDetails(dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]);
                                            // print("wrongAnswer =========>>>>${dataProvider.wrongAnswersDetailsList}");
                                            timer.cancel();
                                            Future.delayed(Duration(seconds: 2)).then((value) {
                                              falseDialog = true;
                                              halfOption = false;
                                              setState(() {});
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: halfOption == true && (hideindex1 == index)
                                        ? IgnorePointer(
                                            ignoring: true,
                                            child: Container(
                                              height: isSmall
                                                  ? 65.sp
                                                  : isIpad
                                                      ? 48.sp
                                                      : 70.sp,
                                              color: Colors.transparent,
                                            ),
                                          )
                                        : Container(
                                            height: isSmall
                                                ? 62.sp
                                                : isIpad
                                                    ? 48.sp
                                                    : 70.sp,
                                            width: 1.sw,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: colorChange == true
                                                    ? index + 1 ==
                                                            dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['correct_answer']
                                                        ? AssetImage(dataProvider.correctOptionImage)
                                                        : selectAnswer ==
                                                                dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['answers']
                                                                    [index]
                                                            ? AssetImage(dataProvider.wrongOptionImage)
                                                            : AssetImage(dataProvider.optionImage)
                                                    : AssetImage(dataProvider.optionImage),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 50.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${ABCD[index]} : ",
                                                    style: GoogleFonts.raleway(
                                                      fontSize: isIpad ? 15.sp : 20.sp,
                                                      color: colorChange == true
                                                          ? index + 1 ==
                                                                  dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]
                                                                      ['correct_answer']
                                                              ? Colors.white
                                                              : selectAnswer ==
                                                                      dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]
                                                                          ['answers'][index]
                                                                  ? Colors.white
                                                                  : dataProvider.textColor
                                                          : dataProvider.textColor,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: isIpad ? 50.w : 35.w),
                                                      child: Text(
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        "${dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]['answers'][index]}",
                                                        style: GoogleFonts.raleway(
                                                          fontSize: isIpad ? 12.sp : 16.sp,
                                                          color: colorChange == true
                                                              ? index + 1 ==
                                                                      dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]
                                                                          ['correct_answer']
                                                                  ? Colors.white
                                                                  : selectAnswer ==
                                                                          dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'][questionIndex]
                                                                              ['answers'][index]
                                                                      ? Colors.white
                                                                      : dataProvider.textColor
                                                              : dataProvider.textColor,
                                                          fontWeight: FontWeight.w900,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.sp,
                              vertical: isIpad
                                  ? 5.sp
                                  : isSmall
                                      ? 0.sp
                                      : 10.sp,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (dataProvider.currency >= 100) {
                                          if (dataProvider.soundOn == true) {
                                            dataProvider.initLifeLine();
                                          }
                                          "second_button".performScreenAction(
                                            context: context,
                                            onComplete: () {
                                              start += 20;
                                              totalStepCount += 20;
                                              dataProvider.currency = dataProvider.currency - 100;
                                              storage.write("currency", dataProvider.currency);
                                              setState(() {});
                                            },
                                          );
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            width: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(dataProvider.lifeLineImage),
                                              ),
                                            ),
                                            child: Center(
                                              child: Stack(
                                                alignment: Alignment.bottomCenter,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Icon(
                                                    Icons.timer_outlined,
                                                    color: dataProvider.iconColor,
                                                    size: isIpad ? 23.sp : 26.sp,
                                                  ),
                                                  Positioned(
                                                    top: isSmall
                                                        ? 22.h
                                                        : isIpad
                                                            ? 24.h
                                                            : 18.h,
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      '+20S',
                                                      style: GoogleFonts.notoSans(
                                                        fontSize: isSmall
                                                            ? 9.sp
                                                            : isIpad
                                                                ? 8.sp
                                                                : 10.sp,
                                                        color: dataProvider.second,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (dataProvider.currency < 100)
                                            ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                child: Container(
                                                  height: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  width: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  color: Colors.black.withOpacity(0),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Container(
                                      height: isIpad ? 13.sp : 15.sp,
                                      width: isIpad ? 45.w : 50.w,
                                      decoration: BoxDecoration(
                                        color: dataProvider.lifeLineBoxColor,
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            '100',
                                            style: GoogleFonts.notoSans(
                                              fontSize: isIpad ? 8.sp : 10.sp,
                                              color: dataProvider.iconColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Image(
                                            image: AssetImage('assets/images/single_diamond.png'),
                                            height: 12.sp,
                                            width: 12.w,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (dataProvider.currency >= 120) {
                                          if (dataProvider.soundOn == true) {
                                            dataProvider.initLifeLine();
                                          }
                                          "remove_option_button".performScreenAction(
                                            context: context,
                                            onComplete: () {
                                              halfOption = true;
                                              // dataProvider.currency = dataProvider.currency - 120;
                                              storage.write("currency", dataProvider.currency);
                                              setState(() {});
                                            },
                                          );
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            width: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(dataProvider.lifeLineImage),
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.format_color_fill_rounded,
                                                color: dataProvider.iconColor,
                                                size: isIpad ? 20.sp : 30.sp,
                                              ),
                                            ),
                                          ),
                                          if (dataProvider.currency < 120)
                                            ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                child: Container(
                                                  height: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  width: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  color: Colors.black.withOpacity(0),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Container(
                                      height: isIpad ? 13.sp : 15.sp,
                                      width: isIpad ? 45.w : 50.w,
                                      decoration: BoxDecoration(
                                        color: dataProvider.lifeLineBoxColor,
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            '120',
                                            style: GoogleFonts.notoSans(
                                              fontSize: isIpad ? 8.sp : 10.sp,
                                              color: dataProvider.iconColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Image(
                                            image: AssetImage('assets/images/single_diamond.png'),
                                            height: 12.sp,
                                            width: 12.w,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (dataProvider.currency >= 200) {
                                          if (dataProvider.soundOn == true) {
                                            dataProvider.initLifeLine();
                                          }
                                          "correct_answer_button".performScreenAction(
                                            context: context,
                                            onComplete: () {
                                              if (questionIndex < dataProvider.bibleList['data'][dataProvider.chapterIndex]['Chapter'][dataProvider.levelIndex]['Question'].length - 1) {
                                                timer.cancel();
                                                setState(() {
                                                  Future.delayed(Duration(seconds: 2)).then((value) {
                                                    colorChange = false;
                                                    answerTap = false;
                                                    questionIndex++;
                                                    start = 30;
                                                    timeHandle();
                                                    setState(() {});
                                                  });
                                                });
                                              } else {
                                                Future.delayed(Duration(seconds: 2)).then((value) {
                                                  levelComplete = true;
                                                  setState(() {});
                                                });
                                              }
                                            },
                                          );
                                          colorChange = true;
                                          dataProvider.currency = dataProvider.currency - 200;
                                          storage.write("currency", dataProvider.currency);
                                          setState(() {});
                                        } else {
                                          print("Dialog");
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            width: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(dataProvider.lifeLineImage),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.light_mode_sharp,
                                              color: dataProvider.iconColor,
                                              size: isIpad ? 25.sp : 30.sp,
                                            ),
                                          ),
                                          if (dataProvider.currency < 200)
                                            ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                child: Container(
                                                  height: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  width: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  color: Colors.black.withOpacity(0),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Container(
                                      height: isIpad ? 13.sp : 15.sp,
                                      width: isIpad ? 45.w : 50.w,
                                      decoration: BoxDecoration(
                                        color: dataProvider.lifeLineBoxColor,
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            '200',
                                            style: GoogleFonts.notoSans(
                                              fontSize: isIpad ? 8.sp : 10.sp,
                                              color: dataProvider.iconColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Image(
                                            image: AssetImage('assets/images/single_diamond.png'),
                                            height: 12.sp,
                                            width: 12.w,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (context.read<MainJson>().data![context.read<MainJson>().version]['globalConfig']['globalAdFlag'] == true) {
                                          "video_button".performScreenAction(
                                            context: context,
                                            onComplete: () {
                                              dataProvider.currency = dataProvider.currency + 50;
                                              storage.write("currency", dataProvider.currency);
                                              setState(() {});
                                            },
                                          );
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            width: isSmall
                                                ? 45.sp
                                                : isIpad
                                                    ? 35.sp
                                                    : 50.sp,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(dataProvider.lifeLineImage),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.video_call_outlined,
                                              color: dataProvider.iconColor,
                                              size: isIpad ? 25.sp : 30.sp,
                                            ),
                                          ),
                                          if (context.read<MainJson>().data![context.read<MainJson>().version]['globalConfig']['globalAdFlag'] == false)
                                            ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                child: Container(
                                                  height: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  width: isSmall
                                                      ? 45.sp
                                                      : isIpad
                                                          ? 35.sp
                                                          : 50.sp,
                                                  color: Colors.black.withOpacity(0),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Container(
                                      height: isIpad ? 13.sp : 15.sp,
                                      width: isIpad ? 45.w : 50.w,
                                      decoration: BoxDecoration(
                                        color: dataProvider.lifeLineBoxColor,
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            '50',
                                            style: GoogleFonts.notoSans(
                                              fontSize: isIpad ? 8.sp : 10.sp,
                                              color: dataProvider.iconColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Image(
                                            image: AssetImage('assets/images/single_diamond.png'),
                                            height: 12.sp,
                                            width: 12.w,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: isIpad
                                ? 0.h
                                : isSmall
                                    ? 8.h
                                    : 15.h,
                          ),
                        ],
                      ),
                    ),
            ),
            falseDialog == true
                ? Scaffold(
                    backgroundColor: Colors.black54.withOpacity(0.8),
                    body: Container(
                      height: 1.sh,
                      width: 1.sw,
                      child: Padding(
                        padding: EdgeInsets.only(top: 52.h),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 26.sp,
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
                                            fontSize: 16.sp,
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
                                        height: 28.sp,
                                        width: 35.w,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(25.sp),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Don't give up, try to start challenging your winning streak!",
                                    style: GoogleFonts.breeSerif(
                                      fontSize: isIpad ? 20.sp : 22.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            if (dataProvider.currency > 80) ...{
                              GestureDetector(
                                onTap: () {
                                  AdsRN().showFullScreen(
                                    context: context,
                                    onComplete: () {
                                      if (dataProvider.soundOn == true) {
                                        dataProvider.initOnTap();
                                      }
                                      dataProvider.currency = dataProvider.currency - 80;
                                      storage.write("currency", dataProvider.currency);
                                      falseDialog = false;
                                      colorChange = false;
                                      answerTap = false;
                                      start = 30;
                                      selectAnswer = "";
                                      timeHandle();
                                      setState(() {});
                                    },
                                  );
                                },
                                child: Container(
                                  height: isIpad ? 50.sp : 55.sp,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/recovery_image.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Image(
                                              image: AssetImage('assets/images/single_diamond.png'),
                                              height: isIpad ? 20.sp : 22.sp,
                                            ),
                                          ),
                                          Text(
                                            " 80  Recovery",
                                            style: GoogleFonts.breeSerif(
                                              fontSize: isIpad ? 18.sp : 20.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            } else ...{
                              GestureDetector(
                                onTap: () {
                                  AdsRN().showFullScreen(
                                    context: context,
                                    onComplete: () {
                                      if (dataProvider.soundOn == true) {
                                        dataProvider.initOnTap();
                                      }
                                      colorChange = false;
                                      selectAnswer = "";
                                      answerTap = false;
                                      questionIndex = 0;
                                      falseDialog = false;
                                      start = 30;
                                      halfOption = false;
                                      timeHandle();
                                      setState(() {});
                                    },
                                  );
                                },
                                child: Container(
                                  height: 55.sp,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/recovery_image.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.autorenew_rounded,
                                          size: 25.sp,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Try Again",
                                          style: GoogleFonts.breeSerif(
                                            fontSize: 22.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            },
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                if (dataProvider.soundOn == true) {
                                  dataProvider.initOnTap();
                                }
                                falseDialog = false;
                                tryAgainDialog = true;
                                setState(() {});
                              },
                              child: Text(
                                "No thanks",
                                style: GoogleFonts.breeSerif(
                                  fontSize: 22.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 132.sp),
                              child: Container(
                                height: 0.5.h,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            tryAgainDialog == true
                ? Scaffold(
                    backgroundColor: Colors.black54.withOpacity(0.8),
                    body: Container(
                      height: 1.sh,
                      width: 1.sw,
                      child: Padding(
                        padding: EdgeInsets.only(top: 52.h),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 26.sp,
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
                                            fontSize: 16.sp,
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
                                        height: 28.sp,
                                        width: 35.w,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(25.sp),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Don't give up, try to start challenging your winning streak!",
                                    style: GoogleFonts.breeSerif(
                                      fontSize: 22.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              ],
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
                                    colorChange = false;
                                    selectAnswer = "";
                                    answerTap = false;
                                    questionIndex = 0;
                                    tryAgainDialog = false;
                                    start = 30;
                                    halfOption = false;
                                    timeHandle();
                                    setState(() {});
                                  },
                                );
                              },
                              child: Container(
                                height: 55.sp,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/recovery_image.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.autorenew_rounded,
                                        size: 25.sp,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Try Again",
                                        style: GoogleFonts.breeSerif(
                                          fontSize: 22.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            levelComplete == true
                ? Scaffold(
                    backgroundColor: Colors.black54.withOpacity(0.8),
                    body: Container(
                      height: 1.sh,
                      width: 1.sw,
                      child: Padding(
                        padding: EdgeInsets.only(top: 52.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 26.sp,
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
                                            fontSize: 16.sp,
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
                                        height: 28.sp,
                                        width: 35.w,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.sp),
                              child: Container(
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(dataProvider.backgroundImage), fit: BoxFit.fill),
                                  border: Border.all(width: 1.w, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.sp),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 100.sp,
                                        width: 180.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage('assets/images/level_end_banner.png'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        'SCORE',
                                        style: GoogleFonts.b612(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Container(
                                        height: 30.sp,
                                        width: 130.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.w, color: dataProvider.borderColor),
                                          color: dataProvider.currencyBoxColor,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${dataProvider.currency}',
                                            style: GoogleFonts.b612(
                                              fontSize: 18.sp,
                                              color: dataProvider.currencyTextColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.h, bottom: 5.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 1.h,
                                              width: 90.w,
                                              color: Colors.brown.shade900,
                                            ),
                                            Container(
                                              height: 1.h,
                                              width: 90.w,
                                              color: Colors.brown.shade900,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'REWARD',
                                        style: GoogleFonts.b612(
                                          fontSize: 18.sp,
                                          // color: HexColor('CFB595'),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(
                                            image: AssetImage('assets/images/single_diamond.png'),
                                            height: 25.sp,
                                            width: 25.w,
                                          ),
                                          Text(
                                            '100',
                                            style: GoogleFonts.b612(
                                              fontSize: 18.sp,
                                              color: Colors.brown.shade100,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      GestureDetector(
                                        onTap: () {
                                          AdsRN().showFullScreen(
                                            context: context,
                                            onComplete: () {
                                              if (dataProvider.soundOn == true) {
                                                dataProvider.initOnTap();
                                              }
                                              dataProvider.tempList[dataProvider.chapterIndex][dataProvider.levelIndex] = true;
                                              storage.write("tempList", dataProvider.tempList);

                                              if ((dataProvider.levelIndex + 1) % 3 == 0) {
                                                dataProvider.chapterIndex++;
                                                storage.write("chapterIndex", dataProvider.chapterIndex);
                                                dataProvider.levelIndex = 0;
                                                print("chapterIndex ===>>${dataProvider.chapterIndex}");
                                                setState(() {});
                                              } else {
                                                dataProvider.levelIndex++;
                                              }
                                              storage.write("levelIndex", dataProvider.levelIndex);
                                              dataProvider.currency = dataProvider.currency + 100;
                                              storage.write("currency", dataProvider.currency);
                                              questionIndex = 0;
                                              colorChange = false;
                                              answerTap = false;
                                              start = 30;
                                              timeHandle();
                                              levelComplete = false;

                                              setState(() {});
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 45.sp,
                                          width: 200.w,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/recovery_image.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Next Level",
                                              style: GoogleFonts.breeSerif(
                                                fontSize: 20.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
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
                            Spacer(),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void storeWrongAnswerDetails(Map<String, dynamic> questionDetails) {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    Map<String, dynamic> wrongAnswerDetails = {
      'question': questionDetails['question'],
      'options': List<String>.from(questionDetails['answers']),
      'correctAnswerIndex': questionDetails['correct_answer'],
    };

    dataProvider.wrongAnswersDetailsList.add(wrongAnswerDetails);
    storage.write("wrongAnswersDetailsList", dataProvider.wrongAnswersDetailsList);
  }

  void storeCorrectAnswerDetails(Map<String, dynamic> questionDetails) {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    Map<String, dynamic> correctAnswerDetails = {
      'question': questionDetails['question'],
      'options': List<String>.from(questionDetails['answers']),
      'correctAnswerIndex': questionDetails['correct_answer']
    };

    dataProvider.correctAnswersDetailsList.add(correctAnswerDetails);
    storage.write("correctAnswersDetailsList", dataProvider.correctAnswersDetailsList);
  }
}
