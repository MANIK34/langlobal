import 'package:flutter/material.dart';
import 'package:langlobal/summary/fulfillment/LogsPage.dart';
import 'package:langlobal/summary/fulfillment/lineItemsPage.dart';
import 'package:langlobal/summary/fulfillment/tabPage.dart';

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
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 7, vsync: this);
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
                  'Sales Order',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                GestureDetector(
                    child: Container(
                        width: 85,
                        height: 80,
                        child: Center(
                          child: ElevatedButton(
                            child: const Text('Search'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                GestureDetector(
                    child: Container(
                        width: 120,
                        height: 80,
                        child: Center(
                          child: ElevatedButton(
                            child: const Text('Provisioning'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              TabPage(fulfillmentInfo),
              LineItemsPage(fulfillmentInfo),
              LogsPage(fulfillmentInfo),
              Container(child: Icon(Icons.logout)),
              Container(child: Icon(Icons.logout)),
            ],
          ),
        ),
      ),
    );
  }
  Widget menu() {
    return Container(
      color: Colors.blue,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "Details",
            icon: Icon(Icons.details),
          ),
          Tab(
            text: "Line Items",
            icon: Icon(Icons.assignment),
          ),
          Tab(
            text: "Logs",
            icon: Icon(Icons.account_balance_wallet),
          ),
          Tab(
            text: "Ship",
            icon: Icon(Icons.settings),
          ),
          Tab(
            text: "Docs",
            icon: Icon(Icons.file_copy),
          ),
        ],
      ),
    );
  }
}
