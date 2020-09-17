import 'package:flutter/foundation.dart';

import 'package:chat/models/user.dart';

class UserPresentation extends User {
  final String lastMessage;
  final String lastMessageSenderId;
  final String lastMessageTime;
  final bool lastMessageSeen;

  final String name;
  final String email;
  final String imgUrl;
  final ImageType imageType;
  final String userId;
  final String currentUserId;
  UserPresentation({
    @required this.name,
    @required this.email,
    @required this.imgUrl,
    @required this.imageType,
    @required this.userId,
    @required this.lastMessage,
    @required this.lastMessageSenderId,
    @required this.lastMessageTime,
    @required this.lastMessageSeen,
    @required this.currentUserId,
  }) : super(
          name: name,
          email: email,
          imgUrl: imgUrl,
          imageType: imageType,
          userId: userId,
        );
  @override
  List<Object> get props => [
        name,
        email,
        imgUrl,
        imageType,
        userId,
        lastMessage,
        lastMessageSenderId,
        lastMessageTime,
        lastMessageSeen,
        currentUserId
      ];

  Map<String, dynamic> toMap() {
    return {
      currentUserId + "_" + 'lastMessage': lastMessage,
      currentUserId + "_" + 'lastMessageSenderId': lastMessageSenderId,
      currentUserId + "_" + 'lastMessageTime': lastMessageTime,
      currentUserId + "_" + 'lastMessageSeen': lastMessageSeen,
      'name': name,
      'imgUrl': imgUrl,
      'imageType': imageType == ImageType.assets ? 'assets' : 'network',
      'userId': userId,
      'currentUserId': currentUserId,
    };
  }

  factory UserPresentation.fromMap(
      String currentUserId, Map<String, dynamic> map) {
    if (map == null) return null;

    return UserPresentation(
        currentUserId: currentUserId,
        lastMessage: map[currentUserId + "_" + 'lastMessage'],
        lastMessageSenderId: map[currentUserId + "_" + 'lastMessageSenderId'],
        lastMessageTime: map[currentUserId + "_" + 'lastMessageTime'],
        name: map['name'],
        imgUrl: map['imgUrl'],
        imageType:
            map['imageType'] == "assets" ? ImageType.assets : ImageType.network,
        userId: map['userId'],
        email: map['email'],
        lastMessageSeen: map[currentUserId + "_" + 'lastMessageSeen']);
  }

 
}
