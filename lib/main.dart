import 'package:chat/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_app.dart';
import 'package:flutter/material.dart';
import 'package:chat/service_locator.dart';

void main() {
  serviceLoctorSetup();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}
