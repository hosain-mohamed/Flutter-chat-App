import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';
class BackIcon extends StatelessWidget {
  const BackIcon({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return Container(
      width: deviceData.screenHeight * 0.05,
      height: deviceData.screenHeight * 0.05,
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: Color(0xFF20a0bf),
      ),
      child: InkResponse(
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        child: Icon(
          Icons.arrow_back,
          size: deviceData.screenWidth * 0.055,
          color: Colors.white,
        ),
      ),
    );
  }
}
