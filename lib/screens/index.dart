import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iris_event/iris_event.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ombre_assignment/providers/firebase_operations.dart';
import 'package:ombre_assignment/screens/call.dart';
import 'package:ombre_assignment/services/session_manager.dart';
import 'package:ombre_assignment/services/token_service.dart';
import 'package:ombre_assignment/utils/themes/app_text_styles.dart';
import 'package:ombre_assignment/utils/themes/named_colors.dart';
import 'package:ombre_assignment/widgets/custom_solid_button.dart';
import 'package:ombre_assignment/widgets/solid_inverse_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/google_signin.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _channelController = TextEditingController();
  bool _validateError = false;
  final channelNameTextController = TextEditingController();
  TokenService tokenService = TokenService();
  SessionManager prefs = SessionManager();

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: NamedColors.dimWhite,
      appBar: AppBar(
        title: const Text("Ombre Assignment"),
        actions: [
          IconButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: NamedColors.white,
              ))
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  SvgPicture.asset(
                    'assets/images/login_illustration.svg',
                    height: deviceSize.height * 0.25,
                    width: deviceSize.width * 0.25,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: prefs.getUserData(),
                    builder: (context, userDataSnapshot) {
                      if (!userDataSnapshot.hasData) {
                        return const Text("Login Issue Encountered");
                      }
                      if (userDataSnapshot.connectionState ==
                          ConnectionState.waiting) ;
                      var data = userDataSnapshot.data;
                      String userUID = data!['auth_token'];
                      String displayName = data['display_name'];

                      return Column(
                        children: [
                          SolidInverseButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => onGoingEventsSheet(
                                      context,
                                      deviceSize,
                                      channelNameTextController,
                                      tokenService,
                                      userUID),
                                );
                              },
                              label: " Join OnGoing Events",
                              deviceSize: deviceSize,
                              labelTextStyle:
                                  AppTextStyles.SolidInverseButttonTextStyle,
                              icon: Icons.join_full),
                          const SizedBox(
                            height: 20,
                          ),
                          SolidButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return channelNamePicker(
                                        context,
                                        deviceSize,
                                        channelNameTextController,
                                        tokenService,
                                        userUID,
                                        displayName);
                                  },
                                );
                              },
                              label: "BroadCast your Channel",
                              deviceSize: deviceSize,
                              labelTextStyle:
                                  AppTextStyles.solidButttonTextStyle,
                              icon: Icons.broadcast_on_home),
                          ElevatedButton(
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                provider.logout();
                              },
                              child: const Text("LOGOUT")),
                        ],
                      );
                    },
                  )
                  // Column(
                  //   children: [
                  //     // TextField(
                  //     //   controller: _channelController,
                  //     //   decoration: InputDecoration(
                  //     //       hintText: "Channel Name",
                  //     //       errorText:
                  //     //           _validateError ? "Channel name is mandatory" : null),
                  //     // ),
                  //     // RadioListTile(
                  //     //     title: const Text("BroadCaster"),
                  //     //     value: ClientRole.Broadcaster,
                  //     //     groupValue: role,
                  //     //     onChanged: (ClientRole? value) {
                  //     //       setState(() {
                  //     //         role = value;
                  //     //       });
                  //     //     }),
                  //     // RadioListTile(
                  //     //     title: const Text("Audience"),
                  //     //     value: ClientRole.Audience,
                  //     //     groupValue: role,
                  //     //     onChanged: (ClientRole? value) {
                  //     //       setState(() {
                  //     //         role = value;
                  //     //       });
                  //     //     }),
                  //     // ElevatedButton(
                  //     //   onPressed: () {},
                  //     //   style: ElevatedButton.styleFrom(
                  //     //       minimumSize: const Size(double.infinity, 40)),
                  //     //   child: const Text('Join'),
                  //     // ),

                  //   ],
                  // ),
                  ,
                  const SizedBox(
                    height: 15,
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  // Future<void> onJoin() async {
  //   setState(() {
  //     _channelController.text.isEmpty
  //         ? _validateError = true
  //         : _validateError = false;
  //   });

  //   if (_channelController.text.isNotEmpty) {
  //     await _handleCameraandMic(Permission.camera);
  //     await _handleCameraandMic(Permission.microphone);
  // ignore: use_build_context_synchronously
  //     await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CallPage(
  //             channelName: _channelController.text,
  //             role: role,
  //           ),
  //         ));
  //   }
  // }

}

Widget channelNamePicker(
    BuildContext context,
    Size deviceSize,
    TextEditingController channelNameController,
    TokenService tokenService,
    String uid,
    String userName) {
  return Container(
    height: deviceSize.height * 0.5,
    alignment: Alignment.topCenter,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Text(
            'Enter your Channel Name ,',
            style: AppTextStyles.heading.copyWith(fontSize: 18),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: deviceSize.width * 0.87,
            child: TextFormField(
              controller: channelNameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.people_alt, color: Colors.grey[600]),
                hintText: 'Channel Name',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(28),
                  ),
                  borderSide: BorderSide(width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(28),
                  ),
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).primaryColor),
                ),
              ),
              keyboardType: TextInputType.text,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Enter Your Channel Name";
                }
              },
              onSaved: (value) {
                //function
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SolidButton(
              onPressed: () async {
                if (channelNameController.text.isNotEmpty) {}
                String? token = await tokenService.fetchToken(
                    1306, channelNameController.text, 1);
                await _handleCameraandMic(Permission.camera);
                await _handleCameraandMic(Permission.microphone);
                final provider = Provider.of<FirebaseOperationsProvider>(
                        context,
                        listen: false)
                    .addEventToFirestore(
                        userName, channelNameController.text, token!, uid);
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CallPage(
                    channelName: channelNameController.text,
                    role: ClientRole.Broadcaster,
                    token: token,
                  ),
                ));
              },
              label: "Stream your Channel",
              deviceSize: deviceSize,
              labelTextStyle: AppTextStyles.solidButttonTextStyle,
              icon: Icons.broadcast_on_personal)
        ],
      ),
    ),
  );
}

double convert(String hexString) {
  String hexStringPadded = hexString.padLeft(16, '0');

  return (ByteData(8)
        ..setInt32(0, int.parse(hexStringPadded.substring(0, 8), radix: 16))
        ..setInt32(4, int.parse(hexStringPadded.substring(8, 16), radix: 16)))
      .getFloat64(0);
}

Widget onGoingEventsSheet(
    BuildContext context,
    Size deviceSize,
    TextEditingController channelNameController,
    TokenService tokenService,
    String uid) {
  // int _uid = int.parse(uid);
  return Container(
    height: deviceSize.height * 0.7,
    alignment: Alignment.topCenter,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Text(
            'OnGoing Events ,',
            style: AppTextStyles.heading.copyWith(fontSize: 18),
          ),
          const SizedBox(
            height: 8,
          ),
          Consumer<FirebaseOperationsProvider>(
            builder: (context, value, child) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('onGoingEvents')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return SizedBox(
                      height: deviceSize.height * 0.5,
                      child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(documents[index]['channelName']),
                            subtitle: Text(
                                'Hosted By : ${documents[index]['username']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_circle_right),
                              onPressed: () async {
                                String channelName =
                                    documents[index]['channelName'];
                                String? audienceToken;
                                await tokenService
                                    .fetchToken(0, channelName, 2)
                                    .then((value) => audienceToken = value);
                                print("audience token --> $audienceToken");
                                await _handleCameraandMic(Permission.camera);
                                await _handleCameraandMic(
                                    Permission.microphone);
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => CallPage(
                                    channelName: documents[index]
                                        ['channelName'],
                                    token: audienceToken,
                                    role: ClientRole.Audience,
                                  ),
                                ));
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    const Center(
                      child: Text("No OnGoing Events"),
                    );
                  }
                  return const Text('Some Error Ocurred');
                },
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );
}

Future<void> _handleCameraandMic(Permission permission) async {
  final status = await permission.request();
  log(status.toString());
}
