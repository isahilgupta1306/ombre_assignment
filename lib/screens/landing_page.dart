import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../providers/google_signin.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _channelController = TextEditingController();

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call App'),
      ),
    );
  }
}

class LandingPage1 extends StatelessWidget {
  const LandingPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Logged In"),
          actions: [
            IconButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                icon: const Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Go Live")),
            const Divider(),
            const Text("Current Ongoing Streams"),
          ],
        ));
  }
}
