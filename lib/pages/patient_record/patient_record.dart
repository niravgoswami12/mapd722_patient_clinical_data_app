import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient_record.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/add_patient_record_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/patient_record_list.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientRecordHomePage extends StatefulWidget {
  const PatientRecordHomePage(this.patient, {super.key});
  final patient;

  @override
  _PatientRecordHomePageState createState() => _PatientRecordHomePageState();
}

class _PatientRecordHomePageState extends State<PatientRecordHomePage> {
  final ApiService api = ApiService();

  List<PatientRecord> patientRecordList = [];

  @override
  void initState() {
    loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    patientRecordList ??= <PatientRecord>[];
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
          return patientRecordList.length > 0
              ? PatientRecordList(
                  patient: widget.patient, patientRecords: patientRecordList)
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
    Future<List<PatientRecord>> futurePatientRecords =
        api.getPatientRecord(widget.patient.id);
    futurePatientRecords.then((patientRecordList) {
      setState(() {
        this.patientRecordList = patientRecordList;
      });
    });
    return futurePatientRecords;
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPatientRecordWidget(widget.patient)),
    ).then((value) => {});
  }
}
