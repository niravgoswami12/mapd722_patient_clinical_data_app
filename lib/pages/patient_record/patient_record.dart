import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/add_patient_record_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/patient_record_list.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientRecordHomePage extends StatefulWidget {
  const PatientRecordHomePage({Key? key}) : super(key: key);

  @override
  _PatientRecordHomePageState createState() => _PatientRecordHomePageState();
}

class _PatientRecordHomePageState extends State<PatientRecordHomePage> {
  final ApiService api = ApiService();
  List<Patient> patientList = [];

  @override
  void initState() {
    loadList();
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Patient Record List"),
      ),
      body: Center(child: FutureBuilder(
        // future: loadList(),
        builder: (context, snapshot) {
          return patientList.length > 0
              ? PatientRecordList(patient: patientList)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future loadList() {
    Future<List<Patient>> futurePatient = api.getPatient();
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
      MaterialPageRoute(builder: (context) => AddPatientRecordWidget()),
    ).then((value) => {});
  }
}
