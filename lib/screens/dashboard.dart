import 'package:flutter/material.dart';
import 'package:vikn_code/screens/profile.dart';
import 'package:vikn_code/screens/sales_list.dart';
import 'package:vikn_code/utils/colors.dart';
import '../utils/chart.dart';
import 'filter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/logo.png', height: 30),
                      const SizedBox(width: 8),
                      Text(
                        'CabZing',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'PoppinsMedium',
                          color: CustomColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  Image.asset('assets/images/profile.png', height: 40),
                ],
              ),

              const SizedBox(height: 20),

              // Revenue Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'SAR ',
                            style: TextStyle(
                              color: CustomColors.whiteColor,
                              fontFamily: 'PoppinsRegular',
                            ),
                            children: [
                              TextSpan(
                                text: '2,78,000.00',
                                style: TextStyle(
                                  color: CustomColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PoppinsRegular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 150),
                        Text(
                          'Revenue',
                          style: TextStyle(
                            color: CustomColors.whiteColor,
                            fontFamily: 'PoppinsRegular',
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        text: '+21% ',
                        style: TextStyle(
                          color: CustomColors.greenColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                        children: [
                          TextSpan(
                            text: 'than last month',
                            style: TextStyle(
                              color: CustomColors.whiteColor,

                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Chart
                    SizedBox(height: 180, child: RevenueChart()),

                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'September 2023',
                        style: TextStyle(
                          color: CustomColors.whiteColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                    const SizedBox(height: 08),

                    // Day Scroll
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              width: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: index == 1
                                    ? CustomColors.blueColor
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '0${index + 1}',
                                style: TextStyle(
                                  color: CustomColors.whiteColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              dashboardCard(
                title: "Bookings",
                subtitle: "123 Reserved",
                imagePath: 'assets/images/booking.png',
              ),

              const SizedBox(height: 12),

              dashboardCard(
                title: "Invoices",
                subtitle: "10,232.00 Rupees",
                imagePath: 'assets/images/invoice.png',
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.blackColor,
        selectedItemColor: CustomColors.whiteColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/telegram_icon_white.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/notification.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/user_icon.png'),
            label: '',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SaleListScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  FilterScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget dashboardCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: CustomColors.blackColor,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: CustomColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PoppinsRegular',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: CustomColors.whiteColor,
                    fontFamily: 'PoppinsRegular',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_outlined,
            color: CustomColors.whiteColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}
