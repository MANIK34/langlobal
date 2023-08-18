import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/utilities.dart';
import 'package:langlobal/warehouseAllocation/cartonConsolidation/consolidationConfirmationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../dashboard/DashboardPage.dart';
import '../../model/requestParams/cartonList2.dart';
import '../../model/requestParams/locationList.dart';

class CartonSubmitPage extends StatefulWidget {
  var jsonResponse;
  var destinationCarton;
  var location;
  var sourceJsonStringMap;
  var sku;
  List<CartonList2> sourceCartonList;
  var sourceQty;
  var sourceCount;
  var condition;

  CartonSubmitPage(this.jsonResponse, this.destinationCarton, this.location,
      this.sourceJsonStringMap, this.sku, this.sourceCartonList,this.sourceQty,this.sourceCount,this.condition,
      {Key? key})
      : super(key: key);

  @override
  _CartonSubmitPage createState() => _CartonSubmitPage(
      this.jsonResponse,
      this.destinationCarton,
      this.location,
      this.sourceJsonStringMap,
      this.sku,
      this.sourceCartonList,
      this.sourceQty,
      this.sourceCount,
      this.condition);
}

class _CartonSubmitPage extends State<CartonSubmitPage> {
  var jsonResponse;
  var destinationCarton;
  var location;
  var sourceJsonStringMap;
  var sku;
  List<CartonList2> sourceCartonList;
  var sourceQty;
  var sourceCount;
  var condition;

  _CartonSubmitPage(this.jsonResponse, this.destinationCarton, this.location,
      this.sourceJsonStringMap, this.sku, this.sourceCartonList,this.sourceQty,this.sourceCount,this.condition);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly = true;
  TextEditingController skuController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var cartonValue;
  BuildContext? _context;
  bool visibleWarehouse=true;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text = cartonValue;
    controllers.add(controller);
    return Text(cartonValue);
  }
  Utilities _utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();
    print(" ::::: " + sourceJsonStringMap.length.toString());
    for (int m = 0; m < sourceCartonList.length; m++) {
      cartonValue = sourceCartonList[m].cartonID.toString();
      textFeildList.add(customField());
    }
    if(location.toString().isEmpty){
      visibleWarehouse=false;
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
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            buildShowDialog(context);
            callCartonMovementApi();
          }

        },
        child: Text("Submit",
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
          children: [
            const Text(
              'Cartons Consolidation',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
           /* ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
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
        ),
      ),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cartons Consolidation - View & Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  color: Color.fromRGBO(40, 40, 43, 6.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' ',
                            style: TextStyle(
                              fontSize: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    sku +" I ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    condition+" I ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      jsonResponse['movementInfo']
                      ['categoryName']
                          .toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            Text('Destination Cartons:'),
                            Spacer(),
                            Text(destinationCarton.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: visibleWarehouse,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                children: <Widget>[
                                  Text('Warehouse Location:'),
                                  Spacer(),
                                  Text(location),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            Text('Total Qty:'),
                            Spacer(),
                            Text(jsonResponse['movementInfo']
                                    ['cartornItemsCount']
                                .toString()),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            Text('Source Cartons:'),
                            Spacer(),
                           /* Text(jsonResponse['movementInfo']['cartons']
                                .length
                                .toString()),*/
                            Text(sourceCount
                                .toString()),

                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            Text('Total Qty:'),
                            Spacer(),
                            Text(sourceQty.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Carton Allocations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  color: Color.fromRGBO(40, 40, 43, 6.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' ',
                            style: TextStyle(
                              fontSize: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: textFeildList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 35,
                          color: index % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                          child: Row(
                                children: <Widget>[
                                  SizedBox(width: 5,),
                                  Text(
                                    "" + (index + 1).toString() + ". ",
                                  ),
                                  Expanded(child: textFeildList[index]),
                                ],
                              ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void callCartonMovementApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");

    List<CartonList2> cartonList = <CartonList2>[];
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text! != "") {
        CartonList2 obj = CartonList2(
          cartonID: controllers[i].text!,
          assignedQty: 0,
        );
        cartonList.add(obj);
      }
    }
    var _cartonList = cartonList.map((e) {
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap");

    List<LocationList> locationList = <LocationList>[];
    LocationList obj = LocationList(
        warehouseLocation: location,
        locationCategory: 'Destination',
        locationType: '');
    locationList.add(obj);

    var _locationList = locationList.map((e) {
      return {
        "warehouseLocation": e.warehouseLocation,
        "locationCategory": e.locationCategory,
        "locationType": e.locationType,
      };
    }).toList();

    var jsonStringLocation = json.encode(_locationList);
    print("_locationList$jsonStringLocation");

    var url =
        "https://api.langlobal.com/inventoryallocation/v1/cartonconsolidation";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var body = json.encode({
      "action": "submit",
      "userID": int.parse(userID!),
      "companyID": int.parse(companyID!),
      "destinationCarton": destinationCarton,
      "cartons": sourceJsonStringMap,
      "locations": jsonStringLocation
    });
    body = body.replaceAll("\"[", "[");
    body = body.replaceAll("]\"", "]");
    body = body.replaceAll("\\\"", "\"");
    print("requestParams Consolidation$body");
    var response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var _jsonResponse = json.decode(response.body);
      try {
        var returnCode = _jsonResponse['returnCode'];
        if (returnCode == "1") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConsolidationConfirmationPage(
                    jsonResponse,
                    destinationCarton,
                    location,
                    sku,
                    sourceCartonList,
                    sourceQty,
                    sourceCount,
                    condition)),
          );
        } else {
          _showToast(_jsonResponse['returnMessage']);
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
