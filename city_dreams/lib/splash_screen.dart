import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_distancing/page1.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   // TODO: implement initState
    super.initState();
    Timer(Duration(seconds:7), ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => Page1())));
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'first',
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/first.png'),
                      radius: 60.0,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text("City Dreams",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50.0,),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height:20.0),
                  Text("   You write \n  We remind.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ))
                ],
              ),
            ],
          ),
        ),
    );
  }
}
