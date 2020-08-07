import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_drawer.dart';
import '../widgets/dashboard_elements/hero_cards.dart';

import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _appUserCount = 'NA';
  String _ordersAverage = 'NA';
  String _successRate = 'NA';
  String _dayCount = 'NA';
  String _dayAmount = 'NA';
  String _monthCount = 'NA';
  String _monthAmount = 'NA';
  bool isInit = true;
  Future<void> _refreshDashboard(
      BuildContext context, bool forcedRefresh) async {
    final requestToken = Provider.of<Auth>(context, listen: false).token;
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $requestToken",
    };
    var url = 'http://10.0.2.2:8000/api/1/dashboard/';

    try {
      if (isInit || forcedRefresh) {
        final response = await http.get(url, headers: requestHeader);
        final extractedData = json.decode(response.body);
        setState(() {
          _appUserCount = extractedData['user_count'].toString();
          _ordersAverage = extractedData['order_avg'].toString();
          _successRate = extractedData['success_rate'].toString();
          _dayCount = extractedData['order_day_count'].toString();
          _dayAmount = extractedData['order_day_amount'].toString();
          _monthCount = extractedData['order_month_count'].toString();
          _monthAmount = extractedData['order_month_amount'].toString();
        });
      }
      isInit = false;
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed'),
          content: Text('Could not refresh the Dashboard'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirana Store'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cached),
            onPressed: () {
              _refreshDashboard(context, true);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshDashboard(context, false),
        builder: (_, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Dashboard(
                    appUserCount: _appUserCount,
                    ordersAg: _ordersAverage,
                    successRate: _successRate,
                    dayCount: _dayCount,
                    dayAmount: _dayAmount,
                    monthCount: _monthCount,
                    monthAmount: _monthAmount,
                  ),
      ),
    );
  }
}

Widget _getBoxCard(BuildContext ctx, Widget leading, String label1,
        String label2, Color cradThemeColor) =>
    Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: cradThemeColor.withAlpha(100),
          ),
        ],
      ),
      width: MediaQuery.of(ctx).size.width * 0.5 - 20,
      height: MediaQuery.of(ctx).size.height * 0.2 + 5,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              leading,
              Text(
                label1,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 25,
                  color: cradThemeColor,
                ),
              ),
              Text(
                label2,
                style: TextStyle(
                  fontSize: 20,
                  color: cradThemeColor,
                ),
              )
            ],
          ),
        ),
      ),
    );

class Dashboard extends StatelessWidget {
  final String appUserCount;
  final String ordersAg;
  final String successRate;
  final String dayCount;
  final String dayAmount;
  final String monthCount;
  final String monthAmount;

  const Dashboard({
    @required this.appUserCount,
    @required this.ordersAg,
    @required this.successRate,
    @required this.dayCount,
    @required this.dayAmount,
    @required this.monthCount,
    @required this.monthAmount,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView(
              controller: PageController(viewportFraction: 0.8),
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              children: <Widget>[
                HeroCard(
                  count: appUserCount,
                  label: 'Total Users',
                  icon: Icons.people,
                  cardTheme:
                      appUserCount == 'NA' ? Colors.redAccent : Colors.green,
                ),
                HeroCard(
                  count: ordersAg,
                  label: 'Orders /day',
                  icon: Icons.category,
                  cardTheme: ordersAg == 'NA' ? Colors.redAccent : Colors.amber,
                ),
                HeroCard(
                  count: successRate,
                  label: 'Success Rate',
                  icon: Icons.done_all,
                  cardTheme: successRate == 'NA'
                      ? Colors.redAccent
                      : Colors.deepPurpleAccent,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _getBoxCard(
                    context,
                    Container(
                      child: Image(
                        image: AssetImage(
                          'assets/images/rupee-symbol-file-white.png',
                        ),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    dayAmount,
                    'Today',
                    Colors.blueAccent),
                _getBoxCard(
                  context,
                  Icon(
                    Icons.cloud_upload,
                    size: 40,
                  ),
                  dayCount,
                  'Orders Total',
                  Colors.lightGreenAccent,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _getBoxCard(
                  context,
                  Container(
                    child: Image(
                      image: AssetImage(
                        'assets/images/rupee-symbol-file-white.png',
                      ),
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  monthAmount,
                  'This Month',
                  Colors.deepOrangeAccent,
                ),
                _getBoxCard(
                  context,
                  Icon(
                    Icons.cloud_circle,
                    size: 40,
                  ),
                  monthCount,
                  'Today',
                  Colors.yellowAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
