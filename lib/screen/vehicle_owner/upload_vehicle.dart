// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_match/controllers/vehicle_controller.dart';
import 'package:vehicle_match/screen/vehicle_owner/vehicle_home.dart';
import 'package:vehicle_match/widgets/rounded_button.dart';
import 'package:vehicle_match/widgets/rounded_input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UploadVehicle extends StatefulWidget {
  const UploadVehicle({Key? key}) : super(key: key);

  @override
  State<UploadVehicle> createState() => _UploadVehicleState();
}

class _UploadVehicleState extends State<UploadVehicle> {
  final formkey = GlobalKey<FormState>();
  final locationCtrl = TextEditingController();
  // Create a CollectionReference called vehicleRequests that references the firestore collection
  CollectionReference requests =
      FirebaseFirestore.instance.collection('vehicleRequests');
      //getting current user location
        getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress = '${placemark.locality}, ${placemark.subLocality},';
    locationCtrl.text = completeAddress;
    print(completeAddress);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("VEHICLE SPECIFICATIONS"),
      ),
      body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Center(
                child: GetBuilder<VehicleController>(
                    init: VehicleController(),
                    builder: (vehicleCtrler) {
                      return Column(
                        children: [
                          RoundedInput(
                            label: "Pickup Location",
                            hint: "pickup location",
                            icon: Icons.location_on,
                            handler: locationCtrl,
                            onChanged: (String value) {
                              setState(() {
                                vehicleCtrler.changePickUp(value);
                              });
                            },
                          suffixIcon: IconButton(
                      onPressed: (() => getUserLocation()),
                      icon: const Icon(Icons.add_location_alt_rounded)),
                          ),
                          RoundedInput(
                            label: "Destination",
                            hint: "Destination",
                            icon: Icons.place_sharp,
                            onChanged: (String value) {
                              setState(() {
                                vehicleCtrler.changeDestination(value);
                              });
                            },
                          ),
                          RoundedInput(
                            label: "Departure Time",
                            hint: "Departure Time",
                            icon: Icons.departure_board_rounded,
                            handler: vehicleCtrler.departureTime,
                            onChanged: (String value) {
                              setState(() {
                                vehicleCtrler.departureTime.text = value;
                              });
                            },
                            readOnly: true,
                            ontap: () => vehicleCtrler.selectTime(context),
                          ),
                          RoundedInput(
                            label: "Departure Date",
                            hint: "Departure Date",
                            icon: Icons.timelapse,
                            handler: vehicleCtrler.departureDate,
                            onChanged: (String value) {
                              setState(() {
                                vehicleCtrler.departureDate.text = value;
                              });
                            },
                            readOnly: true,
                            ontap: () => vehicleCtrler.selectDate(context),
                          ),
                          RoundedInput(
                            label: "Seats",
                            hint: "Number of available seats",
                            icon: Icons.airline_seat_recline_normal_sharp,
                            onChanged: (String value) {
                              setState(() {
                                vehicleCtrler.changeSeats(value);
                              });
                            },
                          ),
                          RoundedButton(
                              text: "Upload Specifications",
                              press: () {
                                if (formkey.currentState!.validate()) {
                                  uploadSpec(
                                      vehicleCtrler.pickUp,
                                      vehicleCtrler.destination,
                                      vehicleCtrler.departureTime.text,
                                      vehicleCtrler.departureDate.text,
                                      vehicleCtrler.seats);
                                }
                              },
                              color: Colors.red),
                          SizedBox(
                            height: size.height * 0.02,
                          )
                        ],
                      );
                    })),
          )),
    );
  }

  // upload vehicle Specifications

  Future<void> uploadSpec(String pickuplocation, String destLocation,
      String time, String date, String seats) {
    return requests.add({
      'vehicleUserEmail': FirebaseAuth.instance.currentUser!.email,
      'vehicleUserId': FirebaseAuth.instance.currentUser!.uid,
      'pickupLocation': pickuplocation,
      'destLocation': destLocation,
      'timeOfDeparture': time,
      'dateOfDeparture': date,
      'seatsNumber': seats,
    }).then((value) async {
      print(value.id);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehicle Specifications uploaded")));
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const VehicleOwnerHome())),
          (route) => false);
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send request: $error"))));
  }
}
