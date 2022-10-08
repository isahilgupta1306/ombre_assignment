import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ombre_assignment/providers/firebase_operations.dart';
import 'package:ombre_assignment/services/session_manager.dart';
import 'package:ombre_assignment/utils/utils.dart';
import 'package:provider/provider.dart';

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRole? role;
  final String? token;
  const CallPage({super.key, this.channelName, this.role, required this.token});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool disableCam = false;
  bool viewPanel = false;
  late RtcEngine _engine;
  SessionManager prefs = SessionManager();
  int userCount = 0;

  @override
  void dispose() {
    users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    print('token from call page : ${widget.token}');
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add("APP_ID is Missing");
        _infoStrings.add("Agora Engine not starting");
      });
      return;
    }
    //creating an instance of the Agora engine
    _engine = await RtcEngine.create(APP_ID);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);
    _addAgoraEventHandler();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(height: 1080, width: 1920);
    await _engine.setVideoEncoderConfiguration(configuration);

    await _engine.joinChannel(widget.token, widget.channelName!, null, 0);
    _engine.enableLocalVideo(true);
  }

  void _addAgoraEventHandler() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (err) {
        setState(() {
          final info = 'Error ---> $err';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        final info = " Join Channel $channel,uid: $uid";
        print("Joined channel successfully");
        _infoStrings.add(info);
      },
      leaveChannel: (stats) {
        setState(() {
          const info = 'Leaved Channel';
          _infoStrings.add(info);
          users.clear();
        });
      },
      userJoined: (remoteUid, elapsed) {
        setState(() {
          userCount++;
          final info = 'User joined , UID : $remoteUid';
          _infoStrings.add(info);
          users.add(remoteUid);
        });
      },
      userOffline: (remoteUid, elapsed) {
        setState(() {
          final info = 'User : $remoteUid is Offline ';
          _infoStrings.add(info);
          users.remove(remoteUid);
          userCount--;
        });
      },
      firstRemoteVideoFrame: (remoteUid, width, height, elapsed) {
        final info =
            'First Remote Video Frame : of $remoteUid is $width x $height ';
        _infoStrings.add(info);
      },
    ));
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];

    if (widget.role == ClientRole.Broadcaster) {
      list.add(const rtc_local_view.SurfaceView());
    }

    for (var uid in users) {
      list.add(rtc_remote_view.SurfaceView(
        channelId: widget.channelName!,
        uid: uid,
      ));
    }
    final views = list;
    return Column(
        children: List.generate(
      views.length,
      (index) => Expanded(
        child: views[index],
      ),
    ));
  }

  Widget _toolBar() {
    if (widget.role == ClientRole.Audience) {
      return const SizedBox();
    }
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        RawMaterialButton(
          onPressed: () {
            setState(() {
              muted = !muted;
            });
            _engine.muteLocalAudioStream(muted);
          },
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: muted ? Colors.blueAccent : Colors.white,
          padding: const EdgeInsets.all(12),
          child: Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: muted ? Colors.white : Colors.blueAccent,
          ),
        ),
        RawMaterialButton(
          onPressed: (() async {
            String id;
            final provider =
                Provider.of<FirebaseOperationsProvider>(context, listen: false);
            await prefs.getUserData().then((value) {
              print('inside red call button');
              id = value['auth_token'];
              provider.deleteData(id);
            });
            _engine.leaveChannel();

            Navigator.pop(context);
          }),
          shape: const CircleBorder(),
          fillColor: Colors.red,
          elevation: 2,
          padding: const EdgeInsets.all(15),
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
            size: 35,
          ),
        ),
        RawMaterialButton(
          onPressed: () {
            _engine.switchCamera();
          },
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.blueAccent,
          padding: const EdgeInsets.all(12),
          child: const Icon(
            Icons.switch_camera,
            color: Colors.white,
          ),
        ),
        RawMaterialButton(
          onPressed: () {
            setState(() {
              disableCam = !disableCam;
            });
            _engine.muteLocalVideoStream(disableCam);
          },
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: disableCam ? Colors.blueAccent : Colors.white,
          padding: const EdgeInsets.all(12),
          child: Icon(
            disableCam ? Icons.videocam_off : Icons.videocam,
            color: disableCam ? Colors.white : Colors.blueAccent,
          ),
        ),
      ]),
    );
  }

  Widget _panel() {
    return Visibility(
        visible: viewPanel,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                itemCount: _infoStrings.length,
                reverse: true,
                itemBuilder: (context, index) {
                  if (_infoStrings.isEmpty) {
                    return const Text("No Realtime status messages");
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _infoStrings[index],
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ))
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState

    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Agora Video Call"),
          centerTitle: true,
          actions: [
            Text("P count : ${userCount.toString()}"),
            IconButton(
              onPressed: () {
                setState(() {
                  viewPanel = !viewPanel;
                });
              },
              icon: const Icon(Icons.info_outline),
            ),
          ]),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            _viewRows(),
            _panel(),
            _toolBar(),
          ],
        ),
      ),
    );
  }
}
