import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _result = "Press the button to test API";

  Future<void> testApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.viknbooks.com/api/v10/sales/sale-list-page/'),
        headers: {
          'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9',
          'Content-Type': 'application/json',
        },
      );

      setState(() {
        _result = "Status: ${response.statusCode}\n\nBody:\n${response.body}";
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("API Test")),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: testApi,
                  child: const Text("Test API"),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _result,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            ),
      );
   }
}



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ApiTester extends StatefulWidget {
//   @override
//   _ApiTesterState createState() => _ApiTesterState();
// }
//
// class _ApiTesterState extends State<ApiTester> {
//   List<String> testResults = [];
//
//   Future<void> testAllApis() async {
//     setState(() {
//       testResults.clear();
//     });
//
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final userID = prefs.getString('userID');
//
//     addResult("Starting API tests...");
//     addResult("Token available: ${token != null}");
//     addResult("UserID: $userID");
//
//     // Test different domain variations for profile API
//     final profileUrls = [
//       'https://www.viknbooks.com/api/v10/users/user-view/$userID/',
//       'https://api.viknbooks.com/api/v10/users/user-view/$userID/',
//       'https://viknbooks.com/api/v10/users/user-view/$userID/',
//       'https://api.accounts.vikncodes.com/api/v1/users/profile/',
//       'https://api.accounts.vikncodes.com/api/v1/profile/',
//       'https://api.accounts.vikncodes.com/api/v1/me/',
//     ];
//
//     addResult("\n=== TESTING PROFILE APIs ===");
//     for (String url in profileUrls) {
//       await testGetApi(url, token);
//     }
//
//     // Test different domain variations for sales API
//     final salesUrls = [
//       'https://www.api.viknbooks.com/api/v10/sales/sale-list-page/',
//       'https://api.viknbooks.com/api/v10/sales/sale-list-page/',
//       'https://www.viknbooks.com/api/v10/sales/sale-list-page/',
//       'https://viknbooks.com/api/v10/sales/sale-list-page/',
//     ];
//
//     final salesPayload = {
//       "BranchID": 1,
//       "CompanyID": "1901b825-fe6f-418d-b5f0-7223d0040d08",
//       "CreatedUserID": userID,
//       "PriceRounding": 2,
//       "page_no": 1,
//       "items_per_page": 10,
//       "type": "Sales",
//       "WarehouseID": 1
//     };
//
//     addResult("\n=== TESTING SALES APIs ===");
//     for (String url in salesUrls) {
//       await testPostApi(url, salesPayload, token);
//     }
//   }
//
//   Future<void> testGetApi(String url, String? token) async {
//     try {
//       addResult("\nTesting GET: $url");
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//       ).timeout(Duration(seconds: 10));
//
//       addResult("Status: ${response.statusCode}");
//       addResult("Content-Type: ${response.headers['content-type']}");
//
//       if (response.statusCode == 200) {
//         if (response.headers['content-type']?.contains('application/json') == true) {
//           addResult("✅ SUCCESS - Valid JSON response");
//           addResult("Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...");
//         } else {
//           addResult("⚠️ SUCCESS but HTML response (not API endpoint)");
//         }
//       } else if (response.statusCode == 401) {
//         addResult("🔒 UNAUTHORIZED - Token invalid/expired");
//       } else if (response.statusCode == 404) {
//         addResult("❌ NOT FOUND - Endpoint doesn't exist");
//       } else {
//         addResult("❌ ERROR - Status ${response.statusCode}");
//       }
//     } catch (e) {
//       addResult("💥 EXCEPTION: $e");
//     }
//   }
//
//   Future<void> testPostApi(String url, Map<String, dynamic> payload, String? token) async {
//     try {
//       addResult("\nTesting POST: $url");
//       addResult("Payload: ${jsonEncode(payload)}");
//
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(payload),
//       ).timeout(Duration(seconds: 10));
//
//       addResult("Status: ${response.statusCode}");
//       addResult("Content-Type: ${response.headers['content-type']}");
//
//       if (response.statusCode == 200) {
//         if (response.headers['content-type']?.contains('application/json') == true) {
//           addResult("✅ SUCCESS - Valid JSON response");
//           addResult("Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...");
//         } else {
//           addResult("⚠️ SUCCESS but HTML response (not API endpoint)");
//         }
//       } else if (response.statusCode == 401) {
//         addResult("🔒 UNAUTHORIZED - Token invalid/expired");
//       } else if (response.statusCode == 404) {
//         addResult("❌ NOT FOUND - Endpoint doesn't exist");
//       } else {
//         addResult("❌ ERROR - Status ${response.statusCode}");
//       }
//     } catch (e) {
//       addResult("💥 EXCEPTION: $e");
//     }
//   }
//
//   void addResult(String result) {
//     setState(() {
//       testResults.add(result);
//     });
//     print(result); // Also print to console
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Tester'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: ElevatedButton(
//               onPressed: testAllApis,
//               child: Text('Test All APIs'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.all(16),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey[300]!),
//               ),
//               child: ListView.builder(
//                 itemCount: testResults.length,
//                 itemBuilder: (context, index) {
//                   final result = testResults[index];
//                   Color textColor = Colors.black;
//
//                   if (result.contains('✅')) textColor = Colors.green;
//                   else if (result.contains('❌')) textColor = Colors.red;
//                   else if (result.contains('⚠️')) textColor = Colors.orange;
//                   else if (result.contains('🔒')) textColor = Colors.purple;
//                   else if (result.contains('💥')) textColor = Colors.red[800]!;
//
//                   return Padding(
//                     padding: EdgeInsets.symmetric(vertical: 2),
//                     child: Text(
//                       result,
//                       style: TextStyle(
//                         fontFamily: 'monospace',
//                         fontSize: 12,
//                         color: textColor,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }