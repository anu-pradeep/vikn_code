import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vikn_code/utils/colors.dart';

class SaleListScreen extends StatefulWidget {
  @override
  _SaleListScreenState createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  List<dynamic> sales = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isMoreDataAvailable = true;
  bool isLoadingMore = false;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchSales();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore &&
          isMoreDataAvailable) {
        fetchMoreSales();
      }
    });
  }

  Future<void> fetchSales() async {
    setState(() => isLoading = true);
    await _fetchData(page: 1);
    setState(() => isLoading = false);
  }

  Future<void> fetchMoreSales() async {
    setState(() => isLoadingMore = true);
    await _fetchData(page: currentPage + 1);
    setState(() => isLoadingMore = false);
  }

  Future<void> _fetchData({required int page}) async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('userID');
    final token = prefs.getString('token');

    final url = Uri.parse(
      'https://api.viknbooks.com/api/v10/sales/sale-list-page/',
    );

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
        final newSales = data['data'] ?? [];
        setState(() {
          if (page == 1) {
            sales = newSales;
          } else {
            sales.addAll(newSales);
          }
          currentPage = page;
          isMoreDataAvailable = newSales.length >= 10;
        });
      } else {
        isMoreDataAvailable = false;
      }
    } else {
      isMoreDataAvailable = false;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchText = searchController.text.toLowerCase();
    final filteredSales = sales.where((item) {
      final customer = item['CustomerName'] ?? '';
      return customer.toLowerCase().contains(searchText);
    }).toList();

    return Scaffold(
      backgroundColor:CustomColors.blackColor,
      appBar: AppBar(
        backgroundColor: CustomColors.blackColor,
        elevation: 0,
        title:  Text('Invoices', style: TextStyle(color:CustomColors.whiteColor,fontFamily: 'PoppinsRegular')),
        iconTheme:  IconThemeData(color: CustomColors.whiteColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      style:  TextStyle(color: CustomColors.whiteColor),
                      decoration:  InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white54,fontFamily: 'PoppinsRegular'),
                        prefixIcon: Icon(Icons.search, color: CustomColors.whiteColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/images/filter_icon.png'),

                  label: Text(
                    'Add Filters',
                    style: TextStyle(
                      color: CustomColors.whiteColor,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    foregroundColor: CustomColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: scrollController,
                    itemCount: filteredSales.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == filteredSales.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final sale = filteredSales[index];
                      final invoiceNo = sale['VoucherNo'] ?? 'N/A';
                      final customerName = sale['CustomerName'] ?? 'N/A';
                      final grandTotal = sale['GrandTotal'] ?? 0;
                      final status = sale['Status'] ?? 'N/A';

                      Color statusColor;
                      switch (status.toLowerCase()) {
                        case 'invoiced':
                          statusColor = CustomColors.blueColor;
                          break;
                        case 'pending':
                          statusColor = CustomColors.redColor;
                          break;
                        case 'cancelled':
                          statusColor = Colors.grey;
                          break;
                        default:
                          statusColor = CustomColors.whiteColor;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#$invoiceNo',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  customerName,
                                  style: TextStyle(
                                    color: CustomColors.whiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                ),
                                Text(
                                  'SAR ${grandTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.white24,
                              thickness: 0.5,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
