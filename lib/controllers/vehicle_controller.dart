import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleController extends GetxController {
  String pickUp = '';
  String destination = '';
  String seats = '';
  final departureDate = TextEditingController();
  final departureTime = TextEditingController();
  // time part
  String hour = '', minute = ' ', time = ' ';
  TimeOfDay selectedTime = TimeOfDay.now();
//  date part
  DateTime selectedDate = DateTime.now();

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 20))))) {
      return true;
    }
    return false;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'SELECT DATE',
      cancelText: 'NOT NOW',
      confirmText: 'SET',
    );

    if (picked != null) {
      selectedDate = picked;
      departureDate.text = "${selectedDate.toLocal()}".split(' ')[0];
      update();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      helpText: 'CHOOSE DEPARTURE TIME',
      cancelText: 'NOT NOW',
      confirmText: 'SET',
    );
    if (picked != null) {
      selectedTime = picked;
      hour = selectedTime.hour.toString().length == 1
          ? '0${selectedTime.hour}'
          : selectedTime.hour.toString();

      minute = selectedTime.minute.toString().length == 1
          ? '0${selectedTime.minute}'
          : selectedTime.minute.toString();
      time = '$hour : $minute';
      departureTime.text = time;
      update();
    }
  }

  changePickUp(String value) {
    pickUp = value;
    update();
  }

  changeDestination(String value) {
    destination = value;
    update();
  }

  changeSeats(String value) {
    seats = value;
    update();
  }
}
