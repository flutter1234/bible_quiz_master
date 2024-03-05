import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/Screen/Home_screen/home_screen.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class splash_screen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  bool isLoading = true;
  String backgroundImage = "";

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    context.read<Api>().getData().then((value) {
      backgroundImage = storage.read("backgroundImage") ?? dataProvider.backgroundImage;
      dataProvider.optionImage = storage.read("optionImage") ?? dataProvider.optionImage;
      dataProvider.correctOptionImage = storage.read("correctOptionImage") ?? dataProvider.correctOptionImage;
      dataProvider.wrongOptionImage = storage.read("wrongOptionImage") ?? dataProvider.wrongOptionImage;
      dataProvider.questionImage = storage.read("questionImage") ?? dataProvider.questionImage;
      dataProvider.lifeLineImage = storage.read("lifeLineImage") ?? dataProvider.lifeLineImage;
      String? storedTextColor = storage.read("textColor");
      String? storedCurrencyColor = storage.read("currencyTextColor");
      String? storedLifeLineColor = storage.read("lifeLineBoxColor");
      String? storedBoxColor = storage.read("currencyBoxColor");
      String? storedTimeBoxColor = storage.read("timeBoxColor");
      String? storedQuestionText = storage.read("questionTextColor");
      String? storedIconColor = storage.read("iconColor");
      String? storedSecondColor = storage.read("second");
      if (storedTextColor != null &&
          storedCurrencyColor != null &&
          storedLifeLineColor != null &&
          storedBoxColor != null &&
          storedTimeBoxColor != null &&
          storedQuestionText != null &&
          storedIconColor != null &&
          storedSecondColor != null) {
        dataProvider.textColor = Color(int.parse(storedTextColor, radix: 16));
        dataProvider.currencyTextColor = Color(int.parse(storedCurrencyColor, radix: 16));
        dataProvider.lifeLineBoxColor = Color(int.parse(storedLifeLineColor, radix: 16));
        dataProvider.currencyBoxColor = Color(int.parse(storedBoxColor, radix: 16));
        dataProvider.timeBoxColor = Color(int.parse(storedTimeBoxColor, radix: 16));
        dataProvider.questionTextColor = Color(int.parse(storedQuestionText, radix: 16));
        dataProvider.iconColor = Color(int.parse(storedIconColor, radix: 16));
        dataProvider.second = Color(int.parse(storedSecondColor, radix: 16));
      } else {
        dataProvider.textColor = Colors.black;
        dataProvider.currencyTextColor = Colors.brown.shade700;
        dataProvider.lifeLineBoxColor = Colors.brown.shade100;
        dataProvider.currencyBoxColor = HexColor('CFB595');
        dataProvider.timeBoxColor = Colors.brown.shade800;
        dataProvider.questionTextColor = Colors.black;
        dataProvider.iconColor = Colors.black;
        dataProvider.second = Colors.black;
      }
      setState(() {
        isLoading = false;
      });
      dataProvider.backgroundImage = backgroundImage;
      context.read<Api>().multiQuiz().then((value) {
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
      body: isLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black87,
            )
          : Container(
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
                      height: isIpad ? 400.sp : 450.sp,
                      width: 1.sw,
                      "assets/images/bible_book_image.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: isIpad ? 50.h : 150.h),
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
