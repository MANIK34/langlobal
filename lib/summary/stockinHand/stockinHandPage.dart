import 'dart:convert';

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/summary/stockinHand/stockinHandDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/requestParams/categoryList.dart';


class StockInHandPage extends StatefulWidget {
  var heading;

  StockInHandPage(this.heading,  {Key? key}) : super(key: key);

  @override
  _StockInHandPage createState() =>
      _StockInHandPage(this.heading );
}

class _StockInHandPage extends State<StockInHandPage> {
  var heading;


  _StockInHandPage(this.heading );



  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  TextEditingController skuController = TextEditingController();
  bool isReverse=false;

  String  conditionValue="";
  List<String> conditionList = <String>[];
  List<String> conditionList2 = <String>[];
  late String? _conditionList = null;

  String skuValue = "";
  List<String> skuList = <String>[];
  List<String> skuList2 = <String>[];
  late String? _skuList = null;

  var categoryValue=0;
  List<CategoryList> categoryList = <CategoryList>[];
  List<CategoryList> categoryList2 = <CategoryList>[];
  late CategoryList? _categoryList = null;

  var makersValue=0;
  List<CategoryList> makersList = <CategoryList>[];
  List<CategoryList> makersList2 = <CategoryList>[];
  late CategoryList? _makersList = null;

  bool isChecked = false;
  String cartonID='';
  BuildContext? _context;
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

    final categoryField = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CategoryList>(
          hint: const Text('Select Category'),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36.0,
          isExpanded: true,
          value: _categoryList,
          onChanged: (value) {
            setState(() {
              _categoryList = value!;
              categoryValue = value!.categoryGUID;
            });
          },
          items: categoryList.map((CategoryList map) {
            return DropdownMenuItem<CategoryList>(
              value: map,
              child: Text(map.categoryName),
            );
          }).toList(),
        ),
      ),
    );

    final skuTypeField = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text('Select SKU Type'),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36.0,
          isExpanded: true,
          value: _skuList,
          onChanged: (value) {
            setState(() {
              _skuList = value!;
              skuValue = value!;
            });
          },
          items: skuList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(map),
            );
          }).toList(),
        ),
      ),
    );

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

    final makersField = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CategoryList>(
          hint: const Text('Select Category'),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36.0,
          isExpanded: true,
          value: _makersList,
          onChanged: (value) {
            setState(() {
              _makersList = value!;
              makersValue = value!.categoryGUID;
            });
          },
          items: makersList.map((CategoryList map) {
            return DropdownMenuItem<CategoryList>(
              value: map,
              child: Text(map.categoryName),
            );
          }).toList(),
        ),
      ),
    );

    final skuField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 50,
        autofocus: false,
        showCursor: true,
        controller: skuController,
        style: style,
        textInputAction: TextInputAction.done,
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



    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callStockInHandApi();
        },
        child: Text("Search",
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
            const Text('Stock In Hand',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
           /* ExpandTapWidget(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DashboardPage('')),
                          );
                        },
                      ),
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage('')),
                  );
                }),

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
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0, left: 0.0),
                            child: Text("Select Category"),
                          ),
                        ),
                        categoryField,
                        SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0, left: 0.0),
                            child: Text("Select SKU Type"),
                          ),
                        ),
                        skuTypeField,
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0, left: 0.0),
                            child: Text("Select Makers"),
                          ),
                        ),
                        makersField,
                        SizedBox(
                          height: 20,
                        ),
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
    print("_token :: "+_token!);
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
      setState(() {
        conditionList.add("All");
        var conditionList2= (jsonDecode(jsonString) as List<dynamic>).cast<String>();
        conditionList.addAll(conditionList2);
        _conditionList = conditionList[0];
        conditionValue= conditionList[0];
      });
      callGetCategoryApi();
    } else {
      Navigator.of(_context!).pop();
      print(response1.statusCode);
    }
  }

  void callGetCategoryApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/common/v1/Categories?companyID="+companyID!;
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      var categories = jsonResponse['categories'];
      CategoryList _list= CategoryList(categoryGUID: 0,
          categoryName: "All");
      categoryList.add(_list);
      for(int m=0;m<categories.length;m++){
        CategoryList _list= CategoryList(categoryGUID: categories[m]['categoryGUID'],
            categoryName: categories[m]['categoryName']);
        categoryList.add(_list);
      }
      setState(() {
        categoryList2= categoryList;
        _categoryList = categoryList[0];
        categoryValue= categoryList[0].categoryGUID;
      });

    } else {
      Navigator.of(_context!).pop();
      print(response1.statusCode);
    }
    callGetSkuTypeApi();

  }

  void callGetSkuTypeApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/common/v1/SKUTypes";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      String jsonString = json.encode(jsonResponse);
      setState(() {
        skuList.add("All.");
        var skuList2= (jsonDecode(jsonString) as List<dynamic>).cast<String>();
        skuList.addAll(skuList2);
        _skuList = skuList[0];
        skuValue= skuList[0];
      });
    } else {
      Navigator.of(_context!).pop();
      print(response1.statusCode);
    }
    callGetMakersApi();

  }

  void callGetMakersApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/common/v1/Makers?companyID="+companyID!;
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      var categories = jsonResponse['makers'];
      CategoryList _list= CategoryList(categoryGUID:0,
          categoryName: "All");
      makersList.add(_list);
      for(int m=0;m<categories.length;m++){
        CategoryList _list= CategoryList(categoryGUID: categories[m]['makerGUID'],
            categoryName: categories[m]['makerName']);
        makersList.add(_list);
      }
      setState(() {
        makersList2= makersList;
        _makersList = makersList[0];
        makersValue= makersList[0].categoryGUID;
      });

    } else {
      Navigator.of(_context!).pop();
      print(response1.statusCode);
    }
    Navigator.of(_context!).pop();
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
    if(conditionValue=="All"){
      conditionValue="";
    }
    if(skuValue=="All."){
      skuValue="";
    }
    var body = json.encode({
      "action": "search",
      "companyID": _companyID!,
      "userID": _userID!,
      "categoryID": categoryValue,
      "sku": skuController.text.toString(),
      "condition": conditionValue,
      "makerGUID": makersValue,
      "skuType": skuValue,
    });
    print("requestParams$body" );
    final response1 = await http.post(Uri.parse(url), body:body,headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode=jsonResponse['returnCode'];
      if(returnCode=="1"){
        print("stockLength ::::"+jsonResponse['stockInHands'].length.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StockInHandDetailPage(jsonResponse['stockInHands'],categoryValue,
              skuValue,skuController.text.toString(),conditionValue,makersValue)),
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
          _context=context;
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
