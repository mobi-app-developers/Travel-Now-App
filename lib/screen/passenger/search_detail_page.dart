import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/controllers/passenger_controller.dart';
import 'package:vehicle_match/models/vehicle_content.dart';
import 'package:vehicle_match/screen/passenger/passenger_chat.dart';
import 'package:vehicle_match/widgets/search_tile.dart';

class SearchDetail extends StatefulWidget {
  final List<VehicleContents> searchResult;
  const SearchDetail({Key? key, required this.searchResult}) : super(key: key);

  @override
  State<SearchDetail> createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[200],
        elevation: 0,
        title: const Text("Search Detail"),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.6,
          child: Card(
            elevation: 200,
            child: Column(
              children: [
                SearchTile(
                  label: "Destination : ",
                  value: widget.searchResult[0].destLocation,
                ),
                SearchTile(
                  label: "Pickup : ",
                  value: widget.searchResult[0].pickupLocation,
                ),
                SearchTile(
                  label: "Departure Time : ",
                  value: widget.searchResult[0].timeOfDeparture,
                ),
                SearchTile(
                  label: "Departure Date : ",
                  value: widget.searchResult[0].dateOfDeparture,
                ),
                SearchTile(
                  label: "Seats Number : ",
                  value: widget.searchResult[0].seatsNumber,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Wrap(
                  spacing: 50,
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: ((context) => ChatPage(
                                        peerId: widget
                                            .searchResult[0].vehicleUserId,
                                        peerEmail: widget
                                            .searchResult[0].vehicleUserEmail,
                                      ))),
                              (route) => true);
                        },
                        icon: const Icon(Icons.chat_sharp)),
                    GetBuilder<PassengerController>(
                        init: PassengerController(),
                        builder: (payments) {
                          return IconButton(
                              onPressed: () {
                                payments.makePayment(context);
                              },
                              icon: const Icon(Icons.monetization_on));
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
