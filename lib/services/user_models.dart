import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String userName;
  late String channelName;
  late String channelToken;
  late String email;
  late String uid;

  UserModel(
    this.userName,
    this.channelName,
    this.channelToken,
    this.email,
    this.uid,
  );

  Map<String, dynamic> toMap() {
    return {
      'full_name': userName,
      'email': email,
      'uid': uid,
      'channel_name': channelName,
      'channel_token': channelToken,
    };
  }

  Map<String, dynamic> toJSON() {
    return {
      'full_name': userName,
      'email': email,
      'uid': uid,
      'channel_name': channelName,
      'channel_token': channelToken,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['full_name'];
    email = json['email'];
    uid = json['uid'];
    channelName = json['channel_name'];
    channelToken = json['channel_token'];
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String userName;
    String email;
    String uid;
    String channelName;
    String channelToken;

    userName = doc.get('full_name');
    email = doc.get('email');
    uid = doc.get('uid');
    channelName = doc.get('channel_name');
    channelToken = doc.get('channel_token');

    return UserModel(userName, channelName, channelToken, email, uid);
  }
}
