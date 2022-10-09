import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_operations.dart';
import '../screens/call.dart';
import '../services/token_service.dart';
import '../utils/themes/app_text_styles.dart';
import '../utils/themes/named_colors.dart';

class OnGoingEventsWidget extends StatelessWidget {
  final BuildContext context;
  final Size deviceSize;
  final TextEditingController channelNameController;
  final TokenService tokenService;
  final String uid;

  const OnGoingEventsWidget(
      {super.key,
      required this.context,
      required this.deviceSize,
      required this.channelNameController,
      required this.tokenService,
      required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceSize.height * 0.7,
      decoration: const BoxDecoration(color: NamedColors.bgColorDark),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
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
                style: AppTextStyles.heading
                    .copyWith(fontSize: 18, color: NamedColors.dimWhite),
              ),
              const Divider(
                thickness: 2,
                endIndent: 200,
                color: NamedColors.shinyPurple,
              ),
              const SizedBox(
                height: 8,
              ),
              Consumer<FirebaseOperationsProvider>(
                builder: (context, value, child) {
                  // Retrieves current on-going streams and display them in the widget
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
                              if (documents.isEmpty) {
                                return Text(
                                  "No OnGoing LiveStreams",
                                  style: AppTextStyles.heading
                                      .copyWith(color: NamedColors.white),
                                );
                              }
                              if (documents.length == 0) {
                                return Text("No OnGoing LiveStreams",
                                    style: AppTextStyles.heading
                                        .copyWith(color: NamedColors.white));
                              }
                              return Card(
                                elevation: 20,
                                shadowColor: NamedColors.shinyPurple,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: NamedColors.shinyPurple),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: NamedColors.cardColorbgColorDark),
                                  child: ListTile(
                                    title: Text(
                                      documents[index]['channelName'],
                                      style: TextStyle(
                                          color: NamedColors.white
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Hosted By : ${documents[index]['username']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            NamedColors.white.withOpacity(0.6),
                                      ),
                                    ),
                                    trailing: ElevatedButton.icon(
                                      label: const Text("JOIN"),
                                      icon:
                                          const Icon(Icons.arrow_circle_right),
                                      onPressed: () async {
                                        showSnackBar(context,
                                            "Connecting you to the Stream...");
                                        String channelName =
                                            documents[index]['channelName'];
                                        String? audienceToken;
                                        await tokenService
                                            .fetchToken(0, channelName, 2)
                                            .then((value) =>
                                                audienceToken = value);
                                        print(
                                            "audience token --> $audienceToken");
                                        await _handleCameraandMic(
                                            Permission.camera);
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
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        const Center(
                          child: Text(
                            "No OnGoing Events",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return const Text(
                        'Some Error Ocurred',
                        style: TextStyle(color: NamedColors.white),
                      );
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
      ),
    );
  }
}

Future<void> _handleCameraandMic(Permission permission) async {
  final status = await permission.request();
  log(status.toString());
}

// shows SnackBar
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
