import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/screen/passenger/search_detail_page.dart';

import 'package:vehicle_match/models/vehicle_content.dart';

final passengerContrl = Get.put(PassengerController());

class PassengerController extends GetxController {
  List<VehicleContents> searchResult = [];
  List<VehicleContents> vehiclesNow = [];
  final controller = TextEditingController();

  fetchVehicleContent() async {
    await FirebaseFirestore.instance
        .collection("vehicleRequests")
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        vehiclesNow.add(
          VehicleContents(
              dateOfDeparture: doc["dateOfDeparture"],
              destLocation: doc["destLocation"],
              pickupLocation: doc["pickupLocation"],
              seatsNumber: doc["seatsNumber"],
              timeOfDeparture: doc["timeOfDeparture"],
              vehicleUserEmail: doc["vehicleUserEmail"],
              vehicleUserId: doc["vehicleUserId"]),
        );
      }
    });
    update();
  }

//  search functionality

  Widget buildSearchList() {
    return ListView.builder(
      itemCount: vehiclesNow.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(0.0),
          child: ListTile(
            title: Text(vehiclesNow[index].destLocation),
          ),
        );
      },
    );
  }

  Widget buildSearchResults() {
    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (context, i) {
        return Card(
          margin: const EdgeInsets.all(0.0),
          child: ListTile(
            title: Text(searchResult[i].destLocation),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: ((context) => SearchDetail(
                            searchResult: [searchResult[i]],
                          ))),
                  (route) => true);
            },
          ),
        );
      },
    );
  }

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          title: TextField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: 'Search by Destination', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      update();
      return;
    }

    for (var searchDetail in vehiclesNow) {
      if (searchDetail.destLocation.contains(text)) {
        searchResult.add(searchDetail);
      }
    }

    update();
  }
}
