import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zero_to_mastery/pages/home.dart';
import 'package:zero_to_mastery/pages/sign_in.dart';
import 'package:zero_to_mastery/providers/user_provider.dart';

final firebaseAppProvider = Provider<FirebaseApp>((ref) {
  final firebaseApp = Firebase.apps.firstWhere(
    (app) => app.name == '[DEFAULT]',
    orElse: () => throw Exception('No Firebase app found'),
  );
  return firebaseApp;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCXEo1lmqgVXVZTSBI6NVjX1NAsl66vfmo",
        appId: "1:905779153032:android:1714005574707370fbf73d",
        messagingSenderId: "905779153032",
        projectId: "dominiks-twitter",
        storageBucket: "dominiks-twitter.appspot.com",
      ),
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      throw e;
    }
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ref.read(userProvider.notifier).login(snapshot.data!.email!);
              return const Home();
            }
            return const SignIn();
          }),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              centerTitle: true)),
      debugShowCheckedModeBanner: false,
    );
  }
}
