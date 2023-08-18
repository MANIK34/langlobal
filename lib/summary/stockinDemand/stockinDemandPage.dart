import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/summary/stockinDemand/fulfillmentOrderPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/requestParams/cartonList2.dart';
import '../../model/requestParams/locationList.dart';
import '../../utilities.dart';
import '../../warehouseAllocation/skuLookup/skuLookupDetailPage.dart';

class StockInDemandlPage extends StatefulWidget {
  var stockInDemand;

  StockInDemandlPage(this.stockInDemand, {Key? key}) : super(key: key);

  @override
  _StockInDemandlPage createState() => _StockInDemandlPage(this.stockInDemand);
}

class _StockInDemandlPage extends State<StockInDemandlPage> {
  var stockInDemand;

  _StockInDemandlPage(this.stockInDemand);

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
  var obj_stockInDemand;
  Utilities _utilities = Utilities();

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text = cartonValue;
    controllers.add(controller);
    return Text(cartonValue.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();
    if(!Utilities.ActiveConnection){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _showToast('No internet connection found!');
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        buildShowDialog(context);
      });
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
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            buildShowDialog(context);
            callStockInDemandApi();
          }
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
              refreshButton,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: stockInDemand.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: index % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                      child: Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "" + (index + 1).toString() + ". ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            stockInDemand[index]['sku'].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline,
                                                color: Colors.blue
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FulfillmentOrderPage(
                                                            stockInDemand[
                                                                index])),
                                              );
                                            },
                                            child: Text(
                                              'Order Count: ' +
                                                  stockInDemand[index]
                                                          ['orderCount']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: SizedBox(
                                          child: Text(
                                        stockInDemand[index]['categoryName'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                      onTap: () {
                                        if(!Utilities.ActiveConnection){
                                          _showToast("No internet connection found!");
                                        }else{
                                          callGetSkuApi(stockInDemand[index]
                                          ['sku']
                                              .toString());
                                        }

                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FulfillmentOrderPage(
                                                        stockInDemand[index])),
                                          );
                                        },
                                        child: Text(
                                          'Ordered Qty: ' +
                                              stockInDemand[index]
                                                      ['requiredQunatity']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue),
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("I"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          if(!Utilities.ActiveConnection){
                                          _showToast("No internet connection found!");
                                        }else{
                                            callGetSkuApi(stockInDemand[index]
                                            ['sku']
                                                .toString());
                                        }

                                        },
                                        child: Text(
                                          'Stock in hand: ' +
                                              stockInDemand[index]
                                                      ['currentStock']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                      ]),
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
    var url =
        "https://api.langlobal.com/inventory/v1/Customers/${_companyID!}/Stock";
    print(":::: " + url);
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type": "application/json"
    };

    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode = jsonResponse['returnCode'];
      if (returnCode == "1") {
        setState(() {
          stockInDemand = jsonResponse['stocks'];
        });
      } else {
        _showToast(jsonResponse['returnMessage']);
      }
    }
   // print(stockInDemand[0]['categoryName']);
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
