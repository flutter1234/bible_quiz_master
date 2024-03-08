import 'package:bible_quiz_master/Provider/api_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 0),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(5.sp),
                child: Container(
                  height: 50.sp,
                  width: 1.sw,
                  color: dataProvider.currencyBoxColor,
                  child: Center(
                    child: Text(
                      '${dataProvider.spinList['data'][index]['subject']}',
                      style: GoogleFonts.abyssinicaSil(
                        fontSize: isIpad ? 30.sp : 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
