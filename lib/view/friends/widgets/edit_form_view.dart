import 'dart:io';

import 'package:chat/models/user.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/friends/widgets/choose_Avatar_row.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/avatar_icon.dart';
import 'package:chat/view/widgets/button_widget.dart';
import 'package:chat/view/widgets/fade_in_widget.dart';
import 'package:chat/view/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditFormView extends StatefulWidget {
  const EditFormView({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _EditFormViewState createState() => _EditFormViewState();
}

class _EditFormViewState extends State<EditFormView> {
  final formKey = GlobalKey<FormState>();
  String username;
  File pickedImage;
  bool imageIsPicked = false;
  String selectedAvatarPath;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);

    return SingleChildScrollView(
      child: FadeIn(
        duration: Duration(milliseconds: 500),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: deviceData.screenWidth * 0.11,
              right: deviceData.screenWidth * 0.11,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: deviceData.screenHeight * 0.04),
                  GestureDetector(
                    onTap: () => getImage(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        pickedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  pickedImage,
                                  width: deviceData.screenHeight * 0.12,
                                  height: deviceData.screenHeight * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : AvatarIcon(
                                user: widget.user,
                                radius: 0.12,
                                errorWidgetColor: kBackgroundColor,
                                placeholderColor: kBackgroundColor,
                              ),
                        Icon(
                          Icons.camera_alt,
                          size: deviceData.screenWidth * 0.1,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceData.screenHeight * 0.01),
                  Text(
                    widget.user.name,
                    style: kArialFontStyle.copyWith(
                      fontSize: deviceData.screenHeight * 0.019,
                      color: kBackgroundButtonColor,
                    ),
                  ),
                  SizedBox(height: deviceData.screenHeight * 0.03),
                  Text(
                    "Or choose photo from",
                    style: kArialFontStyle.copyWith(
                      fontSize: deviceData.screenHeight * 0.016,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: deviceData.screenHeight * 0.02),
                  ChooseAvatarRow(
                    user: widget.user,
                    onAvatarSelected: (avatarPath) =>
                        selectedAvatarPath = avatarPath,
                  ),
                  SizedBox(height: deviceData.screenHeight * 0.05),
                  InputField(
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.words,
                    inputType: TextInputType.multiline,
                    initalText: widget.user.name,
                    onSaved: (value) {
                      username = value;
                    },
                    isLastField: true,
                    onSubmitted: (value) {
                      onSubmit(context);
                    },
                  ),
                  SizedBox(height: deviceData.screenHeight * 0.04),
                  RoundedButton(
                      text: "Save",
                      onPressed: () {
                        onSubmit(context);
                      }),
                  SizedBox(height: deviceData.screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageIsPicked = true;
        setState(() {
          pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {}
  }

  void onSubmit(BuildContext context) {
    formKey.currentState.save();
    if (formKey.currentState.validate()) {
      if (username != widget.user.name ||
          imageIsPicked ||
          selectedAvatarPath != null) {
        if (!imageIsPicked) {
          if (selectedAvatarPath != null) {
            pickedImage = null;
            BlocProvider.of<AccountBloc>(context).add(EditAccountEvent(
                imgUrl: selectedAvatarPath,
                username: username,
                userId: widget.user.userId));
            selectedAvatarPath = null;
          } else {
             BlocProvider.of<AccountBloc>(context).add(EditAccountEvent(
                username: username, userId: widget.user.userId));
          }
        } else if (imageIsPicked) {
          context.bloc<AccountBloc>().add(EditAccountEvent(
              photo: pickedImage,
              username: username,
              userId: widget.user.userId));
          imageIsPicked = false;
        }
      } else {
        Functions.showBottomMessage(
          context,
          "Nothing changed.",
        );
      }
    }
  }
}
