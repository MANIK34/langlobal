import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:langlobal/summary/fulfillment/DocsPage.dart';
import 'package:langlobal/summary/fulfillment/LogsPage.dart';
import 'package:langlobal/summary/fulfillment/lineItemsPage.dart';
import 'package:langlobal/summary/fulfillment/orderSearchPage.dart';
import 'package:langlobal/summary/fulfillment/provisioning/lineItem.dart';
import 'package:langlobal/summary/fulfillment/shipmentPage.dart';
import 'package:langlobal/summary/fulfillment/tabPage.dart';

import '../../dashboard/DashboardPage.dart';

class SalesOrderPage extends StatefulWidget {

  var fulfillmentInfo;
  SalesOrderPage(this.fulfillmentInfo,{Key? key}) : super(key: key);

  @override
  _SalesOrderPage createState() => _SalesOrderPage(this.fulfillmentInfo);
}

class _SalesOrderPage extends State<SalesOrderPage>
    with SingleTickerProviderStateMixin {

  _SalesOrderPage(this.fulfillmentInfo);
  var fulfillmentInfo;

  bool IsVerifyTokenCalled = false;
  String device_id = '';
  String user_mobile_number = '';
  int user_id = 0;
  String sessionToken = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget appBarTitle = const Text("Fulfillment Sales Order",
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black));
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  TextEditingController payeeCodeController = new TextEditingController();
  bool visibilityObs = false;
  bool _visibleProvisioning=false;
  late TabController tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 7, vsync: this);
    if(fulfillmentInfo['orderType']=="B2C"){
      setState(() {
        _visibleProvisioning=true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              children: [
                const Text(
                  'Fulfillment Lookup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderSearchPage('Fulfillment Lookup')),
                      );
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
               Visibility(
                 visible: _visibleProvisioning,
                 child:  GestureDetector(
                   child: Container(
                       width: 120,
                       height: 80,
                       child: Center(
                         child: ElevatedButton(
                           child: const Text('Provisioning'),
                           onPressed: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => LineItemPage(fulfillmentInfo,false)),
                             );
                           },
                         ),
                       )),
                   onTap: () {
                     Navigator.of(context).pop();
                   }),)
              ],
            ),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              TabPage(fulfillmentInfo),
              LineItemsPage(fulfillmentInfo),
              ShipmentPage(fulfillmentInfo),
              LogsPage(fulfillmentInfo),
              DocsPage(fulfillmentInfo),
            ],
          ),
        ),
      ),
    );
  }
  Widget menu() {
    return Padding(padding: EdgeInsets.only(top: 10),
    child: Container(
      color: Colors.blue,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "Info",
            icon: Icon(Icons.details),
          ),
          Tab(
            text: "Items",
            icon: Icon(Icons.assignment),
          ),
          Tab(
            text: "Ship",
            icon: Icon(Icons.account_balance_wallet),
          ),
          Tab(
            text: "Logs",
            icon: Icon(Icons.settings),
          ),
          Tab(
            text: "Docs",
            icon: Icon(Icons.file_copy),
          ),
        ],
      ),
    ),);
  }
}
