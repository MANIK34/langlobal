import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/responseParams/companies.dart';

class SelectCompany extends StatefulWidget {
  String token = '';

  SelectCompany(this.token, {Key? key}) : super(key: key);

  @override
  _SelectCompany createState() => _SelectCompany(this.token);
}

class _SelectCompany extends State<SelectCompany> {
  String token = '';

  _SelectCompany(this.token);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;

  var companyID;
  var companyName;
  List<CompanyList> companyList = <CompanyList>[];
  List<CompanyList> companyList2 = <CompanyList>[];
  late CompanyList? _companyList = null;
  var selectedCompanyID;
  var header = 'Select Company';
  Utilities utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    utilities.checkUserConnection();
    super.initState();
    utilities.writeToken();
    if(!Utilities.ActiveConnection){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _showToast('No internet connection found!');
      });
    }else{
      setState(() {
        _isLoading = true;
      });
      callGetCompanyApi();
    }
  }

  /*Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
          print('Connection Active');
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
        print('Connection Not Active');
      });
    }
  }*/

  void callGetCompanyApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    try {
      selectedCompanyID = myPrefs.getString("companyID")!;
    } catch (e) {
      selectedCompanyID = "";
    }

    String? _token = myPrefs.getString("token");
    var url = "${Utilities.baseUrl}common/v1/Companies";

    Map<String, String> headers = {'Authorization': 'Bearer ' + Utilities.token!};

    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      var jsonArray = jsonResponse['companies'];
      for (int m = 0; m < jsonArray.length; m++) {
        var companyID = jsonArray[m]['companyID'];
        var companyName = jsonArray[m]['companyName'];
        var companyShortName = jsonArray[m]['companyShortName'];
        var companyLogo = jsonArray[m]['companyLogo'];
        CompanyList finList = CompanyList(
            companyID: companyID,
            companyName: companyName,
            companyShortName: companyShortName,
            companyLogo: companyLogo);
        companyList.add(finList);
      }
      companyList2 = companyList;
    } else {
     // print(response1.statusCode);
    }
    setState(() {
      _isLoading = false;
      companyList = companyList2;
      if (companyList.isNotEmpty) {
        _companyList = companyList[1];
        companyID = companyList[1].companyID;
        companyName = companyList[1].companyName;
        print("companyID"+companyID.toString());
        print("companyName"+companyName);
        print(selectedCompanyID.toString());
        if (selectedCompanyID != "") {
          header = "Change Company";
          for (int m = 0; m < companyList.length; m++) {
            if (companyList[m].companyID.toString() ==
                selectedCompanyID.toString()) {
              _companyList = companyList[m];
              companyID = companyList[m].companyID;
              companyName=companyList[m].companyName;
              break;
            }
          }
        }
      }
    });
  }

  void callGetCompanyLogoApi() async {
    /*SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");*/


    var url = "${Utilities.baseUrl}common/v1/CompanyLogo?companyID=" +
        companyID.toString();

    Map<String, String> headers = {'Authorization': 'Bearer ' + Utilities.token!};

    final response1 = await http.get(Uri.parse(url), headers: headers);
    if (response1.statusCode == 200) {
      var jsonResponse = json.decode(response1.body);
      if (jsonResponse["returnCode"] == "1") {
        SharedPreferences myPrefs = await SharedPreferences.getInstance();
        myPrefs.setString('companyLogo', jsonResponse["logoPath"]);
        print("REsponse ::::: "+response1.body);
        if (header == "Change Company") {
          Navigator.of(context).pop();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(token)),
          );
        }
        utilities.writeToken();
      }
    }
    print(response1.body);
    print(response1.statusCode);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyField = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CompanyList>(
          hint: Text(header),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36.0,
          isExpanded: true,
          value: _companyList,
          onChanged: (value) {
            setState(() {
              _companyList = value!;
              companyID = value!.companyID;
            });
          },
          items: companyList.map((CompanyList map) {
            return DropdownMenuItem<CompanyList>(
              value: map,
              child: Text(map.companyName),
            );
          }).toList(),
        ),
      ),
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            SharedPreferences myPrefs = await SharedPreferences.getInstance();
            myPrefs.setString('companyID', companyID.toString());
            myPrefs.setString('companyName', companyName.toString());
            print("companyName :::: "+companyName.toString());
            setState(() {
              _isLoading = true;
            });
            callGetCompanyLogoApi();
          }

        },
        child: Text("Go",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          header,
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "assets/lan_global_icon.jpeg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0, left: 20.0),
                        child: Text("Select Company"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0, left: 20.0),
                        child: companyField,
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    submitButton,
                    const SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
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
}
