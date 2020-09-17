import 'dart:io';

import 'package:chat/models/user.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user_presentation.dart';
import 'package:chat/services/storage_service/storage_repository.dart';
import 'package:chat/utils/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageRepoFirestoreImpl extends StorageRepository {
  // final Firestore _firestore = Firestore.instance;
  DocumentSnapshot lastMessageDoc;

  @override
  Stream<List<UserPresentation>> fetchFirstUsers(
      {@required String userId, @required int maxLength}) {
    try {
      return Firestore.instance
          .collection("users")
          .orderBy(userId + "_" + 'lastMessageTime', descending: true)
          .limit(maxLength)
          .snapshots()
          .map((event) => event.documents.where((e) => e != null).map((e) {
                return UserPresentation.fromMap(userId, e.data);
              }).toList());
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  Future<List<Message>> fetchNextMessages({String userId, String friendId,
      int maxLength, int firstMessagesLength}) async {
    try {
      if (lastMessageDoc == null) {
        var queryList = Firestore.instance
            .collection("users")
            .document(userId)
            .collection("contacts")
            .document(friendId)
            .collection("messages")
            .orderBy('time', descending: true)
            .limit(firstMessagesLength);
        var documentlist = (await queryList.getDocuments()).documents;
        if (documentlist.length > 0) {
          lastMessageDoc = documentlist[documentlist.length - 1];
        }
      }
      final nextMessagesSnapshots = (await Firestore.instance
              .collection("users")
              .document(userId)
              .collection("contacts")
              .document(friendId)
              .collection("messages")
              .orderBy('time', descending: true)
              .startAfterDocument(lastMessageDoc)
              .limit(maxLength)
              .getDocuments())
          .documents;

      final List<Message> nextMessages = [];
      for (var m in nextMessagesSnapshots) {
        nextMessages.add(Message.fromMap(m.data));
      }
      if (nextMessagesSnapshots.length > 0) {
        lastMessageDoc =
            nextMessagesSnapshots[nextMessagesSnapshots.length - 1];
      }
      return nextMessages;
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  @override
  Stream<List<Message>>  fetchFirstMessages({
     @required  String userId, @required  String friendId,@required int maxLength}) async* {
    try {
      yield* Firestore.instance
          .collection("users")
          .document(userId)
          .collection("contacts")
          .document(friendId)
          .collection("messages")
          .orderBy('time', descending: true)
          .limit(maxLength)
          .snapshots()
          .map((event) => event.documents.where((e) {
                return e != null;
              }).map((e) {
                return Message.fromMap(e.data);
              }).toList());
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  @override
  Future<User> fetchProfileUser([String userId]) async {
    try {
      final userDocument =
          Firestore.instance.collection("users").document(userId);
      final uesrData = (await userDocument.get()).data;
      return User.fromMap(uesrData);
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  @override
  Future<void> saveProfileUser(User user) async {
    try {
      final userMap = user.toMap();
      await Firestore.instance
          .collection("users")
          .document(user.userId)
          .setData(userMap);
      final allUsersDocuments =
          (await Firestore.instance.collection("users").getDocuments())
              .documents;
      for (var doc in allUsersDocuments) {
        if (doc.data['userId'] != user.userId) {
          await Firestore.instance
              .collection("users")
              .document(user.userId)
              .setData(
                  _generateLastMessageData(
                      doc.data['userId'], null, null, null, false),
                  merge: true);

          await Firestore.instance
              .collection("users")
              .document(doc.data['userId'])
              .setData(
                  _generateLastMessageData(
                      user.userId, null, null, null, false),
                  merge: true);
        }
      }
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  Map<String, dynamic> _generateLastMessageData(
      String id, String message, String senderId, String time, bool seen) {
    final Map<String, dynamic> lastMessageData = {
      id + "_" + 'lastMessage': message,
      id + "_" + 'lastMessageSenderId': senderId,
      id + "_" + 'lastMessageTime': time,
      id + "_" + 'lastMessageSeen': seen
    };
    return lastMessageData;
  }

  @override
  Future<void> sendMessage(
      {String message, String userId, String friendId}) async {
    try {
      final timeStamp = Timestamp.now().millisecondsSinceEpoch.toString();
      final messageData =
          Message(message: message, senderId: userId, time: timeStamp).toMap();
      Firestore.instance
          .collection("users")
          .document(userId)
          .collection("contacts")
          .document(friendId)
          .collection("messages")
          .document(timeStamp)
          .setData(messageData);
      Firestore.instance
          .collection("users")
          .document(friendId)
          .collection("contacts")
          .document(userId)
          .collection("messages")
          .document(timeStamp)
          .setData(messageData);
      Firestore.instance.collection("users").document(userId).setData(
          _generateLastMessageData(friendId, message, userId, timeStamp, false),
          merge: true);
      Firestore.instance.collection("users").document(friendId).setData(
          _generateLastMessageData(userId, message, userId, timeStamp, true),
          merge: true);
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  @override
  Future<User> updateProfileNameAndImage(
      {@required String userId,
      @required String name,
      File photo,
      String imgUrl}) async {
    try {
      final userDocument =
          Firestore.instance.collection("users").document(userId);

      if (photo != null) {
        bool haveNetworkImage =
            (await userDocument.get()).data['imageType'] == 'network';
        String photoUrl = await _uploadPhoto(userId, photo, haveNetworkImage);
        await userDocument.updateData(
            {'name': name, 'imageType': 'network', 'imgUrl': photoUrl});
      } else if (imgUrl != null) {
        await userDocument.updateData(
            {'name': name, 'imageType': 'assets', 'imgUrl': imgUrl});
      } else {
        await userDocument.updateData({'name': name});
      }
      return User.fromMap((await userDocument.get()).data);
    } catch (e) {
      throw UnImplementedFailure();
    }
  }

  Future<String> _uploadPhoto(String userId, File photo,
      [bool haveNetworkImage = false]) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(userId + "_profileImage");
    if (haveNetworkImage) await storageReference.delete();
    final task = storageReference.putFile(photo);
    String photoUrl = await (await task.onComplete).ref.getDownloadURL();
    return photoUrl;
  }

  @override
  Future<void> markMessageSeen(String userId, String friendId) async {
    Firestore.instance
        .collection("users")
        .document(friendId)
        .setData({userId + "_" + 'lastMessageSeen': true}, merge: true);
  }

  @override
  Future<List<UserPresentation>> searchByName(
      {String userId, String name}) async {
    try {
      var allUsers = (await Firestore.instance
              .collection("users")
              .orderBy(userId + "_" + 'lastMessageTime', descending: true)
              .getDocuments())
          .documents
          .map((e) => UserPresentation.fromMap(userId, e.data))
          .toList();

      var usersStartwith = allUsers
          .where((element) =>
              element.name.toLowerCase().startsWith(name.toLowerCase()))
          .toList();

      var usersContain = allUsers
          .where((element) =>
              !element.name.toLowerCase().startsWith(name.toLowerCase()) &&
              element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();

      return usersStartwith + usersContain;
    } catch (e) {
      print(e.toString());
      throw UnImplementedFailure();
    }
  }
}
