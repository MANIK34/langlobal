import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/cartonAssignment/cartonAssignmentSubmitPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:langlobal/warehouseAllocation/cartonAssignment/cartonValidatePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/requestParams/cartonList2.dart';

class CartonAssignmentPage extends StatefulWidget {
  var heading;

  CartonAssignmentPage(this.heading,  {Key? key}) : super(key: key);

  @override
  _CartonAssignmentPage createState() =>
      _CartonAssignmentPage(this.heading );
}

class _CartonAssignmentPage extends State<CartonAssignmentPage> {
  var heading;


  _CartonAssignmentPage(this.heading );

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = [];//the controllers list
  List<CartonList2> cartonList = <CartonList2>[];

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  TextEditingController skuController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isReverse=false;

  List<String> conditionList = <String>[];
  List<String> conditionList2 = <String>[];
  late String? _conditionList = null;
  var conditionValue;

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
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        if(controllers[textFeildList.length-1].text!=""){
          textFeildList.add(customField());
        }
      },
      onChanged: (value) {
        setState(() {
          isReverse=true;
        });
        if (value.length == 20) {
          //textFeildList.add(customField());
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFeildList.add(customField());
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

    final locationField = TextField(
        maxLength: null,
        controller: locationController,
        style: style,
        textInputAction: TextInputAction.done,
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
          if(controllers[0].text == ""){
            _showToast("Carton value can't be empty!");
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
            ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
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
                              SizedBox(
                                height: 20,
                              ),
                              skuField,
                              SizedBox(
                                height: 20,
                              ),
                              conditionField,
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Cartons',
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

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: textFeildList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Expanded(child: textFeildList[index]),
                                GestureDetector(
                                    onTap: () {
                                      if(textFeildList.length>1){
                                        textFeildList.removeAt(index);
                                        controllers.removeAt(index);
                                        setState(() {});
                                      }
                                    },
                                    child: index < 0
                                        ? Container()
                                        : const Icon(Icons.delete,color: Colors.red,)),
                              ],
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

  void callCartonAssignmentApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    print(token);
    cartonList= <CartonList2>[];
    for (int i = 0; i < controllers.length; i++) {
      if(controllers[i].text! != ""){
        CartonList2 obj= CartonList2(cartonID: controllers[i].text!,assignedQty: 0,);
        cartonList.add(obj);
      }
    }
    var _cartonList = cartonList.map((e){
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
      "sku": skuController.text!,
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
      Navigator.of(context).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          var cartonAssignment=jsonResponse['cartonAssignment'];
          //_showToast("Validate successfully!");
          cartonList = <CartonList2>[];
          var jsonArray = cartonAssignment['cartons'];
          for (int m = 0; m < jsonArray.length; m++) {
            CartonList2 list = CartonList2(cartonID: jsonArray[m]['cartonID'],assignedQty: jsonArray[m]['assignedQty']);
            cartonList.add(list);

          }
         /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonAssignmentSubmitPage(cartonAssignment['sku'],
                cartonAssignment['category'],cartonAssignment['productName'],cartonAssignment['cartonCount'],
                cartonAssignment['cartornItemsCount'],cartonList,locationController.text)),
          );*/
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonValidatePage(cartonAssignment['sku'],
                cartonAssignment['category'],cartonAssignment['productName'],cartonAssignment['cartonCount'],
                cartonAssignment['cartornItemsCount'],cartonList,locationController.text,conditionValue)),
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
      Navigator.of(context).pop();
      print(response.statusCode);
    }
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
    Navigator.of(context).pop();
  }
}
