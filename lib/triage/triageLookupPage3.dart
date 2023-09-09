import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../dashboard/DashboardPage.dart';
import '../drawer/drawerElement.dart';
import '../utilities.dart';

class TriageLookupPage3 extends StatefulWidget {
  @override
  _TriageLookupPage3 createState() => _TriageLookupPage3();
}

class _TriageLookupPage3 extends State<TriageLookupPage3> {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Transient Order',style: TextStyle(
                    fontSize: 18,fontWeight: FontWeight.bold
                  ),),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Memo#',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      Text('Transient Date',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Status',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
                      Text('Condition',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(width: 120,),
                      Text('Sku',textAlign:TextAlign.left,style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Product Name',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Supplier',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
                      Text('Order Qty:',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(width: 80,),
                      Text('Received Qty:',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text('Triage:',style: TextStyle(
                      fontSize: 18,fontWeight: FontWeight.bold
                  ),),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Memo#',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Triage Date',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Status',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Requested By:',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Approved By:',textAlign:TextAlign.left,style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Priority',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Func & Grading',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Quality Check',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text('ASN Information:',style: TextStyle(
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
                          'Carton',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Qty',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 2,
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
                              width: 5,
                            ),
                            SizedBox(
                              width: 70,
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
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
                  Text('Disposition:',style: TextStyle(
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
                          'Memp#',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Disposed Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 2,
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
                              width: 5,
                            ),
                            SizedBox(
                              width: 70,
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
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
}
