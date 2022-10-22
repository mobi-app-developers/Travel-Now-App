import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:vehicle_match/screen/passenger/passenger_auth_gate.dart';
import 'package:vehicle_match/screen/vehicle_owner/vehicle_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
              child: GlowText(
                "TRAVEL TOGETHER!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 5),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const Text("Vehicle Owner",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const VehicleAuthGate()),
                        (route) => true);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("Assets/images/vintage-car.png"),
                        ),
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Passenger",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const PassengerAuthGate()),
                        (route) => true);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("Assets/images/passenger.png"),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
