import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/controllers/chats_controller.dart';

class VehicleOwnerChats extends StatefulWidget {
  const VehicleOwnerChats({Key? key}) : super(key: key);

  @override
  State<VehicleOwnerChats> createState() => _VehicleOwnerChatsState();
}

class _VehicleOwnerChatsState extends State<VehicleOwnerChats> {
  @override
  void initState() {
    super.initState();
    // vehicleOwnerChatController.getFirestoreChats();
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
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsHandler.getVehicleOwnerMessage(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'Something went wrong',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Text(
              "Loading",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              print(data);
              return  Card(
                elevation: 200,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                      onTap: (){},      
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
