import 'package:get/get.dart';
import 'package:chatme/model/user.dart';
import 'package:chatme/model/message.dart';
import 'package:chatme/service/chat_service.dart';
import 'package:chatme/service/sqlite_message_service.dart';
import 'package:chatme/controller/auth_controller.dart';

class ChatController extends GetxController {
  final ChatService chatService;
  final SQLiteMessageService sqliteMessageService;
  final AuthController authController;

  ChatController({
    required this.chatService,
    required this.sqliteMessageService,
    required this.authController,
  });

  final RxList<User> searchResults = <User>[].obs;
  final RxList<Message> messages = <Message>[].obs;
  final RxList<User> recentChats = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for changes in the auth state
    ever(authController.userRx, (user) {
      if (user != null) {
        fetchRecentChats();
      } else {
        recentChats.clear();
      }
    });
  }

  void fetchRecentChats() async {
    if (authController.user != null) {
      recentChats.value =
          await chatService.getRecentChats(authController.user!.uid);
    }
  }

  void searchUsers(String query) async {
    if (query.isNotEmpty) {
      searchResults.value = await chatService.searchUsers(query);
    } else {
      searchResults.clear();
    }
  }

  Future<void> sendMessage(String content, String receiverId) async {
    if (content.trim().isNotEmpty) {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: authController.user!.uid,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
      );
      await chatService.sendMessage(message);
      await sqliteMessageService.insertMessage(message);
      addNewMessage(message);
      fetchRecentChats();
    }
  }

  void listenToMessages(String otherUserId) {
    // Load messages from local storage first
    _loadLocalMessages(otherUserId);

    // Then listen for new messages from Firebase
    chatService
        .getMessages(authController.user!.uid, otherUserId)
        .listen((newMessages) async {
      for (var message in newMessages) {
        await sqliteMessageService.insertMessage(message);
        addNewMessage(message);
      }
    });
  }

  void _loadLocalMessages(String otherUserId) async {
    final localMessages = await sqliteMessageService.getMessages(
        authController.user!.uid, otherUserId);
    messages.value = localMessages;
  }

  void addNewMessage(Message message) {
    if (!messages.any((m) => m.id == message.id)) {
      messages.add(message);
      sortAndUpdateMessages();
    }
  }

  void sortAndUpdateMessages() {
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void clearMessages() {
    messages.clear();
  }
}
