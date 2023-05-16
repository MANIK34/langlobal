import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../locationLookup/locationLookupDetailPage.dart';
import 'cartonLookupPage.dart';

class CartonLookupDetailPage extends StatefulWidget {
  var cartonContent;

  CartonLookupDetailPage(this.cartonContent,
      {Key? key}) : super(key: key);

  @override
  _CartonLookupDetailPage createState() =>
      _CartonLookupDetailPage(this.cartonContent);
}

class _CartonLookupDetailPage extends State<CartonLookupDetailPage> {
  var cartonContent;

  _CartonLookupDetailPage(this.cartonContent);

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
    super.initState();
    var imeiList = cartonContent['imeiList'];
    for(int m=0;m<imeiList.length;m++){
      esnValue=imeiList[m]['imei'];
      textFeildList.add(customField());
    }
    if(textFeildList.isNotEmpty){
      _visibleImei=true;
    }
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
            MaterialPageRoute(builder: (context) => CartonLookupPage('')),
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
            const Text('Carton Lookup',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
            /*ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )*/

            GestureDetector(
                child: Container(
                    width: 85,
                    height: 80,
                    child: Center(
                      child: ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();

                        },
                      ),
                    )),
                onTap: () {
                  Navigator.of(context).pop();

                }),

          ],
        ),),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                      Text('Carton ID:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['cartonID'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: (){
                                          callGetCartonLookupApi(cartonContent['location'].toString());
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Text('Location:'),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(cartonContent['location'].toString(),style: TextStyle(
                                                fontWeight: FontWeight.bold,color:Colors.blue,decoration: TextDecoration.underline
                                            )),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
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
                              ],
                            ),
                          ),),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Carton Contents',
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

                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                                      Text(cartonContent['category'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['condition'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(child: Text(cartonContent['sku'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(cartonContent['productName'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                  visible: true,
                                    child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              const Text('Qty Assigned:'),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(cartonContent['qtyPerCarton'].toString(),style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),),)
                              ],
                            ),
                          ),),

                        Visibility(
                          visible: _visibleImei,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                            child: Column(
                              children: <Widget>[
                                Divider(
                                  thickness: 2.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: textFeildList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      color: index % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                ""+ (index+1).toString()+". ",
                                              ),
                                              Expanded(child: textFeildList[index]),
                                            ],
                                          ),
                                          const Divider(
                                              color: Colors.black
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            )
                        ),),
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

  void callGetCartonLookupApi(String location) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/locationlookup/"+location;
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
            MaterialPageRoute(builder: (context) => LocationLookupDetailPage(jsonResponse['locationContent'])),
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
