import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/models/chat_messages.dart';

final chatsHandler = Get.put(ChatsController());

class ChatsController extends GetxController {
  // array holding the vehicle ownwer chats
  List<ChatMessages> vehicleChats = [];

// To get a stream of chat messages from the Firestore database while users chat with each other:
  Stream<QuerySnapshot> getChatMessage(int limit) {
    return FirebaseFirestore.instance
        .collection("messages")
        // .doc(groupChatId)
        // .collection(groupChatId)
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }

// To send messages to other users with the help of the Firestore database and save those messages inside it:
  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("messages").doc(groupChatId);
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
  getVehicleOwnerMessage() async {
    await FirebaseFirestore.instance
        .collection("messages")
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        if (vehicleChats.isEmpty) {
          vehicleChats.add(ChatMessages(
              idFrom: doc["idFrom"],
              idTo: doc["idTo"],
              timestamp: doc["timestamp"],
              content: doc["content"],
              type: doc["type"]));
              update();
        } else {
          return;
        }
      }
    });
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
