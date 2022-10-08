import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ombre_assignment/providers/firebase_operations.dart';
import 'package:ombre_assignment/providers/google_signin.dart';
import 'package:ombre_assignment/screens/home.dart';
import 'package:ombre_assignment/utils/themes/named_colors.dart';
import 'package:ombre_assignment/utils/themes/pallette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

late final SharedPreferences prefs;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => FirebaseOperationsProvider()),
      ],
      child: MaterialApp(
        title: 'Stream App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // scaffoldBackgroundColor: NamedColors.bgColorDark,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            primarySwatch: Palette.brandColor),
        home: const HomePage(),
      ),
    );
  }
}
