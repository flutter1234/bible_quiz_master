import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class gems_details_screen extends StatefulWidget {
  static const routeName = '/gems_details_screen';

  const gems_details_screen({super.key});

  @override
  State<gems_details_screen> createState() => _gems_details_screenState();
}

class _gems_details_screenState extends State<gems_details_screen> {
  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.currency = storage.read("currency") ?? 0;
    print("currency =============>>>${dataProvider.currency}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    final dataAll = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
                      'Details',
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
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(width: 2.w, color: Colors.white),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: dataAll['gemsDetail']['imageUrl'],
                      height: 120.h,
                      width: 150.w,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        size: 25.sp,
                        color: dataProvider.iconColor,
                      ),
                      placeholder: (context, url) => Container(
                        height: 25.sp,
                        width: 25.sp,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  '${dataAll['gemsDetail']['subject']}',
                  style: GoogleFonts.lora(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  '${dataAll['gemsDetail']['spinDate']}',
                  style: GoogleFonts.lora(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                child: Container(
                  height: 220.sp,
                  width: 390.w,
                  decoration: BoxDecoration(
                    color: dataProvider.second,
                    border: Border.all(width: 2.w, color: Colors.white),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Text(
                      textAlign: TextAlign.justify,
                      '${dataAll['gemsDetail']['detail']}',
                      style: GoogleFonts.abhayaLibre(
                        fontSize: 27.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  dataProvider.currency = dataProvider.currency + int.parse(dataAll['gemsDetail']['codeUrl']);
                  print("currency ===========>>>${dataProvider.currency}");
                  await storage.write("currency", dataProvider.currency);
                  setState(() {});
                },
                child: Container(
                  height: 45.sp,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Collect Now',
                      style: GoogleFonts.lora(
                        fontSize: 22.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h)
            ],
          ),
        ),
      ),
    );
  }
}
