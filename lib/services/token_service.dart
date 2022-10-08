import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ombre_assignment/utils/utils.dart';

class TokenService {
  // int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl = tokenServerUrl;
  int tokenExpireTime = 240; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire

  Future<String?> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '${serverUrl}/rtc/$channelName/${tokenRole.toString()}/uid/0?expiry=}';
    print(url);

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      print('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      // setToken(newToken);
      return newToken;
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
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

