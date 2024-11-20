import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/responsive/mobile_screen_layout.dart';
import 'package:instagram_app/responsive/responsive_layout.dart';
import 'package:instagram_app/responsive/web_screen_layout.dart';
import 'package:instagram_app/screens/login_screen.dart';

import 'package:instagram_app/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBOKGqy39pF6kMcj3LTRYymRKVCZFyscLw",
        appId: "1:1007118840094:web:7a55194e98d2e41026590f",
        messagingSenderId: "1007118840094",
        projectId: "instagramapp-dbe8a",
        storageBucket: "instagramapp-dbe8a.firebasestorage.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'instagram_app',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, Snapshot) {
          if (Snapshot.connectionState == ConnectionState.active) {
            if (Snapshot.hasData) {
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (Snapshot.hasError) {
              return Center(
                child: Text('${Snapshot.error}'),
              );
            }
          }
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
