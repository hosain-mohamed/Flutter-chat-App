import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/cloud_messaging_service/cloud_message_repository.dart';
import 'package:chat/services/cloud_messaging_service/cloud_messaging_impl.dart';
import 'package:chat/services/storage_service/storage_repository.dart';
import 'package:chat/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final CloudMessageRepository cloudMessageRepo;
  final StorageRepository storageRepository;
  static bool isConfigured = false;
  NotificationBloc(
      {@required this.cloudMessageRepo, @required this.storageRepository})
      : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is ListenToNotification) {
      try {
        if (!isConfigured) {
          cloudMessageRepo.configure(
            onAppMessage: (senderId) async {
              // final user = await storageRepository.fetchProfileUser(senderId);
              // add(NotifcationReceivedEvent(user));
            },
            onAppLaunch: (senderId) async {
              final user = await storageRepository.fetchProfileUser(senderId);
              add(NotifcationReceivedEvent(user));
            },
            onAppResume: (senderId) async {
              final user = await storageRepository.fetchProfileUser(senderId);
              add(NotifcationReceivedEvent(user));
            },
          );
          isConfigured = true;
        }
      } on Failure catch (failure) {
        yield NotificationFailed(failure);
      }
    } else if (event is NotifcationReceivedEvent) {
      yield NotificationLoading();
      yield NotificationRecived(event.user);
    }
  }
}
