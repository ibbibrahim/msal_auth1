import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:msal_auth1/screens/basic_information_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedCard;
  bool showWelcome = true;

  void _showCard(String cardName) {
    setState(() {
      selectedCard = cardName;
    });
  }

  void _goBack() {
    setState(() {
      selectedCard = null;
    });
  }

  void _showFatherDetails() {
    setState(() {
      selectedCard = 'Profile';
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Map<String, dynamic> studentData = args['student'];
    final hasSiblings = args['hasSiblings'] ?? false;
    final siblingsList = args['siblings'] ?? null;

    String studentShortName =
        '${studentData['FirstName']} ${studentData['MiddleName']}';
    String studentFullName =
        '${studentData['Student Full Name']}';
    String fatherFullName =
        '${studentData['FatherFirstName']}${studentData['FatherMiddleName']} ${studentData['FatherLastName']}';
    String motherFullName =
        '${studentData['MotherFirstName']}${studentData['MotherMiddleName']} ${studentData['MotherLastName']}';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),

          Positioned(
            top: 60,
            right: 0,
            child: Material(
              shape: CircleBorder(),
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: _logout,
                iconSize: 25.0,
                padding: EdgeInsets.all(5.0),
                splashRadius: 30.0,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 35,
            child: Material(
              shape: CircleBorder(),
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: _showFatherDetails,
                iconSize: 30.0,
                padding: EdgeInsets.all(5.0),
                splashRadius: 30.0,
              ),
            ),
          ),
          _buildStudentAvatar(studentData),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 100.0),
                //   // child: AnimatedTextKit(
                //   //   animatedTexts: [
                //   //     TypewriterAnimatedText(
                //   //       'Welcome, $fatherFullName',
                //   //       speed: Duration(milliseconds: 200),
                //   //       textStyle: TextStyle(
                //   //         fontSize: 12,
                //   //         fontWeight: FontWeight.bold,
                //   //         color: Colors.white,
                //   //       ),
                //   //       curve: Curves.easeInOut,
                //   //     ),
                //   //     TypewriterAnimatedText(
                //   //       '',
                //   //       speed: Duration(milliseconds: 100),
                //   //       textStyle: TextStyle(
                //   //         fontSize: 12,
                //   //         fontWeight: FontWeight.bold,
                //   //         color: Colors.white,
                //   //       ),
                //   //       curve: Curves.easeInOut,
                //   //       textAlign: TextAlign.start,
                //   //       cursor: '',
                //   //       // This handles the backspace effect by starting with an empty string
                //   //     ),
                //   //   ],
                //   //   totalRepeatCount: 1,
                //   //   onFinished: () {
                //   //     setState(() {
                //   //       showWelcome = false;
                //   //     });
                //   //   },
                //   // ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Row(
                    children: [
                      Text(
                        '${studentData['StudentID']} - $studentShortName -',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        studentData['G'] == 'M' ? 'assets/boy.png' : 'assets/girl.png',
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Text(
                    '${studentData['Section']} - ${studentData['Campus']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bus Details
                      Row(
                        children: [
                          Icon(
                            Icons.directions_bus, // Bus icon
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(width: 4.0), // Add a small gap between the icon and text
                          Text(
                            studentData['Bus'] != null
                                ? '- ${studentData['Bus']}' // Show the bus number if assigned
                                : '- N/A', // Show "Not assigned" if the bus is null
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        selectedCard == null
                            ? GridView.count(
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
                              ? 4 // 2 cards per row in portrait mode
                              : 5, // 3 cards per row in landscape mode
                          childAspectRatio: 1, // Make cards square
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          padding: EdgeInsets.all(6.0),
                          children: <Widget>[
                            _buildCard(Icons.info,  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BasicInformationScreen(
                                    studentData: studentData,
                                    studentFullName: studentFullName,
                                  ),
                                ),
                              );
                            }),
                            _buildCard(Icons.person_2, () {
                              _showCard('Parent Information');
                            }),
                            _buildCard(Icons.school, () {
                              _showCard('Enrollment Information');
                            }),
                            if (hasSiblings)
                              _buildCard(Icons.groups_2, () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/siblings',
                                  arguments: siblingsList,
                                );
                              }),
                          ],
                        )
                            : _buildDetailsView(
                          cardName: selectedCard!,
                          studentData: studentData,
                          studentFullName: studentFullName,
                          fatherFullName: fatherFullName,
                          motherFullName: motherFullName,
                          onBack: _goBack,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Center(
                            child: Opacity(
                              opacity: 0.2, // Adjust opacity as needed
                              child: Image.asset(
                                'assets/tng_logo.png',
                                width: 100.0, // Adjust size as needed
                                height: 100.0, // Adjust size as needed
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAvatar(Map<String, dynamic> studentData) {
    String studentId = studentData['StudentID'].toString();

    // The base URL for the student photos
    String imageUrlBase = 'https://pers.tngqatar.online/Controler/Public/images/studentPhotos/';

    // Try both JPG and jpg extensions
    String imageUrlJpg = '$imageUrlBase$studentId.jpg';
    String imageUrlJPG = '$imageUrlBase$studentId.JPG';

    return Positioned(
      top: 45,
      left: 5,
      child: GestureDetector(
        onTap: () => _showStudentImageDialog(studentId), // Show the dialog on tap
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Adjust the padding as needed
          child: Container(
            width: 60.0, // Adjust width as needed
            height: 60.0, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.white, // Optional: add a background color
              borderRadius: BorderRadius.circular(8.0), // Adjust border radius for rectangle
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrlJpg),
              ),
            ),
            child: FutureBuilder<bool>(
              future: _checkImageExists(imageUrlJpg), // Check for jpg first
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    return Container(); // Return an empty container if image exists
                  } else {
                    return FutureBuilder<bool>(
                      future: _checkImageExists(imageUrlJPG), // Check for JPG if jpg fails
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == true) {
                            return Container(); // Return an empty container if image exists
                          } else {
                            // If both fail, fallback to a gender-based avatar
                            String avatarPath = studentData['G'] == 'M'
                                ? 'assets/boy.png'
                                : 'assets/girl.png';
                            return Container(
                              width: 60.0, // Match the dimensions of the avatar
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(avatarPath),
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(child: CircularProgressIndicator()); // Show a loading indicator while checking the image
                        }
                      },
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator()); // Show a loading indicator while checking the image
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showStudentImageDialog(String studentId) async {
    String imageUrlBase = 'https://pers.tngqatar.online/Controler/Public/images/studentPhotos/';
    String imageUrlJpg = '$imageUrlBase$studentId.jpg';
    String imageUrlJPG = '$imageUrlBase$studentId.JPG';

    // Check if the images exist before showing the dialog
    String? imageUrl;
    if (await _checkImageExists(imageUrlJpg)) {
      imageUrl = imageUrlJpg;
    } else if (await _checkImageExists(imageUrlJPG)) {
      imageUrl = imageUrlJPG;
    }

    if (imageUrl != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    color: Colors.blueAccent,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Student Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Handle the case where the image doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image not available"),
        ),
      );
    }
  }

  Future<bool> _checkImageExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Widget _buildCard(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 35, // Adjust size as needed
              color: Colors.blueAccent, // Adjust color as needed
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsView({
    required String cardName,
    required Map<String, dynamic> studentData,
    required String studentFullName,
    required String fatherFullName,
    required String motherFullName,
    required VoidCallback onBack,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (cardName == 'Basic Information') ...[
                  _buildInfoTableCard('Basic Information', [
                    ['Name', studentFullName],
                    ['QID', studentData['QID']],
                    ['DOB', studentData['DOB']],
                    ['Age', studentData['Age'].toString()],
                    ['Religion', studentData['ReligionID'] == '1' ? 'Islam' : 'Other'],

                  ], onBack),
                  _buildInfoTableCard('Address ', [
                    ['Unit No', studentData['UnitNo'].toString()],
                    ['House No', studentData['HosueNo']],
                    ['Street No', studentData['StreetNo'].toString()],
                    ['Street Name', studentData['StreetName']],
                    ['Zone No', studentData['ZoneNo'].toString()],
                    ['Zone Name', studentData['ZoneName']],
                    ['Zip Code', studentData['ZoneNo'].toString()], // Assuming Zip Code is the same as Zone No
                    ['Flat/Villa', studentData['FlatVilla'] == 0 ? 'Flat' : 'Villa'],
                    ['Compound Name', studentData['CompoundName'] ?? 'N/A'],
                    ['Nearest Landmark', studentData['NearestLandmark'] ?? 'N/A'],
                    ['City', studentData['City'].toString()], // Assuming City is represented as a number
                    ['State', studentData['State']],

                  ], onBack),

                ] else if (cardName == 'Profile') ...[
                  _buildInfoTableCard('Profile', [
                    ['Name', fatherFullName],
                    ['QID', studentData['FatherQatarID']],
                    ['Company', studentData['FatherCompany'] ?? 'N/A'],
                    ['Nationality', studentData['Nationality']],
                    ['Phone', studentData['FatherCellPhone']],
                  ], onBack),
                ] else if (cardName == 'Parent Information') ...[
                  _buildInfoTableCard('Father Information', [
                    ['Father Name', fatherFullName],
                    ['Father QID', studentData['FatherQatarID']],
                    ['Father Company', studentData['FatherCompany'] ?? 'N/A'],
                    ['Father Nationality', studentData['Nationality']],
                    ['Father Phone', studentData['FatherCellPhone']],
                  ], onBack),
                  _buildInfoTableCard('Mother Information', [
                    ['Mother Name', motherFullName],
                    ['Mother QID', studentData['MotherQatarID'] ?? 'N/A'],
                    ['Mother Company', studentData['MotherCompany'] ?? 'N/A'],
                    ['Mother Nationality', studentData['Nationality']],
                    ['Mother Phone', studentData['MotherCellPhone']],
                  ], onBack),
                ] else if (cardName == 'Enrollment Information') ...[
                  _buildInfoTableCard('Enrollment Information', [
                    ['Enrollment Information', 'Placeholder'],
                  ], onBack),
                ],
              ],
            ),
          ),
        ),
      ],

    );
  }

  Widget _buildInfoTableCard(String title, List<List<String>> data, VoidCallback onBack) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: onBack,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 4.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
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

  Future<void> _logout() async {
    //Clear any saved session data (e.g., SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/');
  }
}
