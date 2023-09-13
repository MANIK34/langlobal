import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../drawer/drawerElement.dart';
import '../utilities.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPage createState() => _UserInfoPage();
}

class _UserInfoPage extends State<UserInfoPage> {
  var userName="";
  BuildContext? _context;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  var userInfoData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    if(!Utilities.ActiveConnection){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _showToast('No internet connection found!');
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        buildShowDialog(context);
      });
      callUserInfoApi();
    }

  }

  void getUserInfo() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    userName= myPrefs.getString("userName")!;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 200,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'User Information',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                  child: Image.asset(
                    'assets/icon_back.png',
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
        drawer: DrawerElement(),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(userName!,style: TextStyle(
                      fontSize: 18,fontWeight: FontWeight.bold
                  ),),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 5,),
                  if(userInfoData!=null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Registerd Email: '+userInfoData['sessionInfo']['email'],style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      const SizedBox(height: 5,),
                      Text('Member Since: '+userInfoData['sessionInfo']['userCreatedDate'].toString().substring(0,10),style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 15,),
                      Text('Roles Assigned:',style: TextStyle(
                          fontSize: 18,fontWeight: FontWeight.bold
                      ),),
                      Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                            child: Text(
                              "S.No.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              'Role Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: userInfoData['sessionInfo']['assignedRoles'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color:
                            index % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                            height: 35,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    " "+(index+1).toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    userInfoData['sessionInfo']['assignedRoles'][index]['roleName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15,),
                      Text('Session Logs:',style: TextStyle(
                          fontSize: 18,fontWeight: FontWeight.bold
                      ),),
                      Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                            child: Text(
                              "S.No.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 130,
                            child: Text(
                              'Signed-in Datetime',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              'Signed-out Datetime',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),


                        ],
                      ),
                      SizedBox(height: 5,),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: userInfoData['sessionInfo']['sessions'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color:
                            index % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                            height: 35,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    " "+(index+1).toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    userInfoData['sessionInfo']['sessions'][index]['sessionStartDatetime'].toString().substring(0,19).replaceAll("T", " "),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                      userInfoData['sessionInfo']['sessions'][index]['sessionEndDatetime'].toString().substring(0,19).replaceAll("T", " "),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              )
            ),
          ),
        ));
  }



  buildShowDialog(BuildContext context) {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context=context;
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

  }


  void callUserInfoApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/auth/v1/users/"+userName;
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var response =
    await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      userInfoData=jsonResponse;
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){

        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print("error message ::"+e.toString());
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
    setState(() {});
  }

  void _showToast(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: "OK",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ));
  }
}
