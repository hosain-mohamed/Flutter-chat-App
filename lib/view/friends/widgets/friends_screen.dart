import 'package:chat/service_locator.dart';
import 'package:chat/services/cloud_messaging_service/cloud_message_repository.dart';
import 'package:chat/services/cloud_messaging_service/cloud_messaging_impl.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/friends/bloc/friends_bloc.dart';
import 'package:chat/view/friends/widgets/friends_header.dart';
import 'package:chat/view/messages/widgets/messages_screen.dart';
import 'package:chat/view/notification/bloc/notification_bloc.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/register/widgets/register_screen.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/friends/widgets/edit_screen.dart';
import 'package:chat/view/widgets/footer.dart';
import 'package:chat/view/friends/widgets/friends_list.dart';
import 'package:chat/view/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class FriendsScreen extends StatelessWidget {
  static String routeID = "FRIENDS_SCREEN";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: kBackgroundColor,
          child: FriendsScreenView(),
        ),
      ),
    );
  }
}

class FriendsScreenView extends StatefulWidget {
  FriendsScreenView({
    Key key,
  }) : super(key: key);

  @override
  _FriendsScreenViewState createState() => _FriendsScreenViewState();
}

class _FriendsScreenViewState extends State<FriendsScreenView> {
  bool editForm = false;
  bool avatarClicked = false;
  FriendsBloc friendsBloc;
  NotificationBloc notificationBloc;
  @override
  void initState() {
    friendsBloc = serviceLocator<FriendsBloc>();
    notificationBloc = serviceLocator<NotificationBloc>()
      ..add(ListenToNotification());
    super.initState();
  }

  @override
  void dispose() {
    notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => notificationBloc,
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (BuildContext context, state) {
          if (state is NotificationRecived) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: MessagesScreen(friend: state.user)));
          }
        },
        child: BlocProvider<FriendsBloc>(
          create: (BuildContext context) => friendsBloc,
          child: WillPopScope(
            onWillPop: () async {
              if (editForm) {
                FocusScope.of(context).unfocus();
                friendsBloc.add(ClearSearch());
                setState(() {
                  editForm = false;
                });
                return false;
              }
              return true;
            },
            child: BlocListener<AccountBloc, AccountState>(
              listener: (context, accountState) {
                _mapAccountStateToActions(accountState);
              },
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FriendsHeader(
                        onBackPressed: () {
                          FocusScope.of(context).unfocus();
                          friendsBloc.add(ClearSearch());
                          setState(() {
                            editForm = false;
                          });
                        },
                        onAvatarPressed: () {
                          if (!avatarClicked ||
                              context.bloc<AccountBloc>().state
                                  is FetchProfileFailed) {
                            context
                                .bloc<AccountBloc>()
                                .add(FetchProfileEvent());
                            avatarClicked = true;
                          }
                          if (!editForm) {
                            setState(() {
                              editForm = true;
                            });
                          }
                        },
                        editForm: editForm,
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            const WhiteFooter(),
                            IndexedStack(
                              index: editForm ? 0 : 1,
                              children: [EditScreen(), FriendsList()],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // // show circular progress when Account Loading state appear
                  BlocBuilder<AccountBloc, AccountState>(
                    builder: (BuildContext context, state) {
                      return state is LogOutLoading
                          ? const Center(child: CircleProgress())
                          : const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mapAccountStateToActions(AccountState state) {
    if (Functions.modalIsShown) {
      Navigator.pop(context);
      Functions.modalIsShown = false;
    }
    if (state is LogOutSucceed) {
      Future.delayed(Duration(milliseconds: 200), () async {
        await Navigator.pushReplacement(
            context,
            PageTransition(
                child: RegisterScreen(), type: PageTransitionType.fade));
      });
    } else if (state is LogOutFailed) {
      Functions.showBottomMessage(context, state.failure.code);
    }
  }
}
