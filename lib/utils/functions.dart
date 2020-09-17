import 'dart:io';

import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Functions {

  static void transition(context, Widget screen, [Duration duration]) {
    Future.delayed(duration ?? Duration(milliseconds: 300), () async {
      await Navigator.pushReplacement(context,
          PageTransition(child: screen, type: PageTransitionType.fade));
    });
  }

  static List<String> getAvatarsPaths() {
    return [
      'assets/images/avatars/avatar5.png',
      'assets/images/avatars/avatar3.png',
      'assets/images/avatars/avatar4.png',
      'assets/images/avatars/avatar1.jpg',
      'assets/images/avatars/avatar2.png',
    ];
  }

  static final String femaleAvaterPath = 'assets/images/avatars/avatar3.png';

  static bool modalIsShown = false;

  static void showBottomMessage(BuildContext context, String message,
      {bool isDismissible = true}) async {
    final deviceData = DeviceData.init(context);
    print("message : " + message);

    showModalBottomSheet(
        isDismissible: isDismissible,
        backgroundColor: kBackgroundColor,
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return isDismissible;
            },
            child: Padding(
              padding: EdgeInsets.all(deviceData.screenWidth * 0.05),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: deviceData.screenHeight * 0.018,
                    color: Colors.white),
              ),
            ),
          );
        }).then((value) {
      modalIsShown = false;
    });
    modalIsShown = true;
  }

  static Future<bool> getNetworkStatus({Duration duration}) async {
    await Future.delayed(duration ?? Duration(milliseconds: 300));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static String convertDate(String timestamp) {
    int hour = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
        .toDate()
        .hour;
    int min = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
        .toDate()
        .minute;
    int day =
        Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp)).toDate().day;
    int month = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
        .toDate()
        .month;
    int year = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
        .toDate()
        .year;
    int currentDay = Timestamp.now().toDate().day;
    int currentMonth = Timestamp.now().toDate().month;
    int currentYear = Timestamp.now().toDate().year;
    if (day == currentDay && month == currentMonth && year == currentYear) {
      String afternoon = "AM";
      if (hour >= 12) {
        afternoon = "PM";
        hour = hour - 12;
      }
      if (min < 10) {
        return hour.toString() + ":" + "0" + min.toString() + " " + afternoon;
      }
      return hour.toString() + ":" + min.toString() + " " + afternoon;
    } else {
      return month.toString() + "/" + day.toString();
    }
  }

  static String shortenMessage(String value, int maxLetters) {
    if (value.length > maxLetters) {
      return value.substring(0, maxLetters) + '...';
    }
    return value;
  }

  static String getFirstName(String value) {
    return value.split(" ")[0];
  }

  static String shortenName(String value, int maxLetters) {
    return value.split(" ")[0];
  }
}
