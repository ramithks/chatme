import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatme/controller/auth_controller.dart';
import 'package:chatme/controller/user_controller.dart';
import 'package:chatme/controller/chat_controller.dart';
import 'package:chatme/view/chat_page.dart';
import 'package:chatme/view/search_users_page.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Welcome ${userController.user.name}')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(() => SearchUsersPage());
            },
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
                subtitle: Text(chat.lastMessage ?? 'No messages yet'),
                onTap: () {
                  Get.to(() => ChatPage(receiver: chat));
                },
              );
            },
          )),
    );
  }
}
