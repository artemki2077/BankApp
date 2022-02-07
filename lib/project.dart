import 'package:flutter/material.dart';
import 'globals.dart' as glob;
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'send.dart';

final form = NumberFormat("#,##0", "en_US");

class Project extends StatefulWidget {
  const Project({Key? key, required this.con}) : super(key: key);
  final PostgreSQLConnection con;

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  var account = [];
  var projectsList = [];
  var send = [];
  var getFrom = [];
  var acounsName = {};
  late List<Widget> sendWidget = <Widget>[];
  late List<Widget> getWidget = <Widget>[];

  getAccount() async {
    account = await widget.con.query("SELECT * FROM accounts where id = @id",
        substitutionValues: {"id": glob.project[3]});
    setState(() {});
  }

  getUsers() async {
    var transactions = [];
    var accounts = [];
    var usersSendSum = {};
    var usersGetSum = {};

    transactions = await widget.con.query(
        "SELECT * FROM transactions where account_id_to = @id or account_id_from = @id ",
        substitutionValues: {"id": glob.project[3]});
    for (var i in transactions) {
      if (i[1] == glob.project[3]) {
        send.add(i);
      } else {
        getFrom.add(i);
      }

      if (!accounts.contains(i[1]) && i[1] != glob.project[3]) {
        accounts.add(i[1]);
      }
      if (!accounts.contains(i[2]) && i[2] != glob.project[3]) {
        accounts.add(i[2]);
      }
    }
    var users = await widget.con.query(
        "SELECT account_id, login FROM users where account_id in (${accounts.join(',')})");
    var projects = await widget.con.query(
        "SELECT account_id, login FROM projects where account_id in (${accounts.join(',')})");
    for (var i in (users + projects)) {
      if (!this.acounsName.containsKey(i[0])) {
        this.acounsName[i[0]] = i[1];
      }
    }
    for (var i in send) {
      if (!usersSendSum.containsKey(i[2])) {
        usersSendSum[i[2]] = i[3];
      } else {
        usersSendSum[i[2]] += i[3];
      }
    }
    for (var i in getFrom) {
      if (!usersGetSum.containsKey(i[1])) {
        usersGetSum[i[1]] = i[3];
      } else {
        usersGetSum[i[1]] += i[3];
      }
    }
    for (var i in usersGetSum.keys) {
      this.getWidget.add(Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 167, 65, 1),
                borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 12,
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text("${this.acounsName[i]} : ${usersGetSum[i]} Ab",
                  style: const TextStyle(
                      color: Color.fromRGBO(27, 27, 27, 1),
                      fontWeight: FontWeight.bold)),
            ),
          ));
    }
    for (var i in usersSendSum.keys) {
      this.sendWidget.add(Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 167, 65, 1),
                borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 12,
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text("${this.acounsName[i]} : ${usersSendSum[i]} Ab",
                  style: const TextStyle(
                      color: Color.fromRGBO(27, 27, 27, 1),
                      fontWeight: FontWeight.bold)),
            ),
          ));
    }

    setState(() {});
  }

  Future getTransaction() async {
    getAccount();
    var transactions = [];
    var userAccount = {};
    late Map<String, double> allTransactions = {};

    transactions = await widget.con.query(
        "SELECT * FROM transactions where account_id_to = @id",
        substitutionValues: {"id": glob.project[3]});
    late List accountsList = [];
    for (var element in transactions) {
      if (!accountsList.contains(element[1])) {
        accountsList.add(element[1]);
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
      if (allTransactions.containsKey(userAccount[element[1]].toString())) {
        allTransactions[userAccount[element[1]].toString()] =
            allTransactions[userAccount[element[1]].toString()]! +
                element[3].toDouble();
      } else {
        allTransactions[userAccount[element[1]].toString()] =
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
                        text: 'get money from ',
                        style: TextStyle(color: Color.fromRGBO(27, 27, 27, 1))),
                    TextSpan(
                        text: userAccount[i[1]].toString(),
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
    getUsers();
    getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
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
                              child: Text("You have no expenses"),
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
                  (glob.listTransactions.isEmpty
                      ? const [Center(child: Text("pass"))]
                      : glob.listTransactions) +
                  [
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                            const Text(
                              "helping",
                              style: TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ] +
                          (this.sendWidget.isNotEmpty
                              ? this.sendWidget
                              : [
                                  Center(
                                    child: Text("pass"),
                                  )
                                ]),
                    ),
                  ],
            ),
          ),
        ),
        Container(),
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
                  const Spacer(
                    flex: 4,
                  ),
                  const Text(
                    "Project",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                    child: Center(
                        child: Text(
                      glob.project[1],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Send(
                                    con: widget.con,
                                    account: account,
                                  )));
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ],
          )),
        ),
      ]),
      backgroundColor: const Color.fromRGBO(182, 169, 162, 1),
    );
  }
}
