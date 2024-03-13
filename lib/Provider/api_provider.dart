import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class Api extends ChangeNotifier {
  // Map mainData = {};
  String quizJson = "";
  Map bibleList = {};
  String spinJson = "";
  Map spinList = {};
  int currency = 0;
  bool settingDialog = false;
  bool musicOn = true;
  AudioPlayer audioPlayerBackground = AudioPlayer();
  String audioBackground = 'assets/Sound/quiz_game_music.mp3';
  bool soundOn = true;
  AudioPlayer audioPlayerOnTap = AudioPlayer();
  String audioOnTap = 'assets/Sound/tap_sound.wav';
  AudioPlayer audioPlayerLifeLine = AudioPlayer();
  String audioLifeLine = 'assets/Sound/lifeline_use.wav';
  AudioPlayer audioPlayerCorrect = AudioPlayer();
  String audioCorrect = 'assets/Sound/correct_answer.wav';
  AudioPlayer audioPlayerWrong = AudioPlayer();
  String audioWrong = 'assets/Sound/wrong_answer.wav';
  late String url;
  List tempList = [];
  bool passLevel = false;
  int levelIndex = 0;
  int chapterIndex = 0;
  var tempData;
  int difference = 0;
  int coinDaily = 0;
  List wrongAnswersDetailsList = [];
  List correctAnswersDetailsList = [];
  bool themeChangeDialog = false;
  bool isLoading = true;
  String backgroundImage = "assets/images/quiz_bg_image.jpeg";
  String optionImage = "assets/images/theme1_option_image.png";
  String correctOptionImage = "assets/images/theme1_option_green.png";
  String wrongOptionImage = "assets/images/theme1_option_red.png";
  String questionImage = "assets/images/theme1_question_image.jpeg";
  String lifeLineImage = "assets/images/lifeline_image.png";
  String spinBoxImage = "assets/images/black_theme/theme3_spinBox.png";
  Color textColor = Colors.black;
  Color currencyTextColor = Colors.brown.shade700;
  Color lifeLineBoxColor = Colors.brown.shade100;
  Color currencyBoxColor = HexColor('CFB595');
  Color timeBoxColor = Colors.brown.shade800;
  Color questionTextColor = Colors.black;
  Color iconColor = Colors.black;
  Color second = Colors.black;
  Color borderColor = Colors.brown.shade700;
  Color settingColor = HexColor('6f473e');
  Color settingBoxColor = HexColor('8c5d50');
  Color quColor = Colors.white;
  Color seColor = HexColor('7a4231');
  Color noSeColor = HexColor('975942');
  String questionTrue = 'Correct';
  List collectList = [];

  // Future<void> getData() async {
  //   var url = Uri.parse("https://coinspinmaster.com/viral/iosapp/jenis/bible_quiz/main.json");
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print("response ====>>${response.body}");
  //     mainData = jsonDecode(response.body);
  //     notifyListeners();
  //   }
  //   notifyListeners();
  //   // print('mainData ==========>>>>>>${mainData}');
  // }

  Future<void> multiQuiz(var Url) async {
    var url = Uri.parse(Url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      bibleList = jsonDecode(response.body);
      notifyListeners();
    }
    notifyListeners();
    // print('bibleList ==========>>>>>>${bibleList}');
  }

  Future<void> spinData(var Url) async {
    var url = Uri.parse(Url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      spinList = jsonDecode(response.body);
      notifyListeners();
    }
    notifyListeners();
    // print('spinList ==========>>>>>>${spinList['data']}');
  }

  Future<void> launchurl() async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch ${Uri.parse(url)}');
    }
  }

  Future<void> initAudioPlayer() async {
    try {
      await audioPlayerBackground.setAsset(audioBackground);
      audioPlayerBackground.setLoopMode(LoopMode.one);
      audioPlayerBackground.play();
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  Future<void> initOnTap() async {
    await audioPlayerOnTap.setAsset(audioOnTap);
    await audioPlayerOnTap.play();
  }

  Future<void> initLifeLine() async {
    await audioPlayerLifeLine.setAsset(audioLifeLine);
    await audioPlayerLifeLine.play();
  }

  Future<void> initCorrect() async {
    await audioPlayerCorrect.setAsset(audioCorrect);
    await audioPlayerCorrect.play();
  }

  Future<void> initWrong() async {
    await audioPlayerWrong.setAsset(audioWrong);
    await audioPlayerWrong.play();
  }
}
