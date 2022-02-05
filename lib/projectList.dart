import 'package:flutter/material.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(182, 169, 162, 1),
      body: Stack(children: [
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
      ]),
    );
  }
}
