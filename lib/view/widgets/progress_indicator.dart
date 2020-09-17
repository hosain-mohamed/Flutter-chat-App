import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class CircleProgress extends StatelessWidget {
  final double radius;
  const CircleProgress({
    Key key,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);

    return Container(
      width: radius == null ? deviceData.screenHeight * 0.045 : deviceData.screenHeight * radius ,
      height: radius == null ? deviceData.screenHeight * 0.045 : deviceData.screenHeight * radius ,
      child: CircularProgressIndicator(
        strokeWidth: deviceData.screenWidth * 0.007,
        backgroundColor: kBackgroundButtonColor,
      ),
    );
  }
}
