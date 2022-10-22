import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
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

  // payments

  makePayment(BuildContext context) async {
    final style = FlutterwaveStyle(
        appBarText: "Vehicle Match payments",
        buttonColor: const Color(0xffd0ebff),
        appBarIcon: const Icon(Icons.message, color: Color(0xffd0ebff)),
        buttonTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        appBarColor: const Color(0xffd0ebff),
        dialogCancelTextStyle:
            const TextStyle(color: Colors.redAccent, fontSize: 18),
        dialogContinueTextStyle:
            const TextStyle(color: Colors.blue, fontSize: 18));

    final Customer customer = Customer(
        name: "kilo-tech",
        phoneNumber: "0752185104",
        email: "arnoldrutanana@gmail.com");

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        publicKey: "FLWPUBK_TEST-919310eeadea8375f2576a0b91c3f252-X",
        currency: "UGX",
        redirectUrl: "my_redirect_url",
        txRef: "unique_transaction_reference",
        amount: "3000",
        customer: customer,
        paymentOptions: "ussd, card, barter, payattitude",
        customization: Customization(title: "Test Payment"),
        isTestMode: true);

    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      showLoading(context, response.status.toString());
      print("${response.toJson()}");
    } else {
      showLoading(context, "No Response!");
    }
  }

  Future<void> showLoading(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
