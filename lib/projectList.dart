import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'globals.dart' as glob;

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key, required this.con})
      : super(
          key: key,
        );

  final PostgreSQLConnection con;

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  var projectsList = [];
  getProjects() async {
    projectsList = await widget.con.query(
        "SELECT * FROM projects where user_id = @id",
        substitutionValues: {"id": glob.user[0]});
    setState(() {});
  }

  @override
  void initState() {
    getProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(182, 169, 162, 1),
      body: Stack(children: [
        Container(),
        projectsList.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 17 + 71),
                child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: projectsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 13,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              primary: const Color.fromRGBO(243, 167, 65, 1)),
                          child: Center(
                            child: Text(
                              projectsList[index][1],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
