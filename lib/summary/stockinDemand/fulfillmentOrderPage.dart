import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/requestParams/cartonList2.dart';
import '../../model/requestParams/locationList.dart';
import '../../utilities.dart';
import '../../warehouseAllocation/skuLookup/skuLookupDetailPage.dart';

class FulfillmentOrderPage extends StatefulWidget {
  var stockInDemand;

  FulfillmentOrderPage(this.stockInDemand, {Key? key}) : super(key: key);

  @override
  _FulfillmentOrderPage createState() => _FulfillmentOrderPage(this.stockInDemand);
}

class _FulfillmentOrderPage extends State<FulfillmentOrderPage> {
  var stockInDemand;

  _FulfillmentOrderPage(this.stockInDemand);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly = true;

  BuildContext? _context;
  List<CartonList2> cartonList = <CartonList2>[];
  List<LocationList> locationList = <LocationList>[];
  var cartonValue;
  var previousindx = -1;
  var stockInDemandList;
  int itemsLength=0;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text = cartonValue;
    controllers.add(controller);
    return Text(cartonValue.toString());
  }

  Utilities _utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      buildShowDialog(context);
    });
    if(!Utilities.ActiveConnection){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _showToast('No internet connection found!');
      });
    }else{
      callStockInDemandApi();
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final refreshButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callStockInDemandApi();
        },
        child: Text("Refresh",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             // refreshButton,
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Stock In Demand',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
              child:  Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        color: Colors.grey.shade400,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5,right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      stockInDemand['categoryName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    stockInDemand['productName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      stockInDemand['sku'],
                                      style: TextStyle(
                                        fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        if(!Utilities.ActiveConnection){
                                          _showToast("No internet connection found!");
                                        }else{
                                          callGetSkuApi(stockInDemand['sku'].toString());
                                        }
                                      },
                                      child: Text(
                                        'Stock in hand: '+ stockInDemand['currentStock'].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.underline
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                                SizedBox(height: 5,),
                              ],
                            )
                        )
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Text(
                          'S.NO.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          'Fulfillment'+"\n"+"Order#",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(width: 30,),
                        Text(
                          'Order'+"\n"+"Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Requested'+"\n"+"Shipment Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                        color: Colors.black,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: itemsLength,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                            },
                            child: Container(
                              color: index % 2 == 0 ? Colors.white : Color(0xffd3d3d3),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        ""+ (index+1).toString()+". ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 25,),
                                      Text(
                                        stockInDemandList[index]['fulfillmentNumber'].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(width: 35,),
                                      Text(
                                        DateFormat("MM/dd/yyyy").format(DateTime.parse(stockInDemandList[index]['orderDate'].toString().substring(0,10))),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        DateFormat("MM/dd/yyyy").format(DateTime.parse(stockInDemandList[index]['requestedShipdate'].toString().substring(0,10))),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                ],
                              ),
                            )
                        );
                      },
                    )
                  ],
                ),
              ),
            )),
      ),
    );
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

  void callStockInDemandApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? _companyID = myPrefs.getString("companyID");
    String? _userID = myPrefs.getString("userId");
    var url = "https://api.langlobal.com/inventory/v1/Customers/${_companyID!}/PO/"+ stockInDemand['sku'];
    print(":::: "+url);
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type": "application/json"
    };

    final response1 =
    await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode = jsonResponse['returnCode'];
      if (returnCode == "1") {
        setState(() {
          stockInDemandList = jsonResponse['stocks'];
          itemsLength=stockInDemandList.length;
        });
      } else {
        _showToast(jsonResponse['returnMessage']);
      }
    }
    print(stockInDemandList[0]['fulfillmentNumber']);
    print(response1.body);
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

  void callGetSkuApi(String Sku) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    String searchBy = "sku";
    var url = "https://api.langlobal.com/inventory/v1/Customers/" +
        companyID! +
        "?" +
        searchBy +
        "=" +
        Sku;
    print("url ::::: " + url);
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SkuLookupDetailPage(jsonResponse),
              ));
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
}
