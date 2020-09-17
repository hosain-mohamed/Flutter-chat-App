import 'package:chat/models/user.dart';
import 'package:chat/utils/failure.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/friends/widgets/edit_form_view.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/widgets/progress_indicator.dart';
import 'package:chat/view/widgets/try_again_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditScreen extends StatefulWidget {
  const EditScreen();
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        _mapStateToAction(state);
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, state) {
          return Stack(
            children: [
              user != null
                  ? EditFormView(user: user)
                  : state is FetchProfileFailed &&
                          state.failure is NetworkException
                      ? TryAgain(
                          doAction: () => context
                              .bloc<AccountBloc>()
                              .add(FetchProfileEvent()),
                        )
                      : SizedBox.shrink(),
              state is EditAccountLoading || state is FetchProfileLoading
                  ? const Center(child: CircleProgress())
                  : const SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }

  void _mapStateToAction(AccountState state) {
    if (Functions.modalIsShown) {
      Navigator.pop(context);
      Functions.modalIsShown = false;
    }
    if (state is EditAccountSucceed) {
      user = state.user;
    } else if (state is FetchProfileSucceed) {
      user = state.user;
    } else if (state is FetchProfileFailed) {
      Functions.showBottomMessage(context, state.failure.code);
    }
    if (state is EditAccountLoading) {
      Functions.showBottomMessage(context, "Saving ..", isDismissible: false);
    } else if (state is EditAccountFailed) {
      Functions.showBottomMessage(context, state.failure.code);
    }
  }
}
