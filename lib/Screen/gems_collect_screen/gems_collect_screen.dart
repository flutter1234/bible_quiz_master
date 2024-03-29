import 'dart:ui';
import 'package:bible_quiz_master/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_master/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_master/AdPlugin/Ads/Native/NativeRN.dart';
import 'package:bible_quiz_master/AdPlugin/MainJson/MainJson.dart';
import 'package:bible_quiz_master/AdPlugin/Utils/Extensions.dart';
import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class gems_collect_screen extends StatefulWidget {
  static const routeName = '/gems_collect_screen';

  const gems_collect_screen({super.key});

  @override
  State<gems_collect_screen> createState() => _gems_collect_screenState();
}

class _gems_collect_screenState extends State<gems_collect_screen> {
  bool isLoading = true;
  List showDate = [];
  List showData = [];
  bool claimDialog = false;
  Map dateDetails = {};

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    context.read<Api>().spinData(context.read<MainJson>().data!['assets']['spinJson']).then((value) {
      for (var element in dataProvider.spinList['data']) {
        showDate.add(element['spinDate']);
      }
      showDate = showDate.toSet().toList();
      showData = List.filled(showDate.length, false);
      dataProvider.collectList = storage.read("collectList") ?? [];
      isLoading = false;
    });

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
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.white,
                    size: isIpad ? 40.sp : 50.sp,
                  ),
                )
              : Stack(
                  children: [
                    Padding(
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
                              itemCount: showDate.length,
                              padding: EdgeInsets.only(top: 15.h),
                              itemBuilder: (context, index) {
                                List tempData = [];
                                for (var element in dataProvider.spinList['data']) {
                                  if (showDate[index] == element['spinDate']) {
                                    tempData.add(element);
                                  }
                                }
                                return Column(
                                  children: [
                                    index == 2 ? NativeRN(parentContext: context) : SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Container(
                                        height: isIpad ? 55.sp : 60.sp,
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(dataProvider.optionImage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: ExpansionTile(
                                          shape: CircleBorder(),
                                          onExpansionChanged: (value) {
                                            if (dataProvider.soundOn == true) {
                                              dataProvider.initOnTap();
                                            }
                                            showData[index] = value;
                                            setState(() {});
                                          },
                                          tilePadding: EdgeInsets.only(left: 120.w, top: isIpad ? 15.h : 5.h, right: 5.w),
                                          title: Text(
                                            '${showDate[index]}',
                                            style: GoogleFonts.abyssinicaSil(
                                              fontSize: isIpad ? 20.sp : 22.sp,
                                              color: dataProvider.textColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          trailing: Padding(
                                            padding: EdgeInsets.only(right: 40.w),
                                            child: Icon(
                                              showData[index] == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                              size: 25.sp,
                                              color: dataProvider.textColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    showData[index] == true
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: tempData.length,
                                            padding: EdgeInsets.all(0),
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index2) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    AdsRN().showFullScreen(
                                                      context: context,
                                                      onComplete: () {
                                                        claimDialog = true;
                                                        dateDetails = tempData[index2];
                                                        setState(() {});
                                                      },
                                                    );
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 50.sp,
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
                                                              if (int.parse(tempData[index2]['codeUrl']) <= 10) ...{
                                                                Center(
                                                                  child: Image(
                                                                    image: AssetImage('assets/images/single_diamond.png'),
                                                                    height: 30.sp,
                                                                    width: 40.sp,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              } else if (int.parse(tempData[index2]['codeUrl']) <= 25) ...{
                                                                Center(
                                                                  child: Image(
                                                                    image: AssetImage('assets/images/multi_diamond.png'),
                                                                    height: 30.sp,
                                                                    width: 40.w,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              } else ...{
                                                                Center(
                                                                  child: Image(
                                                                    image: AssetImage('assets/images/chest_diamond.png'),
                                                                    height: 35.sp,
                                                                    width: 40.w,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              },
                                                              SizedBox(
                                                                width: 20.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${tempData[index2]['subject']}',
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
                                                      dataProvider.collectList.contains(tempData[index2]['id'])
                                                          ? Container(
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(5.r),
                                                                child: BackdropFilter(
                                                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                                  child: Container(
                                                                    height: 50.sp,
                                                                    width: 390.w,
                                                                    color: Colors.black.withOpacity(0),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
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
                    claimDialog == true
                        ? Stack(
                            children: [
                              Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: 1.sw,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(dataProvider.spinBoxImage),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 30.sp),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                      '${dateDetails['subject']}',
                                                      style: GoogleFonts.adamina(
                                                        fontSize: 20.sp,
                                                        color: dataProvider.second,
                                                        fontWeight: FontWeight.w700,
                                                        fontStyle: FontStyle.normal,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                      '${dateDetails['spinDate']}',
                                                      style: GoogleFonts.adamina(
                                                        fontSize: 18.sp,
                                                        color: dataProvider.second,
                                                        fontWeight: FontWeight.w700,
                                                        fontStyle: FontStyle.normal,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 25.sp),
                                                      child: Text(
                                                        '${dateDetails['detail']}',
                                                        style: GoogleFonts.adamina(
                                                          fontSize: 14.sp,
                                                          color: dataProvider.second,
                                                          fontWeight: FontWeight.w500,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              // Share.share('${dateDetails['detail']}');
                                                              if (dataProvider.soundOn == true) {
                                                                dataProvider.initOnTap();
                                                              }
                                                              claimDialog = false;
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              height: 50.sp,
                                                              width: 105.w,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage('assets/images/collect_spin_image.png'),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                // border: Border.all(width: 1.w, color: Colors.white),
                                                                // color: Colors.green.shade800,
                                                                borderRadius: BorderRadius.circular(8.r),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Close',
                                                                  style: GoogleFonts.lora(
                                                                    fontSize: isSmall ? 16.sp : 20.sp,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (dataProvider.collectList.contains(dateDetails['id'])) ...{
                                                            Container(
                                                              height: 50.sp,
                                                              width: 105.w,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage('assets/images/collect_spin_image.png'),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                // border: Border.all(width: 1.w, color: Colors.white),
                                                                // color: Colors.green.shade800,
                                                                borderRadius: BorderRadius.circular(8.r),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Collected',
                                                                  style: GoogleFonts.lora(
                                                                    fontSize: isSmall ? 16.sp : 20.sp,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          } else ...{
                                                            GestureDetector(
                                                              onTap: () async {
                                                                "gemsCollect".performScreenAction(
                                                                  context: context,
                                                                  onComplete: () async {
                                                                    dataProvider.currency = dataProvider.currency + int.parse(dateDetails['codeUrl']);
                                                                    await storage.write("currency", dataProvider.currency);
                                                                    dataProvider.collectList.add(dateDetails['id']);
                                                                    storage.write("collectList", dataProvider.collectList);
                                                                    print("collectList ====>>${dataProvider.collectList}");
                                                                    claimDialog = false;
                                                                    setState(() {});
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 50.sp,
                                                                width: 105.w,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: AssetImage('assets/images/collect_spin_image.png'),
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                  // border: Border.all(width: 1.w, color: Colors.white),
                                                                  // color: Colors.green.shade800,
                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Collect',
                                                                    style: GoogleFonts.lora(
                                                                      fontSize: isSmall ? 16.sp : 20.sp,
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          }
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: isIpad
                                                  ? -65.h
                                                  : isSmall
                                                      ? -50.h
                                                      : -30.h,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  if (int.parse(dateDetails['codeUrl']) <= 10) ...{
                                                    Image(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage('assets/images/single_diamond.png'),
                                                      height: 80.sp,
                                                      width: 100.w,
                                                    ),
                                                  } else if (int.parse(dateDetails['codeUrl']) <= 25) ...{
                                                    Image(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage('assets/images/multi_diamond.png'),
                                                      height: 80.sp,
                                                      width: 120.w,
                                                    ),
                                                  } else ...{
                                                    Image(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage('assets/images/chest_diamond.png'),
                                                      height: 80.sp,
                                                      width: 100.w,
                                                    ),
                                                  },
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 28.w,
                              //   top: isIpad
                              //       ? 150.h
                              //       : isSmall
                              //           ? 195.h
                              //           : 260.h,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       if (dataProvider.soundOn == true) {
                              //         dataProvider.initOnTap();
                              //       }
                              //       claimDialog = false;
                              //       setState(() {});
                              //     },
                              //     child: Container(
                              //       height: isIpad ? 25.sp : 30.sp,
                              //       width: isIpad ? 25.sp : 30.sp,
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border.all(width: 0.5.w, color: Colors.white),
                              //         color: dataProvider.settingBoxColor,
                              //       ),
                              //       child: Icon(
                              //         Icons.close,
                              //         color: Colors.yellow,
                              //         size: isIpad ? 20.sp : 25.sp,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }
}
