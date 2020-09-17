import 'package:chat/services/authentication_service/authentication_repository.dart';
import 'package:chat/services/authentication_service/firebase_auth_impl.dart';
import 'package:chat/services/cloud_messaging_service/cloud_message_repository.dart';
import 'package:chat/services/cloud_messaging_service/cloud_messaging_impl.dart';
import 'package:chat/services/storage_service/storage_repo_firestore_impl.dart';
import 'package:chat/services/storage_service/storage_repository.dart';
import 'package:chat/view/friends/bloc/friends_bloc.dart';
import 'package:chat/view/messages/bloc/messages_bloc.dart';
import 'package:chat/view/notification/bloc/notification_bloc.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void serviceLoctorSetup() {
  serviceLocator.registerFactory(() => FriendsBloc(
        storageRepository: serviceLocator<StorageRepository>(),
        authService: serviceLocator<AuthenticationRepository>(),
      ));

  serviceLocator.registerFactory(() => MessagesBloc(
        storageRepository: serviceLocator<StorageRepository>(),
        authRepository: serviceLocator<AuthenticationRepository>(),
      ));

  serviceLocator.registerFactory(() => AccountBloc(
        authImpl: serviceLocator<AuthenticationRepository>(),
        storageRepository: serviceLocator<StorageRepository>(),
      ));

  serviceLocator.registerFactory(() => NotificationBloc(
        storageRepository: serviceLocator<StorageRepository>(),
        cloudMessageRepo: serviceLocator<CloudMessageRepository>(),
      ));

  serviceLocator
      .registerFactory<StorageRepository>(() => StorageRepoFirestoreImpl());

  serviceLocator
      .registerFactory<AuthenticationRepository>(() => FirebaseAuthImpl());
  serviceLocator
      .registerFactory<CloudMessageRepository>(() => CloudMessagingImpl());
}
