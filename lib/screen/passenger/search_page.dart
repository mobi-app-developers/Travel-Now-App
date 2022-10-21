import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/controllers/passenger_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passengerContrl.fetchVehicleContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Search Area"),
        centerTitle: true,
      ),
      body: Center(
        child: GetBuilder<PassengerController>(
            init: PassengerController(),
            builder: (passengerSearch) {
              return Column(
                children: <Widget>[
                  Container(
                      color: Theme.of(context).primaryColor,
                      child: passengerSearch.buildSearchBox()),
                  Expanded(
                      child: passengerSearch.searchResult.isNotEmpty ||
                              passengerSearch.controller.text.isNotEmpty
                          ? passengerSearch.buildSearchResults()
                          : passengerSearch.buildSearchList()),
                ],
              );
            }),
      ),
    );
  }
}
