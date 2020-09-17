import 'dart:io';

import 'package:chat/models/user.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user_presentation.dart';
import 'package:chat/services/storage_service/storage_repository.dart';
import 'package:flutter/foundation.dart';

class StorageServiceFakeImpl implements StorageRepository {
  @override
  Stream<List<UserPresentation>> fetchFirstUsers(
      {String userId, int maxLength}) async* {
    await Future.delayed(Duration(seconds: 1));
    //return fakeUsers;
  }

  @override
  Future<User> fetchProfileUser([String userId]) async {
    return User(
      userId: "4324324234",
      name: 'Hosain Mohamed',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatar1.jpg',
    );
  }

  @override
  Future<void> saveProfileUser(User user) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> fetchFirstMessages(
      {@required String userId,
      @required String friendId,
      @required int maxLength}) async* {
    await Future.delayed(Duration(milliseconds: 500));
    yield fakeMessages;
  }

  // Future<void> sendMessage(
  //     String message, String userId, String friendId) async {
  //   fakeMessages.add(Message(message: message, senderID: '0'));
  // }

  List<Message> fakeMessages = [];
  static List<User> fakeUsers = [
    User(
      userId: "4324324234",
      name: 'Hosain Mohamed',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar4.png',
    ),
    User(
      userId: "4324324234",
      name: 'Ahmed Nagy',
      email: 'hosain.m.abdellatif@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar2.png',
    ),
    User(
      userId: "4324324234",
      name: 'Alaa Fathy',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar4.png',
    ),
    User(
      userId: "4324324234",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
    User(
      userId: "4324324234",
      name: 'Ahmed Nagy',
      email: 'hosain.m.abdellatif@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar2.png',
    ),
    User(
      userId: "4324324234",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
    User(
      userId: "4324324234",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
    User(
      userId: "4324324234",
      name: 'Sara Adel',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar3.png',
    ),
    User(
      userId: "4324324234",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
  ];

  @override
  Future<User> updateProfileNameAndImage(
      {String userId, String name, File photo, String imgUrl}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage({String message, String userId, String friendId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> markMessageSeen(String userID, String friendID) {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> fetchNextMessages(
      {@required String userId,
      @required String friendId,
      @required int maxLength,
      @required int firstMessagesLength}) {
    throw UnimplementedError();
  }

  @override
  Future<List<UserPresentation>> searchByName({String userId, String name}) {
    throw UnimplementedError();
  }
}
