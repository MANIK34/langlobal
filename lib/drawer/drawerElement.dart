import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../transientSearch/transientOrderSearch.dart';


class DrawerElement extends StatefulWidget {
  @override
  _DrawerElement createState() => _DrawerElement();
}

class _DrawerElement extends State<DrawerElement> {

  String userName="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(

            child:ListView(
              padding: const EdgeInsets.all(0.0),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  color: Colors.blue.shade400,
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 60),
                          width: 200,
                          height: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/lan_global_icon.jpeg'),
                              )),
                        ),
                        Text(userName,style: const TextStyle(
                            color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,
                            fontSize: 16),),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Menu',
                    style: TextStyle(fontSize: 16,color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage('')),
                    );
                  },
                ),
                ListTile(
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Transient Receive',
                    style: TextStyle(fontSize: 16,color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransientOrderSearchPage('3')),
                    );
                  },
                ),
                ListTile(
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Change Company',
                    style: TextStyle(fontSize: 16,color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),
            Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children:   <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: ListTile(
                      minLeadingWidth : 2,
                      leading: const FaIcon(FontAwesomeIcons.lock,color: Colors.black,size: 16,),
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16,color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        _showMyDialog();
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to logout from app?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage('')),
                );
               // exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  void getUserInfo() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      userName = myPrefs.getString("userName")!;
      print(userName);
    });
  }
}
//Copyrights © 2022 | All Rights Reserved by Department of Finance.\n
