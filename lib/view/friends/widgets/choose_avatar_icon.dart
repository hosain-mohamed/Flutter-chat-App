import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class ChooseAvatarIcon extends StatelessWidget {
  final String imagePath;
  final int selectedIndex;
  final int avatarIndex;
  final Function onSelect;

  const ChooseAvatarIcon(
      {Key key,
      @required this.imagePath,
      @required this.selectedIndex,
      @required this.avatarIndex,
      @required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    double width = 0;
    if (selectedIndex == avatarIndex) {
      width = 4;
    }
    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: width,
            color: kBackgroundButtonColor,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: width == 0 ? 0 : 2,
              color: Colors.white,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: deviceData.screenHeight * 0.09,
              height: deviceData.screenHeight * 0.09,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
