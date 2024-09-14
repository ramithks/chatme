import 'package:get/get.dart';
import 'package:chatme/controller/auth_controller.dart';
import 'package:chatme/controller/user_controller.dart';
import 'package:chatme/controller/chat_controller.dart';
import 'package:chatme/service/auth_service.dart';
import 'package:chatme/service/user_service.dart';
import 'package:chatme/service/chat_service.dart';
import 'package:chatme/service/sqlite_message_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<AuthController>(
        () async => AuthController(authService: AuthService()),
        permanent: true);
    Get.put<UserController>(UserController(userService: UserService()),
        permanent: true);

    final sqliteMessageService = SQLiteMessageService();
    await sqliteMessageService.initDB();

    Get.put<ChatController>(
      ChatController(
        chatService: ChatService(),
        sqliteMessageService: sqliteMessageService,
        authController: Get.find<AuthController>(),
      ),
      permanent: true,
    );
  }
}
