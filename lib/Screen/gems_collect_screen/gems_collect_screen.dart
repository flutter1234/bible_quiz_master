import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/gems_collect_screen/gems_details_screen.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class gems_collect_screen extends StatefulWidget {
  static const routeName = '/gems_collect_screen';

  const gems_collect_screen({super.key});

  @override
  State<gems_collect_screen> createState() => _gems_collect_screenState();
}

class _gems_collect_screenState extends State<gems_collect_screen> {
  bool isLoading = true;
  bool showDate = false;
  int dateIndex = 0;

  @override
  void initState() {
    context.read<Api>().spinData().then((value) {
      isLoading = false;
    });
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
        child: isLoading
            ? Center(
                child: Container(
                  height: 40.sp,
                  width: 40.sp,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: isIpad
                      ? 25.h
                      : isSmall
                          ? 30.h
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
                            'Reward',
                            style: GoogleFonts.lora(
                              fontSize: 22.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(width: 20.w)
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataProvider.spinList['data'].length,
                        padding: EdgeInsets.only(top: 15.h),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              index == 0 || dataProvider.spinList['data'][index]['spinDate'] != dataProvider.spinList['data'][index - 1]['spinDate']
                                  ? Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Container(
                                        height: 60.sp,
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(dataProvider.optionImage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: ExpansionTile(
                                          onExpansionChanged: (value) {
                                            showDate = value;
                                            dateIndex = index;
                                            setState(() {});
                                            print("showDate ====${showDate}");
                                          },
                                          tilePadding: EdgeInsets.only(left: 120.w, top: 5.h, right: 5.w),
                                          title: Text(
                                            '${dataProvider.spinList['data'][index]['spinDate']}',
                                            style: GoogleFonts.abyssinicaSil(
                                              fontSize: isIpad ? 30.sp : 22.sp,
                                              color: dataProvider.textColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          trailing: Padding(
                                            padding: EdgeInsets.only(right: 40.w),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 25.sp,
                                              color: dataProvider.textColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              showDate == true && dateIndex == index
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            gems_details_screen.routeName,
                                            arguments: {
                                              "gemsDetail": dataProvider.spinList['data'][index],
                                              "Date": dataProvider.spinList['data'][index]['spinDate'],
                                            },
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 55.sp,
                                          width: 390.w,
                                          decoration: BoxDecoration(
                                            color: dataProvider.currencyBoxColor,
                                            border: Border.all(width: 2.w, color: dataProvider.borderColor),
                                            borderRadius: BorderRadius.circular(5.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Image(
                                                    image: AssetImage('assets/images/single_diamond.png'),
                                                    height: 40.sp,
                                                    width: 40.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${dataProvider.spinList['data'][index]['subject']}',
                                                    style: GoogleFonts.adamina(
                                                      fontSize: 18.sp,
                                                      color: dataProvider.second,
                                                      fontWeight: FontWeight.w700,
                                                      fontStyle: FontStyle.normal,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  color: dataProvider.second,
                                                  size: 25.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
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
