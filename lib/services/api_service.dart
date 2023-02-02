import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';

class ApiService {
  final String apiUrl = "https://patient-data-api.herokuapp.com/api/patient";

  Future<List<Patient>> getPatient() async {
    log("in get patient");
    Response res = await get(Uri.parse(apiUrl));

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      Map<String, dynamic> data = body["data"];
      List<dynamic> patientData = data["data"];
      List<Patient> patient =
          patientData.map((dynamic item) => Patient.fromJson(item)).toList();
      return patient;
    } else {
      throw "Failed to load patient list";
    }
  }

  Future<Object> createPatient(Patient patient) async {
    Map data = {
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'gender': patient.gender,
      'age': patient.age,
      'address': patient.address,
      'mobile': patient.mobile,
      'email': patient.email,
    };
    log("data: $data");
    final Response response = await post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return {"success": true}; //Patient.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String message = body["message"] ?? "";

      return {"success": false};
    } else {
      return {"success": false};
    }
  }

  Future<Object> updatePatient(String id, Patient patient) async {
    Map data = {
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'gender': patient.gender,
      'age': patient.age,
      'address': patient.address,
      'mobile': patient.mobile,
      'email': patient.email,
    };

    final Response response = await put(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }

  Future<void> deletePatient(String id) async {
    Response res = await delete(Uri.parse('$apiUrl/$id'));

    if (res.statusCode == 200) {
      print("Case deleted");
    } else {
      throw "Failed to delete a case.";
    }
  }
}
