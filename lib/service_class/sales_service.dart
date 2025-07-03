import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SaleListService {
  Future<List<dynamic>> fetchSales({required int page}) async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('userID');
    final token = prefs.getString('token');

    final url = Uri.parse(
        'https://api.viknbooks.com/api/v10/sales/sale-list-page/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "BranchID": 1,
        "CompanyID": "1901b825-fe6f-418d-b5f0-7223d0040d08",
        "CreatedUserID": int.tryParse(userID ?? "0"),
        "PriceRounding": 2,
        "page_no": page,
        "items_per_page": 10,
        "type": "Sales",
        "WarehouseID": 1,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['StatusCode'] == 6000) {
        return data['data'] ?? [];
      }
    }

    return [];
  }
}
