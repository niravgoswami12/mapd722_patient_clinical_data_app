import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient_record.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/edit_patient_record_widget.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientRecordList extends StatelessWidget {
  final Patient patient;
  final List<PatientRecord> patientRecords;
  final ApiService api = ApiService();

  PatientRecordList(
      {Key? key, required this.patient, required this.patientRecords})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map dataTypeOption = {
      'blood_pressure': 'Blood Pressure',
      'respiratory_rate': 'Respiratory Rate',
      'blood_oxygen_level': 'Blood Oxygen Level',
      'heartbeat_rate': 'Heartbeat Rate',
    };
    Map<String, SizedBox> dataTypeImage = {
      'blood_pressure': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.color),
          child: Image(image: AssetImage('assets/images/blood_pressure.png')),
        ),
      ),
      'respiratory_rate': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.color),
          child: Image(image: AssetImage('assets/images/respiratory_rate.png')),
        ),
      ),
      'blood_oxygen_level': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.color),
          child:
              Image(image: AssetImage('assets/images/blood_oxygen_level.png')),
        ),
      ),
      'heartbeat_rate': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.color),
          child: Image(image: AssetImage('assets/images/heartbeat_rate.png')),
        ),
      )
    };

    Map readingUnits = {
      'blood_pressure': 'mmHg',
      'respiratory_rate': '/min',
      'blood_oxygen_level': '%',
      'heartbeat_rate': '/min',
    };
    return ListView.builder(
        itemCount: patientRecords == null ? 0 : patientRecords.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: dataTypeImage[patientRecords[index].dataType],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${dataTypeOption[patientRecords[index].dataType]} ",
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                      "${patientRecords[index].reading} ${readingUnits[patientRecords[index].dataType]} ",
                      style: const TextStyle(
                        fontSize: 14.0,
                      )),
                  const SizedBox(height: 5),
                  Text(
                      DateFormat.yMEd().add_jm().format(
                          DateTime.parse(patientRecords[index].dateTime)
                              .toLocal()),
                      style: const TextStyle(
                        fontSize: 10.0,
                      ))
                ],
              ),
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
                          builder: (context) => EditPatientRecordWidget(
                              patient, patientRecords[index]),
                        ));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20.0,
                  ),
                  onPressed: () {
                    _deletePatient(
                        context, patient.id, patientRecords[index].id);
                  },
                ),
              ]),
            ),
          ));
        });
  }

  _deletePatient(
      BuildContext context, String patientId, String recordId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                api.deletePatientRecord(patientId, recordId);
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
