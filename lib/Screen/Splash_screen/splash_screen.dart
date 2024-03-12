import 'package:bible_quiz_master/Provider/api_provider.dart';
import 'package:bible_quiz_master/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class splash_screen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  Future<void> fetchData() async {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.backgroundImage = storage.read("backgroundImage") ?? dataProvider.backgroundImage;
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
    String? storedBorderColor = storage.read("borderColor");
    String? storedSettingColor = storage.read("settingColor");
    String? storedSettingBoxColor = storage.read("settingBoxColor");
    String? storedQuColor = storage.read("quColor");
    String? storedSeColor = storage.read("seColor");
    String? storedNoseColor = storage.read("noSeColor");
    if (storedTextColor != null &&
        storedCurrencyColor != null &&
        storedLifeLineColor != null &&
        storedBoxColor != null &&
        storedTimeBoxColor != null &&
        storedQuestionText != null &&
        storedIconColor != null &&
        storedSecondColor != null &&
        storedBorderColor != null &&
        storedSettingColor != null &&
        storedSettingBoxColor != null &&
        storedQuColor != null &&
        storedSeColor != null &&
        storedNoseColor != null) {
      dataProvider.textColor = Color(int.parse(storedTextColor, radix: 16));
      dataProvider.currencyTextColor = Color(int.parse(storedCurrencyColor, radix: 16));
      dataProvider.lifeLineBoxColor = Color(int.parse(storedLifeLineColor, radix: 16));
      dataProvider.currencyBoxColor = Color(int.parse(storedBoxColor, radix: 16));
      dataProvider.timeBoxColor = Color(int.parse(storedTimeBoxColor, radix: 16));
      dataProvider.questionTextColor = Color(int.parse(storedQuestionText, radix: 16));
      dataProvider.iconColor = Color(int.parse(storedIconColor, radix: 16));
      dataProvider.second = Color(int.parse(storedSecondColor, radix: 16));
      dataProvider.borderColor = Color(int.parse(storedBorderColor, radix: 16));
      dataProvider.settingColor = Color(int.parse(storedSettingColor, radix: 16));
      dataProvider.settingBoxColor = Color(int.parse(storedSettingBoxColor, radix: 16));
      dataProvider.quColor = Color(int.parse(storedQuColor, radix: 16));
      dataProvider.seColor = Color(int.parse(storedSeColor, radix: 16));
      dataProvider.noSeColor = Color(int.parse(storedNoseColor, radix: 16));
    } else {
      dataProvider.textColor = Colors.black;
      dataProvider.currencyTextColor = Colors.brown.shade700;
      dataProvider.lifeLineBoxColor = Colors.brown.shade100;
      dataProvider.currencyBoxColor = HexColor('CFB595');
      dataProvider.timeBoxColor = Colors.brown.shade800;
      dataProvider.questionTextColor = Colors.black;
      dataProvider.iconColor = Colors.black;
      dataProvider.second = Colors.black;
      dataProvider.borderColor = Colors.brown.shade700;
      dataProvider.settingColor = HexColor('6f473e');
      dataProvider.settingBoxColor = HexColor('8c5d50');
      dataProvider.quColor = Colors.white;
      dataProvider.seColor = HexColor('7a4231');
      dataProvider.noSeColor = HexColor('975942');
    }
  }

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    fetchData().then((value) {
      dataProvider.isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return Scaffold(
      body: dataProvider.isLoading
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
    );
  }
}
