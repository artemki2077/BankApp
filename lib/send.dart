import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter/services.dart';

class Send extends StatefulWidget {
  const Send({Key? key, required this.con, required this.account})
      : super(key: key);

  final account;
  final PostgreSQLConnection con;
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  late String login;
  late String amount;
  late String comment;

  var nameError;
  var amountError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(182, 169, 162, 1),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      cursorColor: const Color.fromRGBO(243, 167, 65, 1),
                      autofillHints: const [AutofillHints.password],
                      keyboardType: TextInputType.visiblePassword,
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      onChanged: (e) {
                        setState(() {
                          nameError = null;
                          login = e;
                        });
                      },
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(243, 167, 65, 1),
                        iconColor: const Color.fromRGBO(243, 167, 65, 1),
                        focusColor: const Color.fromRGBO(243, 167, 65, 1),
                        hintText: "Name",
                        errorText: nameError,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: const Icon(
                          Icons.account_circle_rounded,
                          color: Color.fromRGBO(243, 167, 65, 1),
                        ),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                      cursorColor: const Color.fromRGBO(243, 167, 65, 1),
                      autofillHints: const [AutofillHints.password],
                      keyboardType: TextInputType.visiblePassword,
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      onChanged: (e) {
                        amountError = null;
                        amount = e;
                      },
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(243, 167, 65, 1),
                        iconColor: const Color.fromRGBO(243, 167, 65, 1),
                        focusColor: const Color.fromRGBO(243, 167, 65, 1),
                        hintText: "Amount",
                        errorText: amountError,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: const Icon(
                          Icons.monetization_on,
                          color: Color.fromRGBO(243, 167, 65, 1),
                        ),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                      cursorColor: const Color.fromRGBO(243, 167, 65, 1),
                      autofillHints: const [AutofillHints.password],
                      keyboardType: TextInputType.visiblePassword,
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      onChanged: (e) {
                        comment = e;
                      },
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(243, 167, 65, 1),
                        iconColor: const Color.fromRGBO(243, 167, 65, 1),
                        focusColor: const Color.fromRGBO(243, 167, 65, 1),
                        hintText: "Comment",
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(27, 27, 27, 1)),
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: const Icon(
                          Icons.comment,
                          color: Color.fromRGBO(243, 167, 65, 1),
                        ),
                      )),
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 12,
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromRGBO(243, 167, 65, 1),
                            primary: const Color.fromRGBO(27, 27, 27, 1)),
                        onPressed: () async {
                          var n = 0;
                          if (login == Null) {
                            nameError = "Wtf";
                          }
                          var projects = await widget.con.query(
                              "SELECT * FROM projects where login = @login",
                              substitutionValues: {"login": login});
                          var users = await widget.con.query(
                              "SELECT * FROM users where login = @login",
                              substitutionValues: {"login": login});
                          if ((projects + users).isEmpty) {
                            nameError = "not such user";
                          } else {
                            n++;
                          }
                          if (!isNumeric(amount)) {
                            amountError = "is not number";
                          } else if (widget.account[0][1] <
                              double.parse(amount)) {
                            amountError = "not enough money";
                          } else {
                            n++;
                          }
                          if (n == 2) {
                            var accountTo = await widget.con.query(
                                "SELECT * FROM accounts where id = @id",
                                substitutionValues: {
                                  "id": (projects + users)[0][3]
                                });
                            await widget.con.query(
                                "Update accounts set  balance = @balance where id = @id",
                                substitutionValues: {
                                  "balance": accountTo[0][1] +
                                      double.parse(amount).toInt(),
                                  "id": (projects + users)[0][3]
                                });
                            await widget.con.query(
                                "Update accounts set  balance = @balance where id = @id",
                                substitutionValues: {
                                  "id": widget.account[0][0],
                                  "balance": widget.account[0][1] -
                                      double.parse(amount).toInt()
                                });
                            await widget.con.query(
                                "INSERT INTO transactions (account_id_from, account_id_to, amount, comment) VALUES (@account_from, @account_to, @amount, @comment);",
                                substitutionValues: {
                                  "account_from": widget.account[0][0],
                                  "account_to": accountTo[0][0],
                                  "amount": double.parse(amount).toInt(),
                                  "comment": comment,
                                });
                            Navigator.pop(context);
                          }
                          setState(() {});
                        },
                        child: const Center(
                          child: Text("Send"),
                        )))
              ],
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
                    const Text(
                      "Send",
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
                      child: const Center(
                          child: Text(
                        "money",
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
    );
  }
}
