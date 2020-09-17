import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return Material(
      elevation: 3.5,
      borderRadius: BorderRadius.all(
        Radius.circular(deviceData.screenWidth * 0.05),
      ),
      child: Container(
        width: deviceData.screenWidth * 0.75,
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction: TextInputAction.newline,
          cursorColor: kBackgroundColor,
          style: TextStyle(
            fontSize: deviceData.screenHeight * 0.018,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                  Radius.circular(deviceData.screenWidth * 0.05)),
            ),
            hintText: "type your message",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
