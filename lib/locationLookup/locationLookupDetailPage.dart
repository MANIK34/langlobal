import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/locationLookup/locationLookupPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/DashboardPage.dart';
import '../utilities.dart';
import '../warehouseAllocation/cartonLookup/cartonLookupDetailPage.dart';
 

class LocationLookupDetailPage extends StatefulWidget {
  var cartonContent;

  LocationLookupDetailPage(this.cartonContent,
      {Key? key}) : super(key: key);

  @override
  _LocationLookupDetailPage createState() =>
      _LocationLookupDetailPage(this.cartonContent);
}

class _LocationLookupDetailPage extends State<LocationLookupDetailPage> {
  var cartonContent;

  _LocationLookupDetailPage(this.cartonContent);

  Utilities _utilities = Utilities();

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool autoFocus=false;

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list
  var esnValue;
  bool _visibleImei=false;
  BuildContext? _context;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text=esnValue.toString();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return Text(esnValue.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationLookupPage('')),
          );
        },
        child: Text("New Lookup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: validateButton,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Location Lookup',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
           /* ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )*/
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
            const SizedBox(width: 20,),
            GestureDetector(
                child:  const FaIcon(
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
        ),),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1, //<-- SEE HERE
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Location:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['location'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['locationType'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Aisle:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['aisle'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Bay:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['bay'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Level:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['level'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10,right: 10,),
                                child:  Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                const Text(
                                                  'Total Cartons: ',
                                                  style: TextStyle(
                                                  ),
                                                ),
                                                Text(
                                                  cartonContent['cartonCount'].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Items Count: ',
                                                  style: TextStyle(
                                                  ),
                                                ),
                                                Text(
                                                  cartonContent['itemsCount'].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),),

                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                        child: Column(
                          children: <Widget>[
                        const Align(
                        alignment: Alignment.centerLeft,
                          child: Text(
                            'Carton Assignments',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.black,
                          ),
                          ],
                        )),
                        const SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.only(left: 0,right: 0),child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartonContent['skuList'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                    color: Colors.grey,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 5,right: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(height: 2,),
                                            Wrap(
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Text(cartonContent['skuList'][index]['categoryName'],style: TextStyle(
                                                        fontWeight: FontWeight.normal
                                                    ),),
                                                    Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                      child:Text("I"),),
                                                    Text(cartonContent['skuList'][index]['condition'],style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2,),
                                            Align(
                                              child: Text(cartonContent['skuList'][index]['sku'],style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),),
                                              alignment: Alignment.centerLeft,
                                            ),

                                            Align(
                                              child: Text(cartonContent['skuList'][index]['productName'],style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),),
                                              alignment:Alignment.centerLeft ,
                                            ),
                                            const SizedBox(height: 2,),
                                          ],
                                        )
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(left: 0,right: 0),
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: cartonContent['skuList'][index]['cartons'].length,
                                      itemBuilder: (BuildContext context, int indexx) {
                                        return Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                color: indexx % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                                height: 30,
                                                child:  Row(
                                                  children: [
                                                    SizedBox(width: 5,),
                                                    Text(
                                                      ""+ (indexx+1).toString()+". ",
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        if(!Utilities.ActiveConnection){
                                                          _showToast("No internet connection found!");
                                                        }else{
                                                          callGetCartonLookupApi(cartonContent['skuList'][index]['cartons'][indexx]['cartonID'].toString());
                                                        }
                                                      },
                                                      child:  Text(cartonContent['skuList'][index]['cartons'][indexx]['cartonID'].toString(),style: TextStyle(
                                                          fontWeight: FontWeight.normal,color: Colors.blue,decoration: TextDecoration.underline
                                                      ),),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                      child:Text("I"),),
                                                    Text(cartonContent['skuList'][index]['cartons'][indexx]['qtyPerCarton'].toString(),style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                    Spacer(),
                                                    Text(cartonContent['skuList'][index]['cartons'][indexx]['assignedDate'].toString(),style: TextStyle(
                                                        fontWeight: FontWeight.normal
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),)

                              ],
                            );
                          },
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
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
  void callGetCartonLookupApi(String cartonID) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/cartonlookup/"+
        cartonID.toString();
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}'
    };
    print(url.toString());
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonLookupDetailPage(jsonResponse['cartonContent'])),
          );
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
    debugPrint(response.body);

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
