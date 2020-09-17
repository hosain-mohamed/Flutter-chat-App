import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({
    Key key,
  }) : super(key: key);

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
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        icon: Icon(
          Icons.menu,
          color: Colors.white,
          size: deviceData.screenWidth * 0.058,
        ),
        color: kBackgroundButtonColor,
        onSelected: (value) {
          if (value == "logout") {
            BlocProvider.of<AccountBloc>(context).add(LogOutEvent());
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: "logout",
              child: Center(
                child: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ];
        },
      ),
    );
  }
}
