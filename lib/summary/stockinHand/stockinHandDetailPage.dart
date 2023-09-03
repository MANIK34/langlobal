import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard/DashboardPage.dart';
import '../../model/requestParams/cartonList2.dart';
import '../../model/requestParams/locationList.dart';
import '../../utilities.dart';
import '../../warehouseAllocation/skuLookup/skuLookupDetailPage.dart';

class StockInHandDetailPage extends StatefulWidget {
  var stockInHands;
  var categoryId;
  var skuType;
  var sku;
  var condition;
  var makerID;

  StockInHandDetailPage(this.stockInHands,this.categoryId,this.skuType,this.sku,this.condition
      ,this.makerID,
      {Key? key}) : super(key: key);

  @override
  _StockInHandDetailPage createState() =>
      _StockInHandDetailPage(this.stockInHands,this.categoryId,this.skuType,this.sku,this.condition
          ,this.makerID);
}

class _StockInHandDetailPage extends State<StockInHandDetailPage> {
  var stockInHands;
  var categoryId;
  var skuType;
  var sku;
  var condition;
  var makerID;

  _StockInHandDetailPage(this.stockInHands,this.categoryId,this.skuType,this.sku,this.condition
      ,this.makerID );

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;

  BuildContext? _context;
  List<CartonList2> cartonList = <CartonList2>[];
  List<LocationList> locationList=<LocationList>[];
  var cartonValue;
  var previousindx=-1;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text=cartonValue;
    controllers.add(controller);
    return Text(
        cartonValue.toString()
    );
  }

  Utilities _utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();
    print("stockLength ::"+stockInHands.length.toString());
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
        minWidth:150,
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
        minWidth:150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            buildShowDialog(context);
            callStockInHandApi();
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
        child: Padding(padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              refreshButton,
              Spacer(),
              searchButton
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Stock In Hand',textAlign: TextAlign.center,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:  Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Stock In Hand',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Total SKUs: '+ stockInHands.length.toString(),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                    child:  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      color: Color.fromRGBO(	40, 40, 43, 6.0),
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

                  const SizedBox(
                    height: 10,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child:  Row(
                      children: <Widget>[
                        Text(
                          'SKU',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Spacer(),
                        Text(
                          'QTY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: stockInHands.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                callGetSkuApi(stockInHands[index]['sku'].toString());
                                print("${stockInHands[index]['sku']}");
                              },
                              child: Container(
                                height: 35,
                                color: index % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                   child:
                                       Row(
                                         children: <Widget>[
                                           SizedBox(width: 5,),
                                           Text(
                                             ""+ (index+1).toString()+". ",
                                           ),
                                           Text(
                                             stockInHands[index]['sku'],
                                             style: TextStyle(
                                                 decoration: TextDecoration.underline,color: Colors.blue
                                             ),
                                           ),
                                           Spacer(),
                                           Text(
                                             stockInHands[index]['stockInHand'].toString(),
                                           ),
                                           SizedBox(width: 5,),
                                         ],
                                       ),

                              ),
                            );
                          },
                        )
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



  void _showToast(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: "OK",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ));
  }

  void callStockInHandApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? _companyID = myPrefs.getString("companyID");
    String? _userID = myPrefs.getString("userId");
    var url = "https://api.langlobal.com/inventory/v1/stockinhand";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "action": "search",
      "companyID": _companyID!,
      "userID": _userID!,
      "categoryID": categoryId,
      "sku": sku,
      "condition": condition,
      "makerGUID": makerID,
      "skuType": skuType,
    });
    print("requestParams$body" );
    final response1 = await http.post(Uri.parse(url), body:body,headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode=jsonResponse['returnCode'];
      if(returnCode=="1"){
        setState(() {
          stockInHands=jsonResponse['stockInHands'];
        });
      }else{
        _showToast(jsonResponse['returnMessage']);
      }
    }
    print(response1.statusCode);
    print(response1.body);
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

  void callGetSkuApi(String Sku) async{
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    String searchBy="sku";
    var url = "https://api.langlobal.com/inventory/v1/Customers/"+companyID!+"?"+searchBy+"="+Sku;
    print("url ::::: "+url);
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var response =
    await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SkuLookupDetailPage(jsonResponse),
              ));
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
  }
}
