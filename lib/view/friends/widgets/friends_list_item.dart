import 'package:chat/models/user_presentation.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/friends/bloc/friends_bloc.dart';
import 'package:chat/view/messages/widgets/messages_screen.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/avatar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';

class FriendsListItem extends StatelessWidget {
  const FriendsListItem({
    Key key,
    @required this.user,
  }) : super(key: key);
  final UserPresentation user;

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);

    return InkResponse(
      onTap: () {
        if (!KeyboardVisibility.isVisible) {
          Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: MessagesScreen(friend: user)))
              .then((value) {
            if (BlocProvider.of<FriendsBloc>(context).state is SearchSucceed) {
              print(0);
              BlocProvider.of<FriendsBloc>(context).add(ClearSearch());
            }
          });
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: Tween<double>(begin: -1, end: 1),
        builder: (BuildContext context, double value, Widget child) {
          return Transform.scale(
            scale: value,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: deviceData.screenHeight * 0.0375,
                top: deviceData.screenHeight * 0.0,
                left: deviceData.screenWidth * 0.1,
                right: deviceData.screenWidth * 0.12,
              ),
              child: Row(
                children: <Widget>[
                  AvatarIcon(
                    radius: 0.07,
                    user: user,
                    errorWidgetColor: kBackgroundColor,
                    placeholderColor: kBackgroundColor,
                  ),
                  SizedBox(width: deviceData.screenWidth * 0.045),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.name,
                              style: kArialFontStyle.copyWith(
                                  fontSize: deviceData.screenHeight * 0.0165),
                            ),
                            user.lastMessage != null
                                ? Text(
                                    Functions.convertDate(user.lastMessageTime),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize:
                                            deviceData.screenHeight * 0.015))
                                : SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(height: deviceData.screenHeight * 0.01),
                        Text(
                          user.lastMessage == null
                              ? "Let's keep in touch."
                              : user.userId == user.lastMessageSenderId
                                  ? Functions.getFirstName(user.name) +
                                      " : " +
                                      Functions.shortenMessage(
                                          user.lastMessage, 30)
                                  : "You" +
                                      " : " +
                                      Functions.shortenMessage(
                                          user.lastMessage, 30),
                          style: TextStyle(
                              fontWeight: user.lastMessage != null
                                  ? user.lastMessageSeen == true
                                      ? FontWeight.w400
                                      : FontWeight.bold
                                  : FontWeight.w400,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: deviceData.screenHeight * 0.015),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
