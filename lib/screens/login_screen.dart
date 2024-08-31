import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:msal_auth/msal_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _clientId = '597ff3a7-190d-4fc5-af64-faeda6f05fe3';
  final _tenantId = 'ec6877af-66a3-4a24-8216-22fd284685cf';
  late final _authority =
      'https://login.microsoftonline.com/$_tenantId/oauth2/v2.0/authorize';
  final _scopes = <String>[
    'https://graph.microsoft.com/user.read',
  ];

  // State variables to hold user details and loading state
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MSAL Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _getToken,
                child: const Text('Sign in with Microsoft'),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator(),
              if (_user != null) ...[
                Text('Name: ${_user!['displayName'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                Text('Email: ${_user!['mail'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                Text('Job Title: ${_user!['jobTitle'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _logout,
                  child: const Text('Logout'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<MsalAuth> getMsalAuth() async {
    return MsalAuth.createPublicClientApplication(
      clientId: _clientId,
      scopes: _scopes,
      androidConfig: AndroidConfig(
        configFilePath: 'assets/msal_config.json',
        tenantId: _tenantId,
      ),
      iosConfig: IosConfig(authority: _authority),
    );
  }

  Future<void> _getToken() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final msalAuth = await getMsalAuth();
      final result = await msalAuth.acquireToken();
      log('User data: ${result?.toJson()}');
      if (result?.accessToken != null) {
        final user = await fetchUserDetails(result!.accessToken!);
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } on MsalException catch (e) {
      log('Msal exception with error: ${e.errorMessage}');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      final msalAuth = await getMsalAuth();
      await msalAuth.logout();
      setState(() {
        _user = null; // Clear user data on logout
      });
    } on MsalException catch (e) {
      log('Msal exception with error: ${e.errorMessage}');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(String accessToken) async {
    final url = 'https://graph.microsoft.com/v1.0/me';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('Failed to load user details: ${response.statusCode}');
      return {};
    }
  }
}
