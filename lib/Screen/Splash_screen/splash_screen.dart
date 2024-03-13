import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class splash_screen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    Future.delayed(Duration(milliseconds: 50)).then((value) {
      dataProvider.isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    dataProvider.backgroundImage = storage.read("backgroundImage") ?? dataProvider.backgroundImage;
    return Scaffold(
      body: dataProvider.isLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black87,
            )
          : Stack(
              alignment: Alignment.bottomCenter,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isIpad ? 50.sp : 30.sp),
                        child: Image.asset(
                          height: isIpad
                              ? 230.sp
                              : isSmall
                                  ? 280.sp
                                  : 300.sp,
                          width: 1.sw,
                          "assets/images/bible_book_image.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                Lottie.asset(
                  height: isIpad
                      ? 120.sp
                      : isSmall
                          ? 160.sp
                          : 180.sp,
                  alignment: Alignment.bottomCenter,
                  'assets/Lottie/Animation.json',
                ),
              ],
            ),
    );
  }
}
