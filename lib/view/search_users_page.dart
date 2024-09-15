import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatme/controller/chat_controller.dart';
import 'package:chatme/view/chat_page.dart';

class SearchUsersPage extends StatelessWidget {
  SearchUsersPage({super.key});

  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search_users'.tr),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search_users_hint'.tr,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                chatController.searchUsers(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: chatController.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = chatController.searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(user.name![0].toUpperCase()),
                      ),
                      title: Text(user.name ?? ''),
                      subtitle: Text(user.email ?? ''),
                      onTap: () {
                        Get.to(() => ChatPage(receiver: user));
                      },
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
