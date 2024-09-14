import 'package:firebase_database/firebase_database.dart';
import 'package:chatme/model/user.dart';
import 'package:chatme/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatme/service/sqlite_message_service.dart';

class ChatService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SQLiteMessageService _sqliteMessageService = SQLiteMessageService();

  Future<List<User>> searchUsers(String query) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .get();

    return querySnapshot.docs
        .map((doc) => User.fromDocumentSnapshot(documentSnapshot: doc))
        .toList();
  }

  Future<void> sendMessage(Message message) async {
    final chatRoomId = getChatRoomId(message.senderId, message.receiverId);
    await _database.ref('chats/$chatRoomId').push().set(message.toMap());
    await updateRecentChat(message.senderId, message.receiverId,
        message.content, message.timestamp);
    await updateRecentChat(message.receiverId, message.senderId,
        message.content, message.timestamp);

    // Save message to local storage
    await _sqliteMessageService.insertMessage(message);
  }

  Future<void> updateRecentChat(String userId, String otherUserId,
      String lastMessage, DateTime timestamp) async {
    await _database.ref('recentChats/$userId/$otherUserId').set({
      'lastMessage': lastMessage,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });
  }

  Future<List<User>> getRecentChats(String userId) async {
    final snapshot = await _database.ref('recentChats/$userId').get();
    final Map<dynamic, dynamic>? data = snapshot.value as Map?;
    List<User> recentChats = [];

    if (data != null) {
      for (var entry in data.entries) {
        final userSnapshot =
            await _firestore.collection('users').doc(entry.key).get();
        if (userSnapshot.exists) {
          final user =
              User.fromDocumentSnapshot(documentSnapshot: userSnapshot);
          user.lastMessage = entry.value['lastMessage'];
          recentChats.add(user);
        }
      }
    }

    recentChats.sort((a, b) => b.lastMessage!.compareTo(a.lastMessage!));
    return recentChats;
  }

  Stream<List<Message>> getMessages(String userId, String otherUserId) {
    final chatRoomId = getChatRoomId(userId, otherUserId);
    return _database.ref('chats/$chatRoomId').onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data != null) {
        return data.entries
            .map((e) => Message.fromMap(Map<String, dynamic>.from(e.value)))
            .toList();
      }
      return <Message>[];
    });
  }

  String getChatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) > 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }
}
