import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/add_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/patientlist.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage>
    with TickerProviderStateMixin {
  final ApiService api = ApiService();
  List<Patient> patientList = [];

  late TabController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    print("initState called");
    loadList(false);

    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      _controller.index == 0 ? loadList(false) : loadList(true);
      print("Selected Index: ${_controller.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patientList == null) {
      patientList = <Patient>[];
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Critical',
              ),
            ],
          ),
          title: const Text("Patient List"),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            Center(child: FutureBuilder(
              // future: loadList(),
              builder: (context, snapshot) {
                return patientList.length > 0
                    ? PatientList(patient: patientList)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.warning,
                              size: 100.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "No data found, tap plus button to add!",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      );
              },
            )),
            Center(child: FutureBuilder(
              // future: loadList(),
              builder: (context, snapshot) {
                return patientList.length > 0
                    ? PatientList(patient: patientList)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.warning,
                              size: 100.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "No data found, tap plus button to add!",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      );
              },
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddScreen(context);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future loadList(onlyCritical) {
    print("loadList called");
    patientList = [];
    Future<List<Patient>> futurePatient = api.getPatient(onlyCritical);
    futurePatient.then((patientList) {
      setState(() {
        this.patientList = patientList;
      });
    });
    return futurePatient;
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPatientWidget()),
    ).then((value) {
      print("Then called");
      _controller.index == 0 ? loadList(false) : _controller.animateTo(0);
    });
  }
}
