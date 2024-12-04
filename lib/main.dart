import 'package:flutter/material.dart';
import 'views/auth_page_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: Text("Couldn't connect to Firebase")),
              ),
            );
          }
          //Once complete, show application
          if (snapshot.connectionState == ConnectionState.done){
            return const MaterialApp(
              home: AuthPage(),
            );
          }
          //loading indicator
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );

        });
  }
}
