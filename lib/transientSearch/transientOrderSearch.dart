import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/transientSearch/transientOrderValidate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransientOrderSearchPage extends StatefulWidget {
  String heading = '';

  TransientOrderSearchPage(this.heading, {Key? key}) : super(key: key);

  @override
  _TransientOrderSearchPage createState() =>
      _TransientOrderSearchPage(this.heading);
}

class _TransientOrderSearchPage extends State<TransientOrderSearchPage> {
  String heading = '';

  _TransientOrderSearchPage(this.heading);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController skuController = TextEditingController();


  TextEditingController fromDateInput = TextEditingController();
  TextEditingController toDateInput = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDateInput.text = "";
    toDateInput.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final supplierNameField = TextField(
        maxLength: null,
        controller: supplierNameController,
        style: style,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Supplier Name",
          alignLabelWithHint: true,
          hintText: "Supplier Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final memoField = TextField(
        maxLength: null,
        controller: memoController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Order Number",
          alignLabelWithHint: true,
          hintText: "Order Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final skuField = TextField(
        maxLength: null,
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

    final fromDateField = TextField(
      controller: fromDateInput,
      //editing controller of this TextField
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Enter From Date" //label text of field
          ),
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          setState(() {
            fromDateInput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );

    final toDateField = TextField(
      controller: toDateInput,
      //editing controller of this TextField
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Enter To Date" //label text of field
          ),
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          setState(() {
            toDateInput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          callGetTransientOrderApi();
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Transient Order Search',
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
          ),
        ),
        drawer: DrawerElement(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 10, 36.0, 0.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 15.0,
                      ),
                      memoField,
                      const SizedBox(height: 60.0),
                      submitButton,
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
          ),
        ));
  }

  void callGetTransientOrderApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    var url = "http://api.sanvitti.com/transientreceive/v1/transientorder/"+memoController.text.toString();
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}'
    };
    print("URL>>>>>>>>>"+url);
    print("Token>>>>>>>>>"+token!);
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        var orderInfo= jsonResponse['transientOrderInfo'];
        var cartonList= orderInfo['cartonList'];
        print('returnCode'+ returnCode.toString());
        if(returnCode=="1"){
          var memoNumber=orderInfo['memoNumber'];
          var orderDate=orderInfo['transientOrderDateTime'];
          orderDate=orderDate.toString().substring(0,10);
          DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
          final DateFormat formatter = DateFormat('MM-dd-yyyy');
          var formatted = formatter.format(tempDate);
          print("FOrmatted>>>>>>>"+formatted);
          var orderStatus=orderInfo['orderTransientStatus'];
          print("orderDate::"+orderDate.toString());

          var sku=orderInfo['sku'];
          var category=orderInfo['categoryName'];
          var productName=orderInfo['productName'];
          var supplier=orderInfo['supplierName'];
          var cartonCount=orderInfo['quantityPerContainers'];
          var orderQty=orderInfo['orderedQty'];
          var transientOrderID=orderInfo['transientOrderID'];
          var isESNRequired=orderInfo['isESNRequired'];
          var palletID=cartonList[0]['palletID'];

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransientOrderValidatePage(memoNumber,formatted,
            orderStatus,sku,category,productName,supplier,cartonCount,orderQty,transientOrderID,isESNRequired,palletID)),
          );
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }

    } else {
      print(response.statusCode);
    }
    print(response.body);
    setState(() {
      _isLoading = false;
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
