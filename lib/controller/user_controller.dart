import 'package:get/get.dart';
import 'package:chatme/controller/auth_controller.dart';
import 'package:chatme/model/user.dart';
import 'package:chatme/service/user_service.dart';

class UserController extends GetxController {
  final UserService userService;

  UserController({required this.userService});

  final Rx<User> _user = User().obs;

  User get user => _user.value;

  set user(User value) => _user.value = value;

  final RxList<User> searchResults = <User>[].obs;

  @override
  void onInit() {
    final authController = Get.find<AuthController>();
    if (authController.user != null) {
      getUser(authController.user!.uid).then((value) => user = value);
    }
    super.onInit();
  }

  void clear() {
    _user.value = User();
  }

  Future<bool> createNewUser(User user) async {
    return await userService.createNewUser(user);
  }

  Future<User> getUser(String uid) async {
    return await userService.getUser(uid);
  }

  void searchUserByName(String name) async {
    searchResults.value = await userService.searchUserByName(name);
  }
}
