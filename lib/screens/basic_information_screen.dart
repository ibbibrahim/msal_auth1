import 'package:flutter/material.dart';

class BasicInformationScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final String studentFullName;

  BasicInformationScreen({
    required this.studentData,
    required this.studentFullName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.1
                : MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 40.0, 16.0, 16.0), // Top padding increased
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Student Detials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInfoTableCard('Basic Information', [
                      ['Name', studentFullName],
                      ['QID', studentData['QID']],
                      ['DOB', studentData['DOB']],
                      ['Age', studentData['Age'].toString()],
                      ['Religion', studentData['ReligionID'] == '1' ? 'Islam' : 'Other'],
                    ]),
                    SizedBox(height: 20),
                    _buildInfoTableCard('Address', [
                      ['Unit No', studentData['UnitNo'].toString()],
                      ['House No', studentData['HosueNo']],
                      ['Street No', studentData['StreetNo'].toString()],
                      ['Street Name', studentData['StreetName']],
                      ['Zone No', studentData['ZoneNo'].toString()],
                      ['Zone Name', studentData['ZoneName']],
                      ['Zip Code', studentData['ZipCode'] ?? 'N/A'], // Assuming Zip Code field
                      ['Flat/Villa', studentData['FlatVilla'] == 0 ? 'Flat' : 'Villa'],
                      ['Compound Name', studentData['CompoundName'] ?? 'N/A'],
                      ['Nearest Landmark', studentData['NearestLandmark'] ?? 'N/A'],
                      ['City', studentData['City'].toString()],
                      ['State', studentData['State']],
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTableCard(String title, List<List<String>> data) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16.0),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(color: Colors.grey[300]!),
              children: data.map((row) {
                return TableRow(
                  children: row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cell,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
