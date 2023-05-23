import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/cartonAssignment/cartonAssignmentSubmitPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/requestParams/cartonList2.dart';

class CartonValidatePage extends StatefulWidget {
  var sku;
  var category;
  var productName;
  var totalCartons;
  var itemCount;
  List<CartonList2> obj_cartonList;
  var location;
  var conditionValue;

  CartonValidatePage(this.sku,
      this.category,
      this.productName,
      this.totalCartons,
      this.itemCount,
      this.obj_cartonList,
      this.location,
      this.conditionValue,  {Key? key}) : super(key: key);

  @override
  _CartonValidatePage createState() =>
      _CartonValidatePage(this.sku,
        this.category,
        this.productName,
        this.totalCartons,
        this.itemCount,
        this.obj_cartonList,
        this.location,
        this.conditionValue);
}

class _CartonValidatePage extends State<CartonValidatePage> {
  var sku;
  var category;
  var productName;
  var totalCartons;
  var itemCount;
  List<CartonList2> obj_cartonList;
  var location;
  var conditionValue;

  _CartonValidatePage(this.sku,
      this.category,
      this.productName,
      this.totalCartons,
      this.itemCount,
      this.obj_cartonList,
      this.location,
      this.conditionValue);

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;

  TextEditingController locationController = TextEditingController();
  bool isReverse=false;
  BuildContext? _context;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final locationField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        maxLength: 11,
        controller: locationController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value){
          if(locationController.text == ""){
            _showToast("Location can't be empty!");
          }else{
            buildShowDialog(context);
            callCartonAssignmentApi();
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Location",
          alignLabelWithHint: true,
          hintText: "Location",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(locationController.text == ""){
            _showToast("Location can't be empty!");
          }else{
            buildShowDialog(context);
            callCartonAssignmentApi();
          }

        },
        child: Text("Validate",
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
            const Text('Inventory Allocation',textAlign: TextAlign.center,
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
      body:  Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Carton Assignment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
              ],
            ),
          ),
          Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child:  locationField
            ),
          )
        ],

      )
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

  void callCartonAssignmentApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    print(token);

    var _cartonList = obj_cartonList.map((e){
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );
    var url = "https://api.langlobal.com/inventoryallocation/v1/cartonassignment/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "userID": int.parse(userID!),
      "companyID": int.parse(companyID!),
      "sku": sku,
      "condition": conditionValue,
      "location": locationController.text!,
      "cartons":jsonstringmap,
    });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
    // var jsonRequest = json.decode(body); \"
    print("requestParams$body" );
    var response =
    await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          var cartonAssignment=jsonResponse['cartonAssignment'];
         // _showToast("Validate successfully!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonAssignmentSubmitPage(cartonAssignment['sku'],
                cartonAssignment['category'],cartonAssignment['productName'],cartonAssignment['cartonCount'],
                cartonAssignment['cartornItemsCount'],obj_cartonList,locationController.text,conditionValue)),
          );
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        Navigator.of(_context!).pop();
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
