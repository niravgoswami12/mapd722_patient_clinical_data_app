import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/add_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/detail_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/edit_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientList extends StatelessWidget {
  final List<Patient> patient;
  final ApiService api = ApiService();

  PatientList({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: patient == null ? 0 : patient.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailWidget(patient[index])),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                  "${patient[index].firstName} ${patient[index].lastName}"),
              // subtitle: Text(patient[index].age.toString()),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditPatientWidget(patient[index])),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20.0,
                  ),
                  onPressed: () {
                    _deletePatient(context, patient[index]);
                  },
                ),
              ]),
            ),
          ));
        });
  }

  _deletePatient(BuildContext context, Patient patient) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                api.deletePatient(patient.id);
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
