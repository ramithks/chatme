import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatme/controller/auth_controller.dart';
import 'package:chatme/controller/user_controller.dart';
import 'package:chatme/controller/chat_controller.dart';
import 'package:chatme/view/chat_page.dart';
import 'package:chatme/view/search_users_page.dart';
import 'package:chatme/view/map_page.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();

  void _changeLanguage(String languageCode) {
    Locale locale;
    switch (languageCode) {
      case 'en':
        locale = const Locale('en', 'US');
        break;
      case 'ar':
        locale = const Locale('ar', 'SA');
        break;
      default:
        locale = const Locale('en', 'US');
    }
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('${'welcome'.tr} ${userController.user.name}')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(() => SearchUsersPage());
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'en',
                child: Text('english'.tr),
              ),
              PopupMenuItem<String>(
                value: 'ar',
                child: Text('arabic'.tr),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              authController.signOut();
            },
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: chatController.recentChats.length,
            itemBuilder: (context, index) {
              final chat = chatController.recentChats[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(chat.name![0].toUpperCase()),
                ),
                title: Text(chat.name!),
                subtitle: Text(chat.lastMessage ?? 'no_messages'.tr),
                onTap: () {
                  Get.to(() => ChatPage(receiver: chat));
                },
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const MapPage());
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
