import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/cartonCreations/cartonSerialized.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/requestParams/cartonList2.dart';
import '../../model/responseParams/sourceCartonConditions.dart';

class ValidateSourceCartonPage extends StatefulWidget {
  String cartonID = '';
  String sku = '';
  String condition = '';
  String qty = '';
  String location = '';
  var _jsonResponse;
  bool isEsnRequired;

  ValidateSourceCartonPage(this.cartonID, this.sku, this.condition, this.qty,
      this.location, this._jsonResponse,this.isEsnRequired,
      {Key? key})
      : super(key: key);

  @override
  _ValidateSourceCartonPage createState() => _ValidateSourceCartonPage(
      this.cartonID,
      this.sku,
      this.condition,
      this.qty,
      this.location,
      this._jsonResponse,
      this.isEsnRequired);
}

class _ValidateSourceCartonPage extends State<ValidateSourceCartonPage> {
  String cartonID = '';
  String sku = '';
  String condition = '';
  String qty = '';
  String location = '';
  var _jsonResponse;
  bool isEsnRequired;

  _ValidateSourceCartonPage(this.cartonID, this.sku, this.condition, this.qty,
      this.location, this._jsonResponse,this.isEsnRequired);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  TextEditingController cartonIDController = TextEditingController();

  var conditionID;
  List<SourceCartonConditions> conditionList = <SourceCartonConditions>[];
  late SourceCartonConditions? _conditionList = null;

  BuildContext? _context;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callSourceConditionsApi();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      buildShowDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartonConditionField = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SourceCartonConditions>(
          hint: const Text('Carton Condition'),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionID = value!.containerConditionID;
            });
          },
          items: conditionList.map((SourceCartonConditions map) {
            return DropdownMenuItem<SourceCartonConditions>(
              value: map,
              child: Text(map.containerConditionText),
            );
          }).toList(),
        ),
      ),
    );

    final cartonIdField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        maxLength: 20,
        controller: cartonIDController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Carton ID",
          alignLabelWithHint: true,
          hintText: "Carton ID",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callValidateSourceCartonApi();
        },
        child: Text("Validate",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text('Carton Creation',textAlign: TextAlign.center,
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 10, 36.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Source Carton',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2.0,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                cartonIdField,
                const SizedBox(
                  height: 20.0,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0, left: 0.0),
                    child: Text("Carton Condition"),
                  ),
                ),
                cartonConditionField,
                const SizedBox(height: 60.0),
                validateButton,
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ));
  }

  void callValidateSourceCartonApi() async {
    List<CartonList2> cartonList= <CartonList2>[];
    CartonList2 obj= CartonList2(cartonID: cartonIDController.text!,assignedQty: 0,);
    cartonList.add(obj);
    var _cartonList = cartonList.map((e){
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url =
        "https://api.langlobal.com/inventoryallocation/v1/sourcecarton/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var body = json.encode({
      "companyID": companyID!,
      "sku": sku,
      "condition": condition,
      "whLocation": location,
      "qtyPerCarton": qty,
      "cartons": jsonstringmap,
    });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
    // var jsonRequest = json.decode(body); \"
    print("requestParams$body" );
    var response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartonSerializedPage(cartonID,sku,condition,
                    jsonResponse['productName'],_jsonResponse,jsonResponse,qty,
                    cartonIDController.text.toString(),conditionID.toString(),isEsnRequired)),
          );
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    debugPrint(response.body);
  }

  void callSourceConditionsApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/common/v1/SourceCartonConditions";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type": "application/json"
    };
    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response1.body);
      //var jsonArray= jsonResponse[''];
      for (int m = 0; m < jsonResponse.length; m++) {
        SourceCartonConditions finList = SourceCartonConditions(
            containerConditionID: jsonResponse[m]['containerConditionID'],
            containerConditionText: jsonResponse[m]['containerConditionText']);
        conditionList.add(finList);
      }
      if(conditionList.isNotEmpty) {
        _conditionList = conditionList[0];
        conditionID= conditionList[0].containerConditionID;
      }
      setState(() {});
    } else {
      print(response1.statusCode);
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
