import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Page2 extends StatefulWidget {
  final FirebaseUser user1;
  Page2(this.user1);
  @override
  _Page2State createState() => _Page2State();
}
class _Page2State extends State<Page2> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  static List<Map> cs=[ {"Agra":"To see Taj Mahal"},{"Goa":"Visit bagga beach"}];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
   String info,city ='City';
   String notificationtitle,notificationbody;
   FirebaseUser user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    setState(() {
           getuser();
           getlocation();
           initializing();
    });
    super.initState();
  }

  void backgroundfetchHeadlessTask()async
  {

  }
  void checklocation()
  {
    var currentCity=("($city)");
    for(var key in cs)
      {
        var userCity= key.keys.toString();
        if(userCity == currentCity)
          {
            notificationtitle=currentCity;
            notificationbody=key.values.toString();
            showNotification();
//            setState(() {
//              cs.remove(key);
//            });
          }
        else
          {
            print("not matched");
          }
      }
  }

  void initializing()async
  {
    androidInitializationSettings = AndroidInitializationSettings('appicon');
    iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotifications);
    initializationSettings= InitializationSettings(androidInitializationSettings,iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelelectNotification);
  }

  void showNotification()async{
    await notifications();
  }

  Future<void> notifications()async
  {
    AndroidNotificationDetails androidNotificationDetails= AndroidNotificationDetails(
      'channel id','Channel title', 'channel body',
      priority: Priority.High,
      importance: Importance.Max,
      ticker: 'test'
    );
    IOSNotificationDetails iosNotificationDetails= IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails,iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show( 0 ,notificationtitle,notificationbody,notificationDetails);
  }

  Future<void> onSelelectNotification(String payLoad)
  {
    if(payLoad != null)
      {
        print(payLoad);
      }
  }

  Future onDidRecieveLocalNotifications(int id, String title, String body ,String payLoad)async
  {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("okay"),
          isDefaultAction: true,
          onPressed: ()
          {
            print("");
          },
        )
      ],
    );
  }

  Future<void> getlocation()async
  {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print(position.latitude.toString() + "," + position.longitude.toString());
       http.Response response=await http.get('https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=3bee2a6971554dfe76beeac640907f90');
       if(response.statusCode==200) {
         var decodeddata = jsonDecode(response.body);
         setState(() {
            city = decodeddata['name'];
           print(city);
           checklocation();
         });
       }
    }
    catch(e)
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
  }
  Future<FirebaseUser> getuser()async
  {
    //user = await _auth.currentUser();
    setState(() {
      if(widget.user1.phoneNumber!=null)
        {
         info=widget.user1.phoneNumber;
        }
      else {
        info = widget.user1.email;
      }
    });
  }
   Future<bool> onbackbutton()
   {
     showDialog(
       context: context,
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
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              showDialog(
                  context: context,
                  builder: (context)=>AlertDialog(
                    shape: CircleBorder(
                      side: BorderSide.none
                    ),
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Add to List",
                            style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                            ),
                            ),
                    SizedBox(
                        height: 10.0,
                    ),
                    TextField(
                            controller: controller1,
                            decoration: InputDecoration(
                              hintText: "Enter the city",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0
                              )
                            ),
                          ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextField(
                              controller: controller2,
                              decoration: InputDecoration(
                                  hintText: "Enter the task",
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                      FlatButton(
                        onPressed: ()
                        {
                            print("button tapped");
                            cs.add({controller1.text:controller2.text});
                            controller1.clear();
                            controller2.clear();
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        color: Colors.black,
                      )
                      ],
                    ),
              );
            },
            backgroundColor: Colors.white,
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 35.0,
          ),
          ),
          backgroundColor: Colors.black,
         body: Column(
           children: <Widget>[
             Row(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(top:40.0,left:70.0,bottom: 12.0),
                   child: Icon(Icons.gps_fixed,
                   size: 25.0,
                   color: Colors.white,),
                 ),
                 SizedBox(width: 30.0),
                 Padding(
                   padding: const EdgeInsets.only(top:25.0),
                   child: Text(
                     "$city",
                     textAlign:TextAlign.center,
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 35.0,
                       fontStyle: FontStyle.italic,
                       fontWeight: FontWeight.w600
                     ),
                   ),
                 ),
               ],
             ),
             SizedBox(
               height: 30.0,
               width: MediaQuery.of(context).size.width-100.0,
               child: Divider(
                 thickness: 3.0,
                 color: Colors.white,
               ),
             ),
             SizedBox(
               height: 70.0,
             ),
             CarouselSlider(
                 items: cs.map((item)=>Container(
                   width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: ListTile(
                            leading: Icon(Icons.location_city,
                            size: 25.0,
                            color: Colors.black,),
                            title: Text(item.keys.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.0,),
                        Text("Task",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                        ),
                            ),
                        SizedBox(
                          height:15.0,
                          width: 60.0,
                          child: Divider(
                            color: Colors.black,
                            thickness: 1.5,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        ListTile(
                          leading: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                          title: Text(
                            item.values.toString(),
                          ),
                        )
                      ],
                    ),
                 )
                 ).toList(),
                 options: CarouselOptions(
                   height: 300.0,
                   enlargeCenterPage: true,
                   viewportFraction: 0.7,
                 ),
             ),
           ],
         )
        ),
      ),
    );
  }
}

