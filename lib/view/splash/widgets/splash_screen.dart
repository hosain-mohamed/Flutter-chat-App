import 'package:chat/services/cloud_messaging_service/cloud_message_repository.dart';
import 'package:chat/services/cloud_messaging_service/cloud_messaging_impl.dart';
import 'package:chat/utils/failure.dart';
import 'package:chat/view/friends/widgets/friends_screen.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/register/widgets/register_screen.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/button_widget.dart';
import 'package:chat/view/widgets/fade_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/utils/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreen extends StatefulWidget {
  static String routeID = "SPLASH_SCREEN";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    DeviceData _deviceData = DeviceData.init(context);
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) async {
        if (Functions.modalIsShown) {
          Navigator.pop(context);
          Functions.modalIsShown = false;
        }
        await Future.delayed(Duration(milliseconds: 1000));
        if (state is RegisterSucceed) {
          Functions.transition(context, FriendsScreen());
        } else if (state is IsSignInFailed) {
          if (state.failure is BottomPlacedException) {
            Functions.showBottomMessage(context, state.failure.code);
          } else {
            Functions.transition(context, RegisterScreen());
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Logo(),
                  SizedBox(height: _deviceData.screenHeight * 0.05),
                  const Description(),
                  SizedBox(height: _deviceData.screenHeight * 0.05),
                  BlocBuilder<AccountBloc, AccountState>(
                    builder: (context, state) => state is IsSignInFailed &&
                            state.failure is NetworkException
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceData.screenWidth * 0.2),
                            child: RoundedButton(
                                text: "Try again",
                                onPressed: () {
                                  context
                                      .bloc<AccountBloc>()
                                      .add(IsSignedInEvent());
                                }),
                          )
                        : SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo();

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);
    return FadeIn(
      duration: Duration(milliseconds: 300),
      child: Container(
        child: Image.asset(
          'assets/images/chatlogo.png',
          fit: BoxFit.contain,
          width: deviceData.screenWidth * 0.45,
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Text(
        "Start chating with people from \n all over the world.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: deviceData.screenHeight * 0.018,
        ),
      ),
    );
  }
}
