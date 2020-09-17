import 'package:chat/models/user.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/widgets/avatar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvatarButton extends StatelessWidget {
  AvatarButton({Key key, @required this.onPressed}) : super(key: key);
  final Function onPressed;
  static User user;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) => current is RegisterSucceed || current is EditAccountSucceed,
      builder: (context, state) {
        if (state is RegisterSucceed) {
          user = state.user;
        } else if (state is EditAccountSucceed) {
          user = state.user;
        }
        if (user == null) return SizedBox.shrink();
        return Container(
          child: InkResponse(
            onTap: () {
              if (onPressed != null) {
                onPressed();
              }
            },
            child: AvatarIcon(
              radius: 0.05,
              user: user,
            ),
          ),
        );
      },
    );
  }
}
