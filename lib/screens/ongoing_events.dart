import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ombre_assignment/services/token_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_operations.dart';
import '../utils/themes/app_text_styles.dart';
import 'call.dart';

class OnGoingEventsPage extends StatefulWidget {
  final channelNameController = TextEditingController();
  late TokenService tokenService;
  OnGoingEventsPage({super.key});

  @override
  State<OnGoingEventsPage> createState() => _OnGoingEventsPageState();
}

class _OnGoingEventsPageState extends State<OnGoingEventsPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: deviceSize.height * 0.5,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(documents[index]['channelName']),
                              subtitle: Text(
                                  'Hosted By : ${documents[index]['username']}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_circle_right),
                                onPressed: () async {
                                  await _handleCameraandMic(Permission.camera);
                                  await _handleCameraandMic(
                                      Permission.microphone);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CallPage(
                                      token: documents[index]['channelToken'],
                                      role: ClientRole.Audience,
                                    ),
                                  ));
                                },
                              ),
                            );
                          },
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
      ),
    );
  }
}

Future<void> _handleCameraandMic(Permission permission) async {
  final status = await permission.request();
  log(status.toString());
}
