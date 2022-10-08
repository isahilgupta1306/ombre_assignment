// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:ombre_assignment/utils/utils.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';

// const String appId = "1614d136a7c548268c3f7b83fda80a8c";

// class MyTestWidget extends StatefulWidget {
//   const MyTestWidget({Key? key}) : super(key: key);

//   @override
//   State<MyTestWidget> createState() => _MyTestWidgetState();
// }

// class _MyTestWidgetState extends State<MyTestWidget> {
//   String channelName = "test2";
//   String token =
//       "007eJxTYHizsub5/4eGcacvTNBx4gyI1M5jeeAk/UKJ69yrKWdLw28oMBiaGZqkGBqbJZonm5pYGJlZJBunmSdZGKelJFoYJFokL/S0S1aYbZ9ccj2NgREKQXxWhpLU4hIjBgYAsqMhJA==";

//   int uid = 0; // uid of the local user

//   int? _remoteUid; // uid of the remote user
//   bool _isJoined = false; // Indicates if the local user has joined the channel
//   late RtcEngine agoraEngine; // Agora engine instance

//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

//   @override
//   void initState() {
//     super.initState();
//     // Set up an instance of Agora engine
//     setupVideoSDKEngine();
//   }

//   showMessage(String message) {
//     scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }

//   Future<void> setupVideoSDKEngine() async {
//     // retrieve or request camera and microphone permissions
//     await [Permission.microphone, Permission.camera].request();

//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine.initialize(const RtcEngineContext(appId: appId));

//     await agoraEngine.enableVideo();

//     // Register the event handler
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           showMessage(
//               "Local user uid:${connection.localUid} joined the channel");
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           showMessage("Remote user uid:$remoteUid joined the channel");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           showMessage("Remote user uid:$remoteUid left the channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//   }

//   void join() async {
//     await agoraEngine.startPreview();

//     // Set channel options including the client role and channel profile
//     ChannelMediaOptions options = const ChannelMediaOptions(
//       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     );

//     await agoraEngine.joinChannel(
//       token: token,
//       channelId: channelName,
//       options: options,
//       uid: uid,
//     );
//   }

//   void leave() {
//     setState(() {
//       _isJoined = false;
//       _remoteUid = null;
//     });
//     agoraEngine.leaveChannel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: scaffoldMessengerKey,
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Get started with Video Calling'),
//           ),
//           body: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             children: [
//               // Container for the local video
//               Container(
//                 height: 240,
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: Center(child: _localPreview()),
//               ),
//               const SizedBox(height: 10),
//               //Container for the Remote video
//               Container(
//                 height: 240,
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: Center(child: _remoteVideo()),
//               ),
//               // Button Row
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isJoined ? null : () => {join()},
//                       child: const Text("Join"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isJoined ? () => {leave()} : null,
//                       child: const Text("Leave"),
//                     ),
//                   ),
//                 ],
//               ),
//               // Button Row ends
//             ],
//           )),
//     );
//   }

// // Display local video preview
//   Widget _localPreview() {
//     if (_isJoined) {
//       return AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: agoraEngine,
//           canvas: VideoCanvas(uid: uid),
//         ),
//       );
//     } else {
//       return const Text(
//         'Join a channel',
//         textAlign: TextAlign.center,
//       );
//     }
//   }

// // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: agoraEngine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: channelName),
//         ),
//       );
//     } else {
//       String msg = '';
//       if (_isJoined) msg = 'Waiting for a remote user to join';
//       return Text(
//         msg,
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
