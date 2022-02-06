import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as glob;

final form = NumberFormat("#,##0", "en_US");

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.con}) : super(key: key);

  final PostgreSQLConnection con;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var account = [];
  var projectsList = [];

  Future getProjects() async {
    projectsList = await widget.con.query(
        "SELECT * FROM projects where user_id = @id",
        substitutionValues: {"id": glob.user[0]});
    setState(() {});
    return projectsList;
  }

  getAccount() async {
    account = await widget.con.query("SELECT * FROM accounts where id = @id",
        substitutionValues: {"id": glob.user[3]});
    setState(() {});
  }

  Future getTransaction() async {
    var transactions = [];
    var userAccount = {};
    late Map<String, double> allTransactions = {};

    transactions = await widget.con.query(
        "SELECT * FROM transactions where account_id_from = @id",
        substitutionValues: {"id": glob.user[3]});
    late List accountsList = [];
    for (var element in transactions) {
      if (!accountsList.contains(element[2])) {
        accountsList.add(element[2]);
      }
    }
    var users = await widget.con.query(
        "SELECT account_id, login FROM users where account_id in (${accountsList.join(',')})");
    var projects = await widget.con.query(
        "SELECT account_id, login FROM projects where account_id in (${accountsList.join(',')})");
    for (var element in (users + projects)) {
      userAccount[element[0]] = element[1];
    }
    for (var element in transactions) {
      if (allTransactions.containsKey(userAccount[element[2]])) {
        allTransactions[userAccount[element[2]].toString()] =
            allTransactions[userAccount[element[2]].toString()]! +
                element[3].toDouble();
      } else {
        allTransactions[userAccount[element[2]].toString()] =
            element[3].toDouble();
      }
    }
    glob.listTransactions = [];
    for (var i in transactions) {
      glob.listTransactions.add(
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 167, 65, 1),
                borderRadius: BorderRadius.circular(12)),
            height: MediaQuery.of(context).size.height / 12,
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Send artembly to ',
                        style: TextStyle(color: Color.fromRGBO(27, 27, 27, 1))),
                    TextSpan(
                        text: userAccount[i[2]].toString(),
                        style: const TextStyle(
                            color: Color.fromRGBO(27, 27, 27, 1),
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ": " + form.format(i[3]) + " Ab",
                        style: const TextStyle(
                            color: Color.fromRGBO(27, 27, 27, 1),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
      );
    }
    setState(() {
      glob.allTransaction = allTransactions;
    });
    return allTransactions;
  }

  @override
  void initState() {
    getAccount();
    getProjects();
    getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(182, 169, 162, 1),
      body: [
        Stack(
          children: [
            Container(),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 12),
              child: RefreshIndicator(
                backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
                color: const Color.fromRGBO(243, 167, 65, 1),
                onRefresh: getTransaction,
                child: ListView(
                  children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(27, 27, 27, 1),
                              borderRadius: BorderRadius.circular(20)),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 10,
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 40,
                            left: 40,
                            bottom: 30,
                          ),
                          child: Center(
                              child: Text(
                            (account.isNotEmpty
                                    ? form.format(account[0][1])
                                    : "0") +
                                " Ab",
                            style: const TextStyle(
                                color: Color.fromRGBO(243, 167, 65, 1),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        glob.allTransaction.isNotEmpty
                            ? PieChart(dataMap: glob.allTransaction)
                            : SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                child: const Center(
                                  child: Text("У вас нет трат"),
                                ),
                              ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: const Center(
                              child: Text(
                            "Your transactions",
                            style: TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ] +
                      glob.listTransactions,
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(27, 27, 27, 1),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Your",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height / 17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(243, 167, 65, 1),
                        ),
                        child: const Center(
                            child: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                      )
                    ],
                  ),
                ],
              )),
            ),
          ],
        ),
        Stack(children: [
          Container(),
          projectsList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 17 + 71),
                  child: RefreshIndicator(
                    backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
                    color: const Color.fromRGBO(243, 167, 65, 1),
                    onRefresh: getProjects,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: projectsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: MediaQuery.of(context).size.height / 13,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                  shadowColor: Colors.black,
                                  primary:
                                      const Color.fromRGBO(243, 167, 65, 1)),
                              child: Center(
                                child: Text(
                                  projectsList[index][1],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                    strokeWidth: 5,
                  ),
                ),
          Container(
            color: const Color.fromRGBO(27, 27, 27, 1),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7,
            child: Center(
                child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Your",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.height / 17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(243, 167, 65, 1),
                      ),
                      child: const Center(
                          child: Text(
                        "Projects",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                    )
                  ],
                ),
              ],
            )),
          ),
        ]),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              MyIcon.chart_pie,
              size: 35,
              color: Colors.orange,
            ),
            icon: Icon(
              MyIcon.chart_pie,
              size: 35,
              color: Color.fromRGBO(182, 169, 162, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              MyIcon.th_list,
              size: 35,
              color: Colors.orange,
            ),
            icon: Icon(
              MyIcon.th_list,
              size: 35,
              color: Color.fromRGBO(182, 169, 162, 1),
            ),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyIcon {
  MyIcon._();

  static const _kFontFam = 'MyIcon';
  static const String? _kFontPkg = null;

  static const IconData th_list =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_pie =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
