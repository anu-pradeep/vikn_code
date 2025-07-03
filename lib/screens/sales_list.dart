
import 'package:flutter/material.dart';
import 'package:vikn_code/utils/colors.dart';

import '../service_class/sales_service.dart';

class SaleListScreen extends StatefulWidget {
  const SaleListScreen({super.key});

  @override
  _SaleListScreenState createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  final SaleListService saleListService = SaleListService();
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
    final result = await saleListService.fetchSales(page: 1);
    setState(() {
      sales = result;
      currentPage = 1;
      isMoreDataAvailable = result.length >= 10;
      isLoading = false;
    });
  }

  Future<void> fetchMoreSales() async {
    setState(() => isLoadingMore = true);
    final result = await saleListService.fetchSales(page: currentPage + 1);
    setState(() {
      sales.addAll(result);
      currentPage++;
      isMoreDataAvailable = result.length >= 10;
      isLoadingMore = false;
    });
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
      backgroundColor: CustomColors.blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.blackColor,
        elevation: 0,
        title: Text('Invoices',
            style: TextStyle(
                color: CustomColors.whiteColor,
                fontFamily: 'PoppinsRegular')),
        iconTheme: IconThemeData(color: CustomColors.whiteColor),
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
                      style: TextStyle(color: CustomColors.whiteColor),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'PoppinsRegular'),
                        prefixIcon:
                        Icon(Icons.search, color: CustomColors.whiteColor),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                        fontFamily: 'PoppinsRegular'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
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
