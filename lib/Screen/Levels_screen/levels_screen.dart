import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/Quiz_screen/quiz_screen.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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
          padding: EdgeInsets.only(top: 40.h),
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
                        size: 25.sp,
                        color: HexColor('CFB595'),
                      ),
                    ),
                    Spacer(),
                    Spacer(),
                    Text(
                      'Levels',
                      style: GoogleFonts.breeSerif(
                        fontSize: 25.sp,
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
                          height: 26.sp,
                          width: 90.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.w,
                              color: Colors.brown.shade900,
                            ),
                            color: HexColor('CFB595'),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: Text(
                              '${dataProvider.currency}',
                              style: GoogleFonts.breeSerif(
                                fontSize: 18.sp,
                                color: Colors.brown.shade700,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -12.w,
                          child: Image(
                            image: AssetImage('assets/images/diamond_image.png'),
                            height: 28.sp,
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
                  itemCount: dataProvider.bibleList['data'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 2.sp),
                      child: GestureDetector(
                        onTap: () {
                          levelShowList[index] = !levelShowList[index];
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 55.sp,
                              width: 1.sw,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/images/theme1_option_image.png'),
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
                                        fontSize: 20.sp,
                                        color: Colors.brown.shade700,
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
                                      fontSize: 20.sp,
                                      color: Colors.brown.shade700,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 40.w),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 25.sp,
                                      color: Colors.brown,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            levelShowList[index] == true
                                ? Container(
                                    height: 100.sp,
                                    child: ListView.builder(
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
                                                Navigator.pushNamed(context, quiz_screen.routeName);
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              height: 30.sp,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.r),
                                                border: Border.all(width: 0.5, color: Colors.brown.shade400),
                                                color: Colors.white70,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${dataProvider.bibleList['data'][index]['Chapter'][index2]['Levels']}',
                                                      style: GoogleFonts.breeSerif(
                                                        fontSize: 20.sp,
                                                        color: Colors.brown.shade700,
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                    Icon(
                                                      dataProvider.tempList[index][index2] == true
                                                          ? Icons.check
                                                          : (index == 0 && index2 == 0)
                                                              ? Icons.play_arrow
                                                              : (index2 > 0 && (dataProvider.tempList[index][index2 - 1] == true)) ||
                                                                      (index == 0 ? dataProvider.tempList[index][index2 - 1] == true : (dataProvider.tempList[index - 1][2] == true && index2 == 0))
                                                                  ? Icons.play_arrow
                                                                  : Icons.lock,
                                                      color: Colors.green,
                                                      size: 22.sp,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
