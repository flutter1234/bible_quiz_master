import 'package:bible_quiz_master/Screen/Home_screen/home_screen.dart';
import 'package:bible_quiz_master/Screen/Levels_screen/levels_screen.dart';
import 'package:bible_quiz_master/Screen/Quiz_screen/quiz_screen.dart';
import 'package:bible_quiz_master/Screen/Splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Router {
  static MaterialPageRoute onRouteGenrator(settings) {
    switch (settings.name) {
      case splash_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const splash_screen(),
        );
      case home_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const home_screen(),
        );
      case quiz_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const quiz_screen(),
        );
      case levels_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const levels_screen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Material(
            child: Center(
              child: Text("404 page not founded"),
            ),
          ),
        );
    }
  }
}
