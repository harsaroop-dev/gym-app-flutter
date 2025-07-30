// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:gym_app/providers/userdata_provider.dart';
// import 'package:gym_app/screens/loading.dart';
// import 'firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:gym_app/screens/login.dart';
// import 'package:gym_app/screens/tabs.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gym_app/providers/user_vitals_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(ProviderScope(
//     child: const MyApp(),
//   ));
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:gym_app/providers/userdata_provider.dart';
import 'package:gym_app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load the .env file

  final FirebaseOptions firebaseOptions;

  if (defaultTargetPlatform == TargetPlatform.android) {
    firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env['ANDROID_API_KEY']!,
      appId: dotenv.env['ANDROID_APP_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
      storageBucket: dotenv.env['STORAGE_BUCKET']!,
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env['IOS_API_KEY']!,
      appId: dotenv.env['IOS_APP_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
      storageBucket: dotenv.env['STORAGE_BUCKET']!,
      androidClientId: dotenv.env['ANDROID_CLIENT_ID']!,
      iosClientId: dotenv.env['IOS_CLIENT_ID']!,
      iosBundleId: dotenv.env['IOS_BUNDLE_ID']!,
    );
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(ProviderScope(
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Stream<User?> userStream =
      FirebaseAuth.instance.authStateChanges().asBroadcastStream();

  StreamSubscription? ss;

  @override
  void initState() {
    super.initState();
    // ref.read(userVitalsProvider.notifier).initDataFromLocalStorage();
    ss = userStream.listen((user) {
      print(user?.displayName);

      ref.read(userDataProvider.notifier).addUser(user);
    });
  }

  @override
  void dispose() {
    super.dispose();
    ss?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: userStream,
          builder: (context, snapshot) {
            // StreamController<int> sc = StreamController();

            // Stream<int> s = sc.stream;

            // StreamSubscription ss = s.listen((event) {
            //   print(event);
            // });

            // sc.add(1);
            // await for 5 secs;
            // sc.add(4);
            // sc.add(10);

            // ss.cancel();

            // ref.read(userDataProvider.notifier).addUser(snapshot.data);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }

            if (snapshot.hasData) {
              return const TabsScreen();
            }

            return const LoginScreen();
          }),
    );
  }
}
