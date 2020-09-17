import 'package:chat/models/user.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/avatar_icon.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key key,
    @required this.showFriendImage,
    @required this.friend,
    @required this.senderId,
    @required this.message,
  }) : super(key: key);
  final bool showFriendImage;
  final User friend;
  final String message;
  final String senderId;

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: deviceData.screenHeight * 0.01,
        left: deviceData.screenWidth * 0.07,
        right: deviceData.screenWidth * 0.08,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: senderId == friend.userId
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
          senderId == friend.userId
              ? showFriendImage == true
                  ? AvatarIcon(
                      user: friend,
                      radius: 0.045,
                      errorWidgetColor: kBackgroundColor,
                      placeholderColor: kBackgroundColor,
                    )
                  : SizedBox(width: deviceData.screenHeight * 0.045)
              : SizedBox.shrink(),
          senderId == friend.userId
              ? SizedBox(width: deviceData.screenWidth * 0.02)
              : SizedBox.shrink(),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  color: kBackgroundColor
                      .withOpacity(senderId == friend.userId ? 0.1 : 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(deviceData.screenWidth * 0.05),
                    topRight: Radius.circular(deviceData.screenWidth * 0.05),
                    bottomRight: Radius.circular(senderId == friend.userId
                        ? deviceData.screenWidth * 0.05
                        : 0),
                    bottomLeft: Radius.circular(senderId != friend.userId
                        ? deviceData.screenWidth * 0.05
                        : 0),
                  )),
              padding: EdgeInsets.symmetric(
                  vertical: deviceData.screenHeight * 0.015,
                  horizontal: deviceData.screenHeight * 0.015),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: deviceData.screenHeight * 0.018,
                  color:
                      senderId == friend.userId ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
