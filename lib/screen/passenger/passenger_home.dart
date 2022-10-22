import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_match/screen/passenger/search_page.dart';
import 'package:vehicle_match/widgets/list_button.dart';
import 'package:vehicle_match/select_user.dart';
import 'package:vehicle_match/widgets/rounded_input.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final Stream<QuerySnapshot> requestsStream =
      FirebaseFirestore.instance.collection('vehicleRequests').snapshots();
  FirebaseAuth signedin = FirebaseAuth.instance;
  FirebaseAuth signout = FirebaseAuth.instance;

  signingout() async {
    await signout.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          elevation: 0,
          title: const Text("Recent Vehicle Details"),
          actions: [
            PopupMenuButton(
                offset: const Offset(0, 40),
                onCanceled: () {},
                elevation: 40,
                icon: const Icon(Icons.menu),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Signed in as: ${signedin.currentUser!.email}",
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: ListButton(
                          label: 'Sign Out',
                          icon: Icons.outbond_outlined,
                          onTap: () {
                            signingout();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const WelcomeScreen())),
                                (route) => false);
                          },
                        ),
                      ),
                    ])
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 10,
              child: SizedBox(
                height: 150,
                child: RoundedInput(
                  label: "Search ",
                  hint: "Search by Destination",
                  icon: Icons.search,
                  readOnly: true,
                  ontap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SearchPage()),
                        (route) => true);
                  },
                ),
              ),
            ),
            Positioned(
              top: 150,
              child: SizedBox(
                height: 500,
                width: 500,
                child: StreamBuilder<QuerySnapshot>(
                  stream: requestsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Card(
                          elevation: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                              title: RichText(
                                  text: TextSpan(
                                      text:
                                          "Pickup Location: ${data['pickupLocation']} \n",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text:
                                            "Destination: ${data['destLocation']}")
                                  ])),
                              subtitle: RichText(
                                  text: TextSpan(
                                      text:
                                          "Departure Time: ${data['timeOfDeparture']} \n",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text:
                                            "Departure Date: ${data['dateOfDeparture']}")
                                  ])),
                              trailing: Chip(
                                  label: Text(
                                "Seats: ${data['seatsNumber']}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
