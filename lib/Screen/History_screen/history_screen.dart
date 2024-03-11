import 'dart:ui';
import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class history_screen extends StatefulWidget {
  static const routeName = '/history_screen';

  const history_screen({super.key});

  @override
  State<history_screen> createState() => _history_screenState();
}

class _history_screenState extends State<history_screen> {
  bool correctDialog = false;
  bool wrongDialog = false;
  String question = "";
  List option = [];
  int correctIndex = 0;
  String ABCD = 'ABCD';
  int option1 = 0;

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.questionTrue = 'Correct';
    dataProvider.wrongAnswersDetailsList = storage.read("wrongAnswersDetailsList") ?? [];
    dataProvider.correctAnswersDetailsList = storage.read("correctAnswersDetailsList") ?? [];
    // print("wrongAnswersDetailsList ==============>>>${dataProvider.wrongAnswersDetailsList}");
    // print("correctAnswersDetailsList ==============>>>${dataProvider.correctAnswersDetailsList}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);

    return Scaffold(
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
            top: isIpad
                ? 25.h
                : isSmall
                    ? 30.h
                    : 40.h,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: isIpad ? 20.sp : 25.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          dataProvider.questionTrue == "Correct"
                              ? 'Answered Correctly'
                              : dataProvider.questionTrue == "Wrong"
                                  ? 'Answered Wrongly'
                                  : '',
                          style: GoogleFonts.lora(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(width: 10.w)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Container(
                      height: isIpad ? 45.sp : 55.sp,
                      width: 1.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                dataProvider.questionTrue = "Correct";
                              });
                            },
                            child: Container(
                              height: 55.sp,
                              width: 1.sw / 1 / 2,
                              decoration: BoxDecoration(
                                color: dataProvider.questionTrue == "Correct" ? dataProvider.seColor : dataProvider.noSeColor,
                                border: Border.all(width: 0.5.w, color: Colors.white),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.playlist_add_check,
                                  size: 40.sp,
                                  color: Colors.green.shade400,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                dataProvider.questionTrue = "Wrong";
                              });
                            },
                            child: Container(
                              height: 55.sp,
                              width: 1.sw / 1 / 2,
                              decoration: BoxDecoration(
                                color: dataProvider.questionTrue == "Wrong" ? dataProvider.seColor : dataProvider.noSeColor,
                                border: Border.all(width: 0.5.w, color: Colors.white),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.playlist_remove_outlined,
                                  size: 40.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (dataProvider.questionTrue == "Correct") ...{
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 15.h),
                        itemCount: dataProvider.correctAnswersDetailsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  correctDialog = true;
                                  question = dataProvider.correctAnswersDetailsList[index]['question'];
                                  option = dataProvider.correctAnswersDetailsList[index]['options'];
                                  option1 = dataProvider.correctAnswersDetailsList[index]['options'].length;
                                  correctIndex = dataProvider.correctAnswersDetailsList[index]['correctAnswerIndex'];
                                });
                              },
                              child: Container(
                                height: 65.sp,
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(dataProvider.optionImage),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 45.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}.',
                                        style: GoogleFonts.raleway(
                                          fontSize: 18.sp,
                                          color: dataProvider.textColor,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: isIpad ? 50.w : 40.w),
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            '${dataProvider.correctAnswersDetailsList[index]['question']}',
                                            style: GoogleFonts.raleway(
                                              fontSize: 13.sp,
                                              color: dataProvider.textColor,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
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
                    )
                  } else if (dataProvider.questionTrue == "Wrong") ...{
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 15.h),
                        itemCount: dataProvider.wrongAnswersDetailsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  wrongDialog = true;
                                  question = dataProvider.wrongAnswersDetailsList[index]['question'];
                                  option = dataProvider.wrongAnswersDetailsList[index]['options'];
                                  option1 = dataProvider.wrongAnswersDetailsList[index]['options'].length;
                                  correctIndex = dataProvider.wrongAnswersDetailsList[index]['correctAnswerIndex'];
                                });
                              },
                              child: Container(
                                height: 65.sp,
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(dataProvider.optionImage),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 45.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}.',
                                        style: GoogleFonts.raleway(
                                          fontSize: 18.sp,
                                          color: dataProvider.textColor,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: isIpad ? 50.w : 40.w),
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            '${dataProvider.wrongAnswersDetailsList[index]['question']}',
                                            style: GoogleFonts.raleway(
                                              fontSize: 13.sp,
                                              color: dataProvider.textColor,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
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
                    )
                  }
                ],
              ),
              correctDialog == true
                  ? Container(
                      color: Colors.transparent,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.sp),
                            child: Container(
                              height: option1 == 2 ? 270.sp : 400.sp,
                              width: 1.sw,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(dataProvider.backgroundImage),
                                  fit: BoxFit.fill,
                                ),
                                border: Border.all(width: 2.w, color: Colors.white),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 22.w),
                                        Text(
                                          'Question',
                                          style: GoogleFonts.lora(
                                            fontSize: 22.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              correctDialog = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 30.sp,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1.h,
                                    width: 1.sw,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
                                    child: Text(
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      '${question}',
                                      style: GoogleFonts.lora(
                                        fontSize: 16.sp,
                                        color: dataProvider.quColor,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(top: 15.h),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: option.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            correctIndex != index + 1
                                                ? Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 2.sp),
                                                    child: Image.asset(
                                                      dataProvider.optionImage,
                                                      height: 65.sp,
                                                      width: 1.sw,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 2.sp),
                                                    child: Image.asset(
                                                      dataProvider.correctOptionImage,
                                                      height: 65.sp,
                                                      width: 1.sw,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 50.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${ABCD[index]}.',
                                                    style: GoogleFonts.ptSerif(
                                                      fontSize: isIpad
                                                          ? 22.sp
                                                          : isSmall
                                                              ? 25.sp
                                                              : 18.sp,
                                                      color: correctIndex != index + 1 ? dataProvider.textColor : Colors.white,
                                                      fontWeight: FontWeight.w800,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: isIpad ? 50.w : 40.w),
                                                      child: Text(
                                                        textAlign: TextAlign.start,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        '${option[index]}',
                                                        style: GoogleFonts.ptSerif(
                                                          fontSize: isIpad
                                                              ? 18.sp
                                                              : isSmall
                                                                  ? 16.sp
                                                                  : 14.sp,
                                                          color: correctIndex != index + 1 ? dataProvider.textColor : Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              wrongDialog == true
                  ? Container(
                      color: Colors.transparent,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.sp),
                            child: Container(
                              height: option1 == 2 ? 270.sp : 400.sp,
                              width: 1.sw,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(dataProvider.backgroundImage),
                                  fit: BoxFit.fill,
                                ),
                                border: Border.all(width: 2.w, color: Colors.white),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 22.w),
                                        Text(
                                          'Question',
                                          style: GoogleFonts.lora(
                                            fontSize: 22.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              wrongDialog = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 30.sp,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1.h,
                                    width: 1.sw,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
                                    child: Text(
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      '${question}',
                                      style: GoogleFonts.lora(
                                        fontSize: 16.sp,
                                        color: dataProvider.quColor,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(top: 15.h),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: option.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            correctIndex != index + 1
                                                ? Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 2.sp),
                                                    child: Image.asset(
                                                      dataProvider.optionImage,
                                                      height: 65.sp,
                                                      width: 1.sw,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 2.sp),
                                                    child: Image.asset(
                                                      dataProvider.correctOptionImage,
                                                      height: 65.sp,
                                                      width: 1.sw,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 50.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${ABCD[index]}.',
                                                    style: GoogleFonts.ptSerif(
                                                      fontSize: isIpad
                                                          ? 22.sp
                                                          : isSmall
                                                              ? 25.sp
                                                              : 18.sp,
                                                      color: correctIndex != index + 1 ? dataProvider.textColor : Colors.white,
                                                      fontWeight: FontWeight.w800,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: isIpad ? 50.w : 40.w),
                                                      child: Text(
                                                        textAlign: TextAlign.start,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        '${option[index]}',
                                                        style: GoogleFonts.ptSerif(
                                                          fontSize: isIpad
                                                              ? 18.sp
                                                              : isSmall
                                                                  ? 16.sp
                                                                  : 14.sp,
                                                          color: correctIndex != index + 1 ? dataProvider.textColor : Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
