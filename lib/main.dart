import 'package:ems/config/app_routing.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCMXAZqSzIAnevCpAW3wkknQhbgzTJBzZo",
        appId: "1:584446124792:android:6db6a6caf5f6e99312d10d",
        messagingSenderId: "584446124792",
        projectId: "emp-mng-sys-a0d73",
        storageBucket: "emp-mng-sys-a0d73.appspot.com"),
  );
  runApp(const MyApp());
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const SplashScreen(),
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: ThemeConstant.appBarColor,
          iconTheme: IconThemeData(
            color: ThemeConstant.iconTheme,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
