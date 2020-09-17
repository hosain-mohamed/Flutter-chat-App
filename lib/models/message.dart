
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Message extends Equatable {
  final String message;
  final String senderId;
  final String time;
  const Message(
      {@required this.time, @required this.senderId, @required this.message})
      : assert(message != null, "Message must not be equall null"),
        assert(senderId != null, "senderID must not be equall null");

  @override
  List<Object> get props => [message, senderId];

  Map<String, dynamic> toMap() {
    return {'message': message, 'senderId': senderId, 'time': time};
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
        message: map['message'], senderId: map['senderId'], time: map['time']);
  }
}
