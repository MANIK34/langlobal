import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/cartonConsolidation/cartonSubmitPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model/requestParams/cartonList2.dart';

class CartonDestinationPage extends StatefulWidget {
  var jsonResponse;
  var sourceJsonStringMap;
  var sku;
  List<CartonList2> sourceCartonList;
  var condition;

  CartonDestinationPage(this.jsonResponse,this.sourceJsonStringMap,this.sku,this.sourceCartonList,this.condition,
      {Key? key}) : super(key: key);

  @override
  _CartonDestinationPage createState() =>
      _CartonDestinationPage(this.jsonResponse,this.sourceJsonStringMap,this.sku ,this.sourceCartonList,this.condition);
}

class _CartonDestinationPage extends State<CartonDestinationPage> {
  var jsonResponse;
  var sourceJsonStringMap;
  var sku;
  List<CartonList2> sourceCartonList;
  var condition;

  _CartonDestinationPage(this.jsonResponse,this.sourceJsonStringMap,this.sku,this.sourceCartonList,this.condition );

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  TextEditingController cartonController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String cartonID='';
  BuildContext? _context;
  String carton_text="Generate Carton ID";
  bool _showCursor=false;
  bool _focusLocation=false;
  var sourceQty;
  var sourceCount;

  Widget customField({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return TextField(
      autofocus: true,
      showCursor: true,
      maxLength: 20,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        textFeildList.add(customField());
      },

      onChanged: (value) {
        if (value.length == 6) {
          textFeildList.add(customField());
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFeildList.add(customField());
    sourceQty=jsonResponse['movementInfo']['cartornItemsCount'].toString();
    sourceCount=jsonResponse['movementInfo']['cartons'].length.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final cartonField = TextField(
        maxLength: 20,
        readOnly: _showCursor,
        controller: cartonController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Carton",
          alignLabelWithHint: true,
          hintText: "Carton",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final locationField = TextField(
        maxLength: 11,
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



    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(cartonController.text.toString().isEmpty){
            _showToast("Carton can't be empty!");
          }else if(carton_text=='Remove Carton ID' && locationController.text.toString().isEmpty){
              _showToast("Warehouse location can't be empty!");
          }else{
            buildShowDialog(context);
            callCartonMovementApi();
          }

        },
        child: Text("Validate",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final generateIDButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(carton_text=='Generate Carton ID'){
            locationController.text="";
            _focusLocation=true;
            buildShowDialog(context);
            callGetCartonIDApi();
          }else{
            locationController.text="";
            _focusLocation=false;
            cartonController.text="";
            carton_text="Generate Carton ID";
            _showCursor=false;
            setState(() {});
          }

        },
        child: Text(carton_text,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
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
            const Text('Cartons Consolidation',textAlign: TextAlign.center,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:  Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cartons - Destination Carton',
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 70,
                    width: 300,
                    child: cartonField,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('OR',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: generateIDButton,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                 Visibility(
                   visible: _focusLocation,
                   child:  SizedBox(
                     height: 70,
                     width: 300,
                     child: locationField,
                   ),
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
                            Text('Total Cartons:'),
                            Spacer(),
                            Text(jsonResponse['movementInfo']['cartonCount'].toString()),
                          ],
                        ),),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            children: <Widget>[
                              Text('Total Qty:'),
                              Spacer(),
                              Text(jsonResponse['movementInfo']['cartornItemsCount'].toString()),
                            ],
                          ),),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),)

                ],
              ),
            )
        ),
      ),
    );
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
      cartonController.text=cartonID;
      carton_text="Remove Carton ID";
      _showCursor=true;
      setState(() {});
    } else {
      print(response1.statusCode);
    }
    Navigator.of(_context!).pop();
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

  void callCartonMovementApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");

    List<CartonList2> cartonList = <CartonList2>[];
    CartonList2 obj= CartonList2(cartonID: cartonController.text.toString()!,assignedQty: 0,);
    cartonList.add(obj);
    var _cartonList = cartonList.map((e){
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );

    var url = "https://api.langlobal.com/inventoryallocation/v1/cartonmovement/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "companyID": int.parse(companyID!),
      "sourceLocation": "",
      "sku":jsonResponse['movementInfo']['cartons'][0]['sku'],
      "destinationLocation": locationController.text.toString(),
      "cartons":jsonstringmap,
    });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
    print("requestParams$body" );
    var response =
    await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          var destinationLocation=locationController.text.toString();
          if(destinationLocation.isEmpty){
            destinationLocation=jsonResponse['movementInfo']['destinationLocation'];
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonSubmitPage(jsonResponse,cartonController.text.toString(),
                destinationLocation.toString(),sourceJsonStringMap,sku,sourceCartonList,sourceQty,sourceCount,condition)),
          );
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
