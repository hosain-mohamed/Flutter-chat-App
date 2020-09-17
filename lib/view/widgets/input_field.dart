import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String inputTitle;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function onSubmitted;
  final bool isLastField;
  final String initalText;
  final Function onSaved;
  final Function onChanged;
  final OnValidator onValidator;
  final String errorText;
  final bool enabled;
  final bool obscureText;
  final Widget inputIcon;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  InputField({
    this.inputTitle,
    this.hintText,
    this.inputType,
    this.inputAction = TextInputAction.next,
    this.isLastField = false,
    this.onSubmitted,
    this.initalText,
    this.onSaved,
    this.errorText,
    this.enabled = true,
    this.onValidator,
    this.onChanged,
    this.obscureText = false,
    this.inputIcon,
    this.textCapitalization,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    DeviceData _deviceData = DeviceData.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        inputTitle != null
            ? Text(
                inputTitle,
                style: kArialFontStyle.copyWith(
                  color: kInputTitleColor,
                  fontSize: _deviceData.screenHeight * 0.016,
                ),
              )
            : SizedBox.shrink(),
        SizedBox(height: _deviceData.screenHeight * 0.01),
        Row(
          children: <Widget>[
            inputIcon != null ? inputIcon : SizedBox.shrink(),
            inputIcon != null
                ? SizedBox(width: _deviceData.screenWidth * 0.02)
                : SizedBox.shrink(),
            Expanded(
              child: TextFormField(
                textAlign: textAlign ?? TextAlign.start,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                maxLines: obscureText ? 1 : null,
                initialValue: initalText,
                enabled: enabled,
                keyboardType: inputType,
                obscureText: obscureText,
                cursorColor: kButtonColor,
                style: TextStyle(
                  fontSize: _deviceData.screenHeight * 0.017,
                ),
                decoration: setInputDecoration(_deviceData),
                textInputAction:
                    isLastField ? TextInputAction.done : TextInputAction.next,
                onFieldSubmitted: (value) {
                  if (!isLastField) {
                    FocusScope.of(context)
                        .focusInDirection(TraversalDirection.down);
                  } else if (onSubmitted != null) {
                    Future.delayed(Duration(milliseconds: 300), () {
                      onSubmitted(value);
                    });
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    if (obscureText != null && obscureText) {
                      return "Password is empty.";
                    }
                    if (inputType != null &&
                        inputType == TextInputType.emailAddress) {
                      return "Email is empty.";
                    } else if (inputTitle != null) {
                      return "$inputTitle is empty.";
                    }

                    return "This field is empty.";
                  } else if (onValidator != null) {
                    return onValidator(value);
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  if (onSaved != null) {
                    onSaved(value);
                  }
                },
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration setInputDecoration(DeviceData deviceData) {
    return InputDecoration(
      errorText: errorText,
      errorStyle: TextStyle(fontSize: deviceData.screenHeight * 0.0145),
      prefixText: " ",
      filled: true,
      fillColor: kInputFillColor,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(deviceData.screenWidth * 0.03),
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      hintText: hintText,
    );
  }
}

typedef String OnValidator(String value);
