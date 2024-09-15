import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:get/get.dart';
import 'package:chatme/controller/user_controller.dart';
import 'package:chatme/model/user.dart';
import 'package:chatme/routes.dart';
import 'package:chatme/service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});

  final Rx<fauth.User?> _firebaseUser =
      Rx<fauth.User?>(fauth.FirebaseAuth.instance.currentUser);

  fauth.User? get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser.bindStream(authService.authStateChanges());
    super.onInit();
  }

  void clear() {
    _firebaseUser.value = null;
  }

  Future<void> createUser(String name, String email, String password,
      String country, String mobile) async {
    try {
      fauth.UserCredential authResult =
          await authService.createUser(email, password);

      if (authResult.user == null) {
        throw Exception('authResult.user == null');
      }

      _firebaseUser.value = authResult.user;

      User user = User(
        id: authResult.user!.uid,
        name: name,
        email: authResult.user!.email,
        country: country,
        mobile: mobile,
      );
      final userController = Get.find<UserController>();
      if (await userController.createNewUser(user)) {
        userController.user = user;
        Get.offAllNamed(Routes.HOME);
      } else {
        throw Exception('user was not created.');
      }
    } catch (e) {
      Get.snackbar(
        "Error creating Account",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      e.printError();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      fauth.UserCredential authResult =
          await authService.login(email, password);

      _firebaseUser.value = authResult.user;

      final userController = Get.find<UserController>();
      userController.user = await userController.getUser(authResult.user!.uid);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        "Error signing in",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      e.printError();
    }
  }

  Future<void> signOut() async {
    try {
      await authService.signOut();
      clear();
      Get.find<UserController>().clear();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      e.printError();
    }
  }
}
