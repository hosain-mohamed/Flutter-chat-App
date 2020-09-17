import 'package:chat/service_locator.dart';
import 'package:chat/view/notification/bloc/notification_bloc.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/splash/widgets/splash_screen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
            create: (_) =>
                serviceLocator<AccountBloc>()..add(IsSignedInEvent())),
        // BlocProvider<NotificationBloc>(
        //     create: (_) => serviceLocator<NotificationBloc>()
        //     ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: kBackgroundColor,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
