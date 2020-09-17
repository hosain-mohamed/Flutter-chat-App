import 'package:chat/utils/failure.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/button_widget.dart';
import 'package:chat/view/widgets/input_field.dart';
import 'package:chat/view/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key key,
    @required this.scaffoldContext,
  }) : super(key: key);
  final BuildContext scaffoldContext;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  Failure failure;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final deviceData = DeviceData.init(context);
    return BlocListener<AccountBloc, AccountState>(
      listener: (_, state) => _mapStateToActions(widget.scaffoldContext, state),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) => Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: deviceData.screenWidth * 0.11,
                    right: deviceData.screenWidth * 0.11,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: deviceData.screenHeight * 0.04),
                      InputField(
                        errorText:
                            failure is EmailException ? failure.code : null,
                        inputTitle: "Email",
                        hintText: "Enter your Registered email",
                        inputType: TextInputType.emailAddress,
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(height: deviceData.screenHeight * 0.03),
                      InputField(
                        inputTitle: "Password",
                        hintText: "Enter Password",
                        errorText:
                            failure is PasswordException ? failure.code : null,
                        obscureText: true,
                        isLastField: true,
                        onSubmitted: (value) {
                          _onSubmit();
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(height: deviceData.screenHeight * 0.04),
                      RoundedButton(
                          text: "Login",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _onSubmit();
                          })
                    ],
                  ),
                ),
              ),
            ),
            loading
                ? Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceData.screenHeight * 0.3),
                    child: Center(child: const CircleProgress()),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      context
          .bloc<AccountBloc>()
          .add(SigninEvent(email: email, password: password));
    }
  }

  void _mapStateToActions(BuildContext scaffoldContext, AccountState state) {
    failure = NoException();
    loading = false;
    if (Functions.modalIsShown) {
      Navigator.pop(context);
      Functions.modalIsShown = false;
    }
    if (state is SigninFailed) {
      failure = state.failure;
      if (state.failure is BottomPlacedException) {
        Functions.showBottomMessage(context, failure.code);
      }
    } else if (state is SigninLoading) {
      Functions.showBottomMessage(context, "Signing in ...",
          isDismissible: false);
      loading = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
