import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/controllers/chats_controller.dart';
import 'package:vehicle_match/screen/passenger/passenger_chat.dart';

class VehicleOwnerChats extends StatefulWidget {
  const VehicleOwnerChats({Key? key}) : super(key: key);

  @override
  State<VehicleOwnerChats> createState() => _VehicleOwnerChatsState();
}

class _VehicleOwnerChatsState extends State<VehicleOwnerChats> {
  @override
  void initState() {
    super.initState();
    chatsHandler.getVehicleOwnerMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Recent Chats"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: GetBuilder<ChatsController>(
          init: ChatsController(),
          builder: (ownerChats) {
            return ListView.builder(
                itemCount: ownerChats.vehicleChats.length,
                itemBuilder: (context, index) {
                  if (ownerChats.vehicleChats[index].idTo ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    return Card(
                      elevation: 200,
                      child: ListTile(
                        leading: const CircleAvatar(),
                        title: Text(ownerChats.vehicleChats[index].content),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: ((context) => ChatPage(
                                        peerId:
                                            ownerChats.vehicleChats[index].idTo,
                                        peerEmail:
                                            ownerChats.vehicleChats[index].idTo,
                                      ))),
                              (route) => true);
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("No new messages for you"),
                    );
                  }
                });
          }),
    );
  }
}
