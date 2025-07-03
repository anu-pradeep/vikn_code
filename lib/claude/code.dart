// // pubspec.yaml dependencies to add:
// // dependencies:
// //   flutter:
// //     sdk: flutter
// //   provider: ^6.0.5
// //   http: ^0.13.5
// //   shared_preferences: ^2.0.18
// //   dio: ^4.0.6
//
// // main.dart
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => SalesProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Cabzing',
//         theme: AppTheme.darkTheme,
//         home: Consumer<AuthProvider>(
//           builder: (context, authProvider, _) {
//             return authProvider.isAuthenticated ? DashboardScreen() : LoginScreen();
//           },
//         ),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
//
// // utils/app_theme.dart
//
//
// class AppTheme {
//   static ThemeData get darkTheme {
//     return ThemeData(
//       primarySwatch: Colors.blue,
//       scaffoldBackgroundColor: Color(0xFF1A1A1A),
//       cardColor: Color(0xFF2A2A2A),
//       textTheme: TextTheme(
//         headlineLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//         bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
//         bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
//       ),
//       appBarTheme: AppBarTheme(
//         backgroundColor: Color(0xFF1A1A1A),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Color(0xFF2A2A2A),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         hintStyle: TextStyle(color: Colors.white54),
//         labelStyle: TextStyle(color: Colors.white70),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF007AFF),
//           foregroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }
//
// // models/user_model.dart
// class User {
//   final String id;
//   final String username;
//   final String email;
//   final String? profilePicture;
//   final String? firstName;
//   final String? lastName;
//
//   User({
//     required this.id,
//     required this.username,
//     required this.email,
//     this.profilePicture,
//     this.firstName,
//     this.lastName,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id']?.toString() ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       profilePicture: json['profile_picture'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//     );
//   }
//
//   String get displayName {
//     if (firstName != null && lastName != null) {
//       return '$firstName $lastName';
//     }
//     return username;
//   }
// }
//
// // models/sale_model.dart
// class Sale {
//   final String id;
//   final String customerName;
//   final double amount;
//   final String status;
//   final DateTime date;
//   final String invoiceNo;
//
//   Sale({
//     required this.id,
//     required this.customerName,
//     required this.amount,
//     required this.status,
//     required this.date,
//     required this.invoiceNo,
//   });
//
//   factory Sale.fromJson(Map<String, dynamic> json) {
//     return Sale(
//       id: json['id']?.toString() ?? '',
//       customerName: json['customer_name'] ?? 'Unknown Customer',
//       amount: (json['amount'] ?? 0).toDouble(),
//       status: json['status'] ?? 'pending',
//       date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
//       invoiceNo: json['invoice_no'] ?? '',
//     );
//   }
// }
//
// // services/api_service.dart
//
// class ApiService {
//   static const String baseUrl = 'https://api.accounts.vikncodes.com';
//   static const String salesBaseUrl = 'https://www.api.viknbooks.com';
//   static const String profileBaseUrl = 'https://www.viknbooks.com';
//
//   static Future<Map<String, dynamic>> login(String username, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/v1/users/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'username': username,
//           'password': password,
//           'is_mobile': true,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Login failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }
//
//   static Future<List<Sale>> getSales(String token, String userId, int pageNo) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$salesBaseUrl/api/v10/sales/sale-list-page/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({
//           'BranchID': 1,
//           'CompanyID': '1901b825-fe6f-418d-b5f0-7223d0040d08',
//           'CreatedUserID': userId,
//           'PriceRounding': 2,
//           'page_no': pageNo,
//           'items_per_page': 10,
//           'type': 'Sales',
//           'WarehouseID': 1,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> salesData = data['data'] ?? [];
//         return salesData.map((json) => Sale.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to fetch sales: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Return mock data for demo purposes
//       return _getMockSales();
//     }
//   }
//
//   static Future<User> getUserProfile(String token, String userId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$profileBaseUrl/api/v10/users/user-view/$userId/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return User.fromJson(data);
//       } else {
//         throw Exception('Failed to fetch profile: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Return mock data for demo purposes
//       return User(
//         id: userId,
//         username: 'David Arnold',
//         email: 'david@cabzing.com',
//         firstName: 'David',
//         lastName: 'Arnold',
//       );
//     }
//   }
//
//   static List<Sale> _getMockSales() {
//     return [
//       Sale(
//         id: '1',
//         customerName: 'Customer Name',
//         amount: 10000.00,
//         status: 'Pending',
//         date: DateTime.now(),
//         invoiceNo: 'INV001',
//       ),
//       Sale(
//         id: '2',
//         customerName: 'Customer Name',
//         amount: 10000.00,
//         status: 'Invoiced',
//         date: DateTime.now(),
//         invoiceNo: 'INV002',
//       ),
//       Sale(
//         id: '3',
//         customerName: 'Customer Name',
//         amount: 10000.00,
//         status: 'Cancelled',
//         date: DateTime.now(),
//         invoiceNo: 'INV003',
//       ),
//       Sale(
//         id: '4',
//         customerName: 'Customer Name',
//         amount: 10000.00,
//         status: 'Pending',
//         date: DateTime.now(),
//         invoiceNo: 'INV004',
//       ),
//     ];
//   }
// }
//
// // providers/auth_provider.dart
//
// class AuthProvider with ChangeNotifier {
//   User? _user;
//   String? _token;
//   bool _isLoading = false;
//   String? _error;
//
//   User? get user => _user;
//   String? get token => _token;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _token != null && _user != null;
//
//   AuthProvider() {
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     final userId = prefs.getString('userId');
//
//     if (_token != null && userId != null) {
//       try {
//         _user = await ApiService.getUserProfile(_token!, userId);
//         notifyListeners();
//       } catch (e) {
//         await logout();
//       }
//     }
//   }
//
//   Future<bool> login(String username, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await ApiService.login(username, password);
//
//       if (response['status'] == 'success' || response['token'] != null) {
//         _token = response['token'];
//         print(token);
//         final userId = response['user_id']?.toString() ?? response['id']?.toString();
//
//         if (_token != null && userId != null) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', _token!);
//           await prefs.setString('userId', userId);
//
//           _user = await ApiService.getUserProfile(_token!, userId);
//           _isLoading = false;
//           notifyListeners();
//           return true;
//         }
//       }
//
//       _error = 'Invalid credentials';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('userId');
//
//     _user = null;
//     _token = null;
//     _error = null;
//     notifyListeners();
//   }
// }
//
// // providers/sales_provider.dart
//
// class SalesProvider with ChangeNotifier {
//   List<Sale> _sales = [];
//   List<Sale> _filteredSales = [];
//   bool _isLoading = false;
//   String? _error;
//   String _searchQuery = '';
//   String _selectedFilter = 'All';
//
//   List<Sale> get sales => _filteredSales;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String get searchQuery => _searchQuery;
//   String get selectedFilter => _selectedFilter;
//
//   Future<void> fetchSales(String token, String userId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       _sales = await ApiService.getSales(token, userId, 1);
//       _applyFilters();
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void searchSales(String query) {
//     _searchQuery = query;
//     _applyFilters();
//     notifyListeners();
//   }
//
//   void filterSales(String filter) {
//     _selectedFilter = filter;
//     _applyFilters();
//     notifyListeners();
//   }
//
//   void _applyFilters() {
//     _filteredSales = _sales.where((sale) {
//       final matchesSearch = _searchQuery.isEmpty ||
//           sale.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           sale.invoiceNo.toLowerCase().contains(_searchQuery.toLowerCase());
//
//       final matchesFilter = _selectedFilter == 'All' ||
//           sale.status.toLowerCase() == _selectedFilter.toLowerCase();
//
//       return matchesSearch && matchesFilter;
//     }).toList();
//   }
// }
//
// // screens/login_screen.dart
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController(text: 'Rabeeh@vk');
//   final _passwordController = TextEditingController(text: 'Rabeeh@000');
//   bool _obscurePassword = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 60),
//               Text(
//                 'English',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 80),
//               Text(
//                 'Login',
//                 style: Theme.of(context).textTheme.headlineLarge,
//               ),
//               Text(
//                 'Login to your vikn account',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               SizedBox(height: 40),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         labelText: 'Username',
//                         prefixIcon: Icon(Icons.person, color: Colors.blue),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your username';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: _obscurePassword,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         prefixIcon: Icon(Icons.lock, color: Colors.blue),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                             color: Colors.blue,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           'Forgotten Password?',
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     Consumer<AuthProvider>(
//                       builder: (context, authProvider, _) {
//                         return Column(
//                           children: [
//                             if (authProvider.error != null)
//                               Container(
//                                 padding: EdgeInsets.all(12),
//                                 margin: EdgeInsets.only(bottom: 16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(color: Colors.red.withOpacity(0.3)),
//                                 ),
//                                 child: Text(
//                                   authProvider.error!,
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: authProvider.isLoading
//                                     ? null
//                                     : () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     final success = await authProvider.login(
//                                       _usernameController.text,
//                                       _passwordController.text,
//                                     );
//                                     if (success) {
//                                       Navigator.pushReplacementNamed(context, '/dashboard');
//                                     }
//                                   }
//                                 },
//                                 child: authProvider.isLoading
//                                     ? CircularProgressIndicator(color: Colors.white)
//                                     : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text('Sign In'),
//                                     SizedBox(width: 8),
//                                     Icon(Icons.arrow_forward),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Spacer(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an Account?",
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       'Sign up now!',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
//
// // screens/dashboard_screen.dart
//
// class DashboardScreen extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   int _currentIndex = 0;
//   final PageController _pageController = PageController();
//
//   final List<Widget> _screens = [
//     DashboardHomeScreen(),
//     SalesListScreen(),
//     Container(), // Placeholder for middle tab
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: _screens,
//         onPageChanged: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Color(0xFF1A1A1A),
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.white54,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           if (index != 2) { // Skip middle placeholder
//             setState(() {
//               _currentIndex = index;
//             });
//             _pageController.animateToPage(
//               index,
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//             );
//           }
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt),
//             label: 'Sales',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DashboardHomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Icon(Icons.directions_car, color: Colors.blue),
//             SizedBox(width: 8),
//             Text('Cabzing'),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Color(0xFF2A2A2A),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'SAR 2,78,000.00',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Revenue',
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '+39% from last month',
//                     style: TextStyle(color: Colors.green),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     height: 100,
//                     child: CustomPaint(
//                       painter: ChartPainter(),
//                       size: Size(double.infinity, 100),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'September 2023',
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildMetricCard(
//                     'Bookings',
//                     '123',
//                     'Received',
//                     Colors.blue,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: _buildMetricCard(
//                     'Revenue',
//                     '10,232.00',
//                     'Today',
//                     Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMetricCard(String title, String value, String subtitle, Color color) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TextStyle(color: Colors.white70),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             subtitle,
//             style: TextStyle(color: Colors.white54, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChartPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     final path = Path();
//
//     // Simple chart line
//     path.moveTo(0, size.height * 0.7);
//     path.lineTo(size.width * 0.2, size.height * 0.5);
//     path.lineTo(size.width * 0.4, size.height * 0.3);
//     path.lineTo(size.width * 0.6, size.height * 0.6);
//     path.lineTo(size.width * 0.8, size.height * 0.2);
//     path.lineTo(size.width, size.height * 0.4);
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// // screens/sales_list_screen.dart
//
//
// class SalesListScreen extends StatefulWidget {
//   @override
//   _SalesListScreenState createState() => _SalesListScreenState();
// }
//
// class _SalesListScreenState extends State<SalesListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final salesProvider = Provider.of<SalesProvider>(context, listen: false);
//
//       if (authProvider.token != null && authProvider.user != null) {
//         salesProvider.fetchSales(authProvider.token!, authProvider.user!.id);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Invoices'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search',
//                       prefixIcon: Icon(Icons.search, color: Colors.white54),
//                       suffixIcon: IconButton(
//                         icon: Icon(Icons.clear, color: Colors.white54),
//                         onPressed: () {
//                           _searchController.clear();
//                           Provider.of<SalesProvider>(context, listen: false)
//                               .searchSales('');
//                         },
//                       ),
//                     ),
//                     onChanged: (value) {
//                       Provider.of<SalesProvider>(context, listen: false)
//                           .searchSales(value);
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => FilterScreen()),
//                     );
//                   },
//                   child: Text('Add Filters'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Consumer<SalesProvider>(
//               builder: (context, salesProvider, _) {
//                 if (salesProvider.isLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (salesProvider.error != null) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error_outline, size: 64, color: Colors.red),
//                         SizedBox(height: 16),
//                         Text(
//                           'Error loading sales',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           salesProvider.error!,
//                           style: TextStyle(color: Colors.white70),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 if (salesProvider.sales.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.receipt_long, size: 64, color: Colors.white54),
//                         SizedBox(height: 16),
//                         Text(
//                           'No sales found',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   padding: EdgeInsets.all(16),
//                   itemCount: salesProvider.sales.length,
//                   itemBuilder: (context, index) {
//                     final sale = salesProvider.sales[index];
//                     return _buildSaleCard(sale);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSaleCard(Sale sale) {
//     Color statusColor;
//     switch (sale.status.toLowerCase()) {
//       case 'pending':
//         statusColor = Colors.orange;
//         break;
//       case 'invoiced':
//         statusColor = Colors.green;
//         break;
//       case 'cancelled':
//         statusColor = Colors.red;
//         break;
//       default:
//         statusColor = Colors.grey;
//     }
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '#Invoice No',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   sale.status,
//                   style: TextStyle(color: statusColor, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4),
//           Text(
//             sale.customerName,
//             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '#Invoice No',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//               Text(
//                 'SAR ${sale.amount.toStringAsFixed(2)}',
//                 style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           SizedBox(height: 4),
//           Text(
//             sale.customerName,
//             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }
//
// // screens/profile_screen.dart
//
//
// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, _) {
//           final user = authProvider.user;
//           if (user == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Color(0xFF2A2A2A),
//                   child: user.profilePicture != null
//                       ? ClipOval(
//                     child: Image.network(
//                       user.profilePicture!,
//                       width: 100,
//                       height: 100,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(Icons.person, size: 50, color: Colors.white);
//                       },
//                     ),
//                   )
//                       : Icon(Icons.person, size: 50, color: Colors.white),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   user.displayName,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   user.email,
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//                 SizedBox(height: 32),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF2A2A2A),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(Icons.star, color: Colors.blue),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '4.3',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Rides',
//                                   style: TextStyle(color: Colors.white70),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.green.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(Icons.verified, color: Colors.green),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'KYC',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Verified',
//                                   style: TextStyle(color: Colors.green),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 _buildMenuItem(
//                   icon: Icons.help_outline,
//                   title: 'Help',
//                   onTap: () {},
//                 ),
//                 _buildMenuItem(
//                   icon: Icons.quiz_outlined,
//                   title: 'FAQ',
//                   onTap: () {},
//                 ),
//                 _buildMenuItem(
//                   icon: Icons.group_add_outlined,
//                   title: 'Invite Friends',
//                   onTap: () {},
//                 ),
//                 _buildMenuItem(
//                   icon: Icons.description_outlined,
//                   title: 'Terms of service',
//                   onTap: () {},
//                 ),
//                 _buildMenuItem(
//                   icon: Icons.privacy_tip_outlined,
//                   title: 'Privacy Policy',
//                   onTap: () {},
//                 ),
//                 SizedBox(height: 20),
//                 _buildMenuItem(
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   onTap: () {
//                     _showLogoutDialog(context, authProvider);
//                   },
//                   isDestructive: true,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isDestructive = false,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isDestructive ? Colors.red : Colors.white70,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: isDestructive ? Colors.red : Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white54,
//           size: 16,
//         ),
//         onTap: onTap,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         tileColor: Color(0xFF2A2A2A),
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF2A2A2A),
//           title: Text(
//             'Logout',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Text(
//             'Are you sure you want to logout?',
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 authProvider.logout();
//               },
//               child: Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// // screens/filter_screen.dart
//
// class FilterScreen extends StatefulWidget {
//   @override
//   _FilterScreenState createState() => _FilterScreenState();
// }
//
// class _FilterScreenState extends State<FilterScreen> {
//   String selectedFilter = 'All';
//   DateTime? fromDate;
//   DateTime? toDate;
//   String? selectedCustomer;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedFilter = Provider.of<SalesProvider>(context, listen: false).selectedFilter;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filters'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Provider.of<SalesProvider>(context, listen: false)
//                   .filterSales(selectedFilter);
//               Navigator.pop(context);
//             },
//             child: Text(
//               'Filter',
//               style: TextStyle(color: Colors.blue),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'This Month',
//               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDateField('12/08/2023', 'From Date', () {
//                     _selectDate(context, true);
//                   }),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDateField('12/08/2023', 'To Date', () {
//                     _selectDate(context, false);
//                   }),
//                 ),
//               ],
//             ),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 _buildFilterChip('Pending', selectedFilter == 'Pending'),
//                 SizedBox(width: 12),
//                 _buildFilterChip('Invoiced', selectedFilter == 'Invoiced'),
//                 SizedBox(width: 12),
//                 _buildFilterChip('Cancelled', selectedFilter == 'Cancelled'),
//               ],
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Customer',
//               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 12),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Color(0xFF2A2A2A),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     selectedCustomer ?? 'Select Customer',
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   Icon(Icons.keyboard_arrow_down, color: Colors.white54),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Color(0xFF2A2A2A),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.close, color: Colors.white54),
//                   SizedBox(width: 12),
//                   Text(
//                     'Savad farooque',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateField(String text, String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Color(0xFF2A2A2A),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(color: Colors.white70, fontSize: 12),
//             ),
//             SizedBox(height: 4),
//             Text(
//               text,
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilterChip(String label, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedFilter = isSelected ? 'All' : label;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Color(0xFF2A2A2A),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.white70,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2025),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.dark(
//               primary: Colors.blue,
//               onPrimary: Colors.white,
//               surface: Color(0xFF2A2A2A),
//               onSurface: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           fromDate = picked;
//         } else {
//           toDate = picked;
//         }
//       });
//     }
//   }
// }