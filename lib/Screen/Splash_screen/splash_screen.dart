import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/Home_screen/home_screen.dart';
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
    fetchData();
    super.initState();
  }

  fetchData() {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    context.read<Api>().getData().then((value) {
      context.read<Api>().multiQuiz().then((value) {
        dataProvider.themeChange = storage.read("themeChange") ?? false;
        print("themeChange ==== >>>>>>${dataProvider.themeChange}");
        Future.delayed(Duration(seconds: 1)).then((value) {
          Navigator.pushReplacementNamed(context, home_screen.routeName);
        });
      });
    });
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Image.asset(
                "assets/images/bible_book_image.png",
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 150.h),
              child: Lottie.asset(
                alignment: Alignment.bottomCenter,
                'assets/Lottie/Animation.json',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
