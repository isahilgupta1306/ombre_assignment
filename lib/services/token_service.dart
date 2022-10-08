import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ombre_assignment/utils/utils.dart';

class TokenService {
  String serverUrl = tokenServerUrl;
  int tokenExpireTime = 240;

  Future<String?> fetchToken(int uid, String channelName, int tokenRole) async {
    String url = '${serverUrl}/rtc/$channelName/${tokenRole.toString()}/uid/0';
    print(url);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      print('Token Received: $newToken');

      return newToken;
    } else {
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }
}



// void setToken(String newToken) async {
//     token = newToken;

//     if (isTokenExpiring) {
//         // Renew the token
//         agoraEngine.renewToken(token);
//         isTokenExpiring = false;
//         showMessage("Token renewed");
//     } else {
//         // Join a channel.
//         showMessage("Token received, joining a channel...");

//         await agoraEngine.joinChannel(
//             token: token,
//             channelId: channelName,
//             info: '',
//             uid: uid,
//         );
//     }
// }

