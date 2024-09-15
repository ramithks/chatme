import 'package:get/get.dart';
import 'package:chatme/view/home.dart';
import 'package:chatme/view/login.dart';
import 'package:chatme/view/signup.dart';
import 'package:chatme/view/chat_page.dart';
import 'package:chatme/view/map_page.dart';
import 'package:chatme/model/user.dart';

class Routes {
  // ignore_for_file: constant_identifier_names
  static const LOGIN = '/';
  static const SIGNUP = '/signup';
  static const HOME = '/home';
  static const CHAT = '/chat';
  static const MAP = '/map';

  static final routes = [
    GetPage(
      name: LOGIN,
      page: () => Login(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: SIGNUP,
      page: () => const SignUp(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: HOME,
      page: () => Home(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: CHAT,
      page: () => ChatPage(receiver: Get.arguments as User),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: MAP,
      page: () => const MapPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
