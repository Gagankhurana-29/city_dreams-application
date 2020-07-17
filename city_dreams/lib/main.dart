import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

FirebaseAuth auth =FirebaseAuth.instance;
FirebaseUser user;
void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return(
       MaterialApp(
      home: SplashScreen(),
   )
   );
  }
}
