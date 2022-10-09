import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ombre_assignment/widgets/custom_solid_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_operations.dart';
import '../screens/call.dart';
import '../services/token_service.dart';
import '../utils/themes/app_text_styles.dart';
import '../utils/themes/named_colors.dart';

class GoLiveWidget extends StatelessWidget {
  final BuildContext context;
  final Size deviceSize;
  final TextEditingController channelNameController;
  final TokenService tokenService;
  final String uid;
  final String userName;

  const GoLiveWidget(
      {super.key,
      required this.context,
      required this.deviceSize,
      required this.channelNameController,
      required this.tokenService,
      required this.uid,
      required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: NamedColors.bgColorDark),
      height: deviceSize.height * 0.65,
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
              style: AppTextStyles.heading.copyWith(
                  fontSize: 18, color: NamedColors.white.withOpacity(0.8)),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: deviceSize.width * 0.87,
              child: TextFormField(
                style: TextStyle(color: NamedColors.white.withOpacity(0.9)),
                controller: channelNameController,
                decoration: InputDecoration(
                  fillColor: NamedColors.cardColorbgColorDark,
                  filled: true,
                  prefixIcon: const Icon(Icons.people_alt, color: Colors.grey),
                  hintText: 'Channel Name',
                  hintStyle: const TextStyle(color: NamedColors.white),
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
                  if (channelNameController.text.isNotEmpty) {
                    String? token = await tokenService.fetchToken(
                        1306, channelNameController.text, 1);
                    await _handleCameraandMic(Permission.camera);
                    await _handleCameraandMic(Permission.microphone);
                    showSnackBar(context, "Setting you up to go Live...");
                    Provider.of<FirebaseOperationsProvider>(context,
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
                  }
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
}

Future<void> _handleCameraandMic(Permission permission) async {
  final status = await permission.request();
  log(status.toString());
}

// shows SnackBar
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
