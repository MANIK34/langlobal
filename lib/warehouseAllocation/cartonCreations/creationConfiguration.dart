import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/warehouseAllocation/cartonCreations/validateSourceCarton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreationConfigurationPage extends StatefulWidget {
  var heading;

  CreationConfigurationPage(this.heading,  {Key? key}) : super(key: key);

  @override
  _CreationConfigurationPage createState() =>
      _CreationConfigurationPage(this.heading );
}

class _CreationConfigurationPage extends State<CreationConfigurationPage> {
  var heading;


  _CreationConfigurationPage(this.heading );



  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  TextEditingController skuController = TextEditingController();
  TextEditingController QtyCartonController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isReverse=false;

  var conditionValue;
  List<String> conditionList = <String>[];
  List<String> conditionList2 = <String>[];
  late String? _conditionList = null;
  bool isChecked = false;
  String cartonID='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetConditionApi();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      buildShowDialog(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    final conditionField = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text('Select Condition'),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionValue = value!;
            });
          },
          items: conditionList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(map),
            );
          }).toList(),
        ),
      ),
    );

    final skuField = TextField(
        maxLength: null,
        autofocus: true,
        showCursor: true,
        controller: skuController,
        style: style,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "SKU",
          alignLabelWithHint: true,
          hintText: "SKU",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final qtyCarton = TextField(
        maxLength: null,
        controller: QtyCartonController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Qty/Carton",
          alignLabelWithHint: true,
          hintText: "Qty/Carton",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final locationField = TextField(
        maxLength: null,
        controller: locationController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Warehouse Location",
          alignLabelWithHint: true,
          hintText: "Warehouse Location",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final sourceCarton= Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(skuController.text == ""){
            _showToast("SKU can't be empty!");
          }else if(QtyCartonController.text == ""){
            _showToast("Qty/Carton can't be empty!");
          }else if(locationController.text == ""){
            _showToast("Warehouse Location can't be empty!");
          }else{
            buildShowDialog(context);
            callValidateApi();
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
            const Text('Carton Creation',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage('')),
                );
              },
              child: const Text('Cancel',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: isReverse,
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'New Carton Configuration',
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
                            color: const Color.fromRGBO(	40, 40, 43, 6.0),
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
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Text('Carton ID:',style: TextStyle(
                                fontWeight: FontWeight.normal,color: Colors.black,fontSize: 18
                            ),),
                            SizedBox(
                              width: 10,
                            ),
                            Text(cartonID,style: TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16
                            ),),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        skuField,
                        SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0, left: 0.0),
                            child: Text("Select Condition"),
                          ),
                        ),
                        conditionField,
                        SizedBox(
                          height: 20,
                        ),
                        qtyCarton,
                        SizedBox(
                          height: 20,
                        ),
                        locationField,
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:  Row(
                            children: <Widget>[
                              sourceCarton,
                              SizedBox(
                                width: 0,
                              ),
                              Text('Source Carton',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18
                              ),),
                            ],
                          ),
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


  void callGetConditionApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/common/v1/Conditions/";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      String jsonString = json.encode(jsonResponse);
      conditionList= (jsonDecode(jsonString) as List<dynamic>).cast<String>();
      _conditionList = conditionList[0];
      conditionValue= conditionList[0];
    } else {
      print(response1.statusCode);
    }
    callGetCartonIDApi();
  }

  void callGetCartonIDApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? _companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/generatecarton/"+_companyID!;
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      cartonID=jsonResponse.toString();
      setState(() {});
    } else {
      print(response1.statusCode);
    }
    Navigator.of(context).pop();
  }

  void callValidateApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? _companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/location/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "companyID": _companyID!,
      "sku": skuController.text.toString(),
      "whLocation": locationController.text.toString(),
    });

    final response1 = await http.post(Uri.parse(url), body:body,headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(context).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode=jsonResponse['returnCode'];
      if(returnCode=="1"){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ValidateSourceCartonPage(cartonID,skuController.text.toString(),
                  conditionValue,QtyCartonController.text.toString(),
              locationController.text.toString(),jsonResponse)),
        );
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
