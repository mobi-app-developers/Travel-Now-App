import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/models/chat_messages.dart';

final chatsHandler = Get.put(ChatsController());

class ChatsController extends GetxController {
// To get a stream of chat messages from the Firestore database while users chat with each other:
  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }

// To send messages to other users with the help of the Firestore database and save those messages inside it:
  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("messages")
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
      update();
    });
  }

  // chats functionality of vehicle Owner
  Stream<QuerySnapshot> getVehicleOwnerMessage() {
    return FirebaseFirestore.instance.collection("messages").snapshots();
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
