import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/login.dart';
import 'package:langlobal/warehouseAllocation/skuLookup/skuLookupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locationLookup/locationLookupPage.dart';
import '../select_company.dart';
import '../transientSearch/transientOrderSearch.dart';
import '../warehouseAllocation/inventoryLookup/inventoryLookupPage.dart';


class DrawerElement extends StatefulWidget {
  @override
  _DrawerElement createState() => _DrawerElement();
}

class _DrawerElement extends State<DrawerElement> {

  String userName="";
  String userType="";
  bool visibleCompany=false;
  final double coverHeight = 280;
  final double profileHeight = 144;
  String companyLogo="http://via.placeholder.com/350x150";

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
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 0, top: 80),
                          width: 160,
                          height: 45,
                          child:  buildProfileImage(),
                        ),
                        SizedBox(height: 10,),
                        Text(userName,style: const TextStyle(
                            color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal,
                            fontSize: 16),),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Home',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage('')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Transient Receive',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransientOrderSearchPage('3')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Location Lookup',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationLookupPage('')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'SKU Lookup',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SkuLookupPage('')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'IMEI Lookup',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryLookupPage('')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Fulfillment Lookup',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryLookupPage('')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  minLeadingWidth : 2,
                  //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                  title: const Text(
                    'Carton Lookup',
                    style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryLookupPage('')),
                    );
                  },
                ),
                Divider(
                    color: Colors.black
                ),
                Visibility(
                  visible: visibleCompany,
                    child:Column(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity(vertical: -4),
                          minLeadingWidth : 2,
                          //leading: const FaIcon(FontAwesomeIcons.home,color: Colors.black,size: 16,),
                          title: const Text(
                            'Change Company',
                            style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectCompany('')),
                            );
                          },
                        ),
                        Divider(
                            color: Colors.black
                        ),
                      ],
                    )
                )
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
                        style: TextStyle(fontSize: 16,color: Colors.black,fontFamily: 'Montserrat',fontWeight:FontWeight.normal),
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
    userType = myPrefs.getString("userType")!;
    setState(() {
      userName = myPrefs.getString("userName")!;
      companyLogo= myPrefs.getString("companyLogo")!;
      if(userType=="LANGlobal"){
        visibleCompany=true;
      }else{
        visibleCompany=false;
      }
      print(userName);
      print(companyLogo);
    });
  }

  Widget buildCoverImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: NetworkImage(
        companyLogo),
  );

  Widget buildProfileImage() => Container(
    color: Colors.white,
    child: Image.network(
      companyLogo,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        return Center(child: child);
      },
    ),
  );
}
//Copyrights © 2022 | All Rights Reserved by Department of Finance.\n
