import 'dart:convert';

class Message {
  String? roomId;
  String? nickname;
  String? message;
  Message({
    this.roomId,
    this.nickname,
    this.message,
  });

  Message copyWith({
    String? roomId,
    String? username,
    String? message,
  }) {
    return Message(
      roomId: roomId,
      nickname: username,
      message: message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'nickname': nickname,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {

    return Message(
      roomId: map['roomId'],
      nickname: map['nickname'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() => '[$roomId, $nickname, $message]';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message &&
        o.roomId == roomId &&
        o.nickname == nickname &&
        o.message == message;
  }

  @override
  int get hashCode => roomId.hashCode ^ nickname.hashCode ^ message.hashCode;
}
