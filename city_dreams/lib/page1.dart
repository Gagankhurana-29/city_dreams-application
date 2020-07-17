import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:social_distancing/page2.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool showspinner = false;
  void onError()
  {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context)=>AlertDialog(
          title: Text("Something went wrong"),
          actions: <Widget>[
            FlatButton(
              onPressed: ()
              {
                Navigator.pop(context);
                setState(() {
                  showspinner=false;
                });
              },
              color: Colors.black,
              child: Text("Retry",
                style: TextStyle(
                    color:Colors.white
                ),
              ),
            )
          ],
        )
    );
  }
 final textcontroller = TextEditingController();
 final textcontroller1 = TextEditingController();
  FirebaseUser user;
  FirebaseUser checkuser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn= GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

     user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Page2(user)));
    setState(() {
      showspinner=false;
    });
    return user;
  }

  Future<bool> _phone(String number) async{
    await _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential)
        async{
          AuthResult result=await _auth.signInWithCredential(credential);
          user=result.user;
          print(user.phoneNumber);
          Navigator.push(context, MaterialPageRoute (builder: (context)=> Page2(user)));
          setState(() {
            showspinner=false;
          });
        },
        verificationFailed: (AuthException exception)
        {
          showDialog(
            context: context,
          barrierDismissible: true,
          builder: (context)=>AlertDialog(
            title: Text("Something went wrong"),
            actions: <Widget>[
              FlatButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  setState(() {
                    showspinner=false;
                  });
                },
                color: Colors.black,
                child: Text("Retry",
                style: TextStyle(
                  color:Colors.white
                ),
                ),
              )
            ],
          )
          );
        },
        codeSent: (String verificationId, [int forceResendingToken])
        {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context){
              return AlertDialog(
                   title: Text("Enter the OTP"),
                   content: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                       TextField(
                         controller: textcontroller,
                       )
                     ],
                   ),
                actions: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: ()async
                    {
                      final code = textcontroller.text.trim();
                      AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                      AuthResult result = await _auth.signInWithCredential(credential);
                      user = result.user;
                      print(user.phoneNumber);
                      setState(() {
                        showspinner=false;
                      });
                      Navigator.push(context , MaterialPageRoute(builder: (context)=>Page2(user)));
                    },
                  )
                ],
              );
            }
          );
        },
        codeAutoRetrievalTimeout: null);
  }
  @override
  void initState() {
    check();// TODO: implement initState
    super.initState();
  }

  Future<FirebaseUser> check()async
  {
    checkuser=await _auth.currentUser();
     if(checkuser!=null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Page2(checkuser)));
      }
  }

  Future<bool> onbackbutton()
  {
    showDialog(context: context,
    builder: (context)=> AlertDialog(
      title: Text("Do you really want to exit ?"),
      actions: <Widget>[
        FlatButton(
          onPressed: ()
          {
            Navigator.pop(context,true);
          },
          color: Colors.black,
          child: Text(
            "Yes",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        FlatButton(
          onPressed: ()
          {
            Navigator.pop(context,false);
          },
          color: Colors.black,
          child: Text(
            "No",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        )
      ],
    )
    );
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onbackbutton,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          inAsyncCall: showspinner,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child : Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Hero(
                            tag: 'first',
                            child: CircleAvatar(
                              radius:35.0,
                              backgroundImage: AssetImage('images/first.png'),
                            ),
                          ),
                        ),
                        SizedBox(width: 170.0),
                        Text(
                          "Sign in ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    )
                  )
                ),
                Expanded(
                  flex:6,
                      child: Container(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.email,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                  SizedBox(
                                    width: 40.0
                                  ),
                                  Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                      size:40.0,
                                  )
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: TextField(
                                controller: textcontroller1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter Your Number",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic
                                  )
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: ()
                              {
                                setState(() {
                                  showspinner=true;
                                });
                                _phone(textcontroller1.text);
                                setState(() {
                                });
                                textcontroller1.clear();
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Get  OTP",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 20.0),
                              child: FlatButton(
                                onPressed: ()
                                {
                                  setState(() {
                                    showspinner=true;
                                  });
                                  _signIn().then((FirebaseUser user)=>print(user)).catchError((e)=> onError());
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  );
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                    title: Text(
                                      "Sign in with Gmail",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
