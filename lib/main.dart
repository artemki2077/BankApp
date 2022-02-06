import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homePage.dart';
import 'package:postgres/postgres.dart';
import "globals.dart" as glob;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isHidden = false;
  var connection;
  setConect() async {
    connection = PostgreSQLConnection("localhost", 5433, "bank",
        username: "postgres", password: "postgres");
    await connection.open();
  }

  late String error = '';
  late String password;
  late String login;

  @override
  void initState() {
    setConect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(182, 169, 162, 1),
        body: Stack(
          children: [
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
                        "Artem",
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
                          "Bank",
                          style: TextStyle(fontSize: 25),
                        )),
                      )
                    ],
                  ),
                ],
              )),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                    cursorColor: const Color.fromRGBO(243, 167, 65, 1),
                    autofillHints: const [AutofillHints.password],
                    keyboardType: TextInputType.visiblePassword,
                    onEditingComplete: () => TextInput.finishAutofillContext(),
                    onChanged: (e) {
                      login = e;
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(243, 167, 65, 1),
                      iconColor: const Color.fromRGBO(243, 167, 65, 1),
                      focusColor: const Color.fromRGBO(243, 167, 65, 1),
                      hintText: "Логин",
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
                    obscureText: isHidden,
                    autofillHints: const [AutofillHints.password],
                    keyboardType: TextInputType.visiblePassword,
                    onEditingComplete: () => TextInput.finishAutofillContext(),
                    onChanged: (e) {
                      password = e;
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(243, 167, 65, 1),
                      iconColor: const Color.fromRGBO(243, 167, 65, 1),
                      focusColor: const Color.fromRGBO(243, 167, 65, 1),
                      suffixIcon: IconButton(
                        icon: isHidden
                            ? const Icon(
                                Icons.visibility_off,
                                color: Color.fromRGBO(243, 167, 65, 1),
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Color.fromRGBO(243, 167, 65, 1),
                              ),
                        onPressed: togglePasswordVisibility,
                      ),
                      hintText: "Пароль",
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(243, 167, 65, 1)),
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
                        Icons.lock,
                        color: Color.fromRGBO(243, 167, 65, 1),
                      ),
                    )),
              ),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    List<List<dynamic>> results = await connection.query(
                        "SELECT * from users where password = @password and login = @login",
                        substitutionValues: {
                          "login": login,
                          "password": password
                        });
                    if (results.isNotEmpty) {
                      glob.user = results[0];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    con: connection,
                                  )));
                    } else {
                      setState(() {
                        error = 'not such user';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(27, 27, 27, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  child: const Center(
                      child: Text(
                    "Вход",
                    style: TextStyle(
                        color: Color.fromRGBO(243, 167, 65, 1), fontSize: 30),
                  )),
                ),
              )
            ]),
          ],
        ));
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}
