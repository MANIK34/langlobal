import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/triage/triageLookupPage2.dart';

import '../dashboard/DashboardPage.dart';
import '../drawer/drawerElement.dart';
import '../utilities.dart';

class TriageLookupPage1 extends StatefulWidget {
  @override
  _TriageLookupPage1 createState() => _TriageLookupPage1();
}

class _TriageLookupPage1 extends State<TriageLookupPage1> {
  TextEditingController memoController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  bool _fromDate=true;
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  String fromDate = "";
  String toDate = "";
  DateTime _selectedDate = DateTime.now();
  DateTime _lastDate = DateTime.utc(2050, 12, 31, 12, 0, 0, 0, 0);

  List<String> conditionList = [];
  late String? _conditionList = null;
  String conditionVal = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conditionList.add('Select');
  }

  @override
  Widget build(BuildContext context) {

    final conditionDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select Condition",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionVal = value!;
            });
          },
          items: conditionList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );

    final funcGradingDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select Func. & Grading",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionVal = value!;
            });
          },
          items: conditionList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
    final statusDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Triage Status",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionVal = value!;
            });
          },
          items: conditionList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
    final sourceDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select Triage Source",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionVal = value!;
            });
          },
          items: conditionList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
    final priorityDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select Priority",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _conditionList,
          onChanged: (value) {
            setState(() {
              _conditionList = value!;
              conditionVal = value!;
            });
          },
          items: conditionList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );


    Future<Null> _selectDate(BuildContext context, String isFromDate) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: _selectedDate,
          lastDate: _lastDate);
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          _date.value = TextEditingValue(text: picked.toString());
          DateFormat formatter = DateFormat('yyyy-MM-dd');
          if(_fromDate){
            fromDate = formatter.format(picked);
            fromDateController.text=fromDate;
          }else{
            toDate = formatter.format(picked);
            toDateController.text=toDate;
          }

        });
      }
    }

    final fromDateField =TextField(

        controller: fromDateController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        style: style,
        readOnly: true,
        onTap: (){
          _fromDate=true;
          _selectDate(context, "1");
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "From Date",
          hintText: "From Date",
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final toDateField =TextField(

        controller: toDateController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        style: style,
        readOnly: true,
        onTap: (){
          _fromDate=false;
          _selectDate(context, "1");
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "To Date",
          hintText: "To Date",
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final memoField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 30,
        controller: memoController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Triage Memo#",
          alignLabelWithHint: true,
          hintText: "Triage Memo#",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final skuField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 10,
        controller: skuController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Sku",
          alignLabelWithHint: true,
          hintText: "Sku",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (memoController.text.toString() == "") {
            _showToast("Triage Memo Number can't be empty");
          } else if (!Utilities.ActiveConnection) {
            _showToast("No internet connection found!");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TriageLookupPage2()),
            );
          }
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Triage Lookup',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            GestureDetector(
                child: Image.asset(
                  'assets/icon_back.png',
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage('')),
                  );
                }),
          ],
        ),
      ),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Column(
              children: <Widget>[
                memoField,
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                      child:  fromDateField,
                    ),
                    SizedBox(width: 20.0,),
                    new Flexible(
                      child: toDateField,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 13),child:  SizedBox(
                        height: 70,
                        child: skuField,
                      ),
                      )
                    ),
                    SizedBox(width: 20.0,),
                    new Flexible(
                      child: conditionDropdown,
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                funcGradingDropdown,
                SizedBox(height: 5,),
                statusDropdown,
                SizedBox(height: 5,),
                sourceDropdown,
                SizedBox(height: 5,),
                priorityDropdown,
                SizedBox(height: 45,),
                submitButton
              ],
            ),
          ),
        ),
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
}
