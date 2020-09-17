import 'package:chat/utils/functions.dart';
import 'package:chat/view/widgets/popup_menu.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:chat/models/user.dart';
import 'package:chat/view/messages/widgets/back_icon.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/avatar_icon.dart';

class MessagesHeader extends StatelessWidget {
  final User friend;
  const MessagesHeader({Key key, @required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);

    return Padding(
      padding: EdgeInsets.only(
        top: deviceData.screenHeight * 0.06,
        bottom: deviceData.screenHeight * 0.005,
        left: deviceData.screenWidth * 0.05,
        right: deviceData.screenWidth * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BackIcon(),
          Row(
            children: [
              AvatarIcon(
                user: friend,
                radius: 0.05,
              ),
              SizedBox(width: deviceData.screenWidth * 0.035),
              Text(
                Functions.getFirstName(friend.name),
                style: kArialFontStyle.copyWith(
                  fontSize: deviceData.screenHeight * 0.022,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          PopUpMenu(),
        ],
      ),
    );
  }
}
