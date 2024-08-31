import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiblingInformationScreen extends StatelessWidget {
  final List<dynamic> siblings;

  SiblingInformationScreen({required this.siblings});

  @override
  Widget build(BuildContext context) {
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
                onPressed: (){},
                iconSize: 25.0,
                padding: EdgeInsets.all(5.0),
                splashRadius: 30.0,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Sibling Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: siblings.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/dashboard',
                              arguments: {'student': siblings[index],'siblings': siblings ,'hasSiblings': true},
                            );
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              title: Text(
                                siblings[index]['Student Full Name'] ?? 'N/A',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${siblings[index]['StudentID']} - ${siblings[index]['Section']}',
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
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

  Future<void> _logout(BuildContext context) async {
    // Clear any saved session data (e.g., SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/');
  }
}
