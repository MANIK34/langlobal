import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/triage/triageLookupPage3.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../dashboard/DashboardPage.dart';
import '../drawer/drawerElement.dart';
import '../utilities.dart';

class TriageLookupPage2 extends StatefulWidget {

  var jsonResponse;
  var memoNumber;
  TriageLookupPage2(this.jsonResponse,this.memoNumber,
      {Key? key}) : super(key: key);

  @override
  _TriageLookupPage2 createState() => _TriageLookupPage2(this.jsonResponse,this.memoNumber);
}

class _TriageLookupPage2 extends State<TriageLookupPage2> {

  var jsonResponse;
  var memoNumber;
  _TriageLookupPage2(this.jsonResponse,this.memoNumber);

  BuildContext? _context;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        onPressed: () {

        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Visibility(
            visible: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[submitButton],
            ),
          )
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Triage Lookup',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
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
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                  child: const FaIcon(
                    FontAwesomeIcons.home,
                    color: Colors.white,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardPage('')),
                    );
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
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                        child: Text(
                          'S.No.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                          'Memo#',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Priority',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Sku',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Status',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Func & Grading',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: jsonResponse['triageList'].length,
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
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                           GestureDetector(
                             onTap: (){
                               buildShowDialog(context);
                               callMemoInfoApi();
                             },
                             child:  SizedBox(
                               width: 70,
                               child: Text(
                                 jsonResponse['triageList'][index]['memoNumber'].toString(),
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,color: Colors.blue,
                                     fontSize: 12,decoration: TextDecoration.underline),
                               ),
                             ),
                           ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                  jsonResponse['triageList'][index]['priority'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                  jsonResponse['triageList'][index]['sku'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                jsonResponse['triageList'][index]['status'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                jsonResponse['triageList'][index]['functionAndGrading'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
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

  void callMemoInfoApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/triage/v1/"+memoNumber;
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response =
    await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriageLookupPage3(jsonResponse)),
          );
        } else {
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print("error message ::" + e.toString());
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
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
}
