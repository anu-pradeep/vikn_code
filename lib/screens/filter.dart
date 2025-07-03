import 'package:flutter/material.dart';
import 'package:vikn_code/utils/colors.dart';

import '../utils/searchable_dropdown.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedMonth = "This Month";
  DateTime? startDate;
  DateTime? endDate;
  String selectedStatus = "Pending";
  String selectedCustomer = "savad farooque";

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: CustomColors.blueColor,
              surface: Colors.grey[900]!,
            ),
            dialogBackgroundColor: CustomColors.blackColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkCard = Color(0xFF1C1C1E);

    return Scaffold(
      backgroundColor: CustomColors.blackColor,
      appBar: AppBar(
        backgroundColor: CustomColors.blackColor,
        elevation: 0,
        leading: BackButton(color: CustomColors.whiteColor,),
        title: Text('Filters', style: TextStyle(color: CustomColors.whiteColor,fontFamily: 'PoppinsRegular',fontSize: 20)),
        actions: [
         Image.asset('assets/images/eye.png'),
          SizedBox(width: 12),
          Text('filter',style: TextStyle(color: CustomColors.blueColor,fontFamily: 'PoppinsRegular',fontSize: 15),)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Dropdown
            Center(
              child: SizedBox(width: 150,
                child:
                CustomSearchableDropdown(
                  hintText: 'Select Month',
                  items: ['This Month', 'Last Month', 'Custom'],
                  selectedItem: selectedMonth,
                  onItemSelected: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            // Date Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                    decoration: BoxDecoration(
                      color: darkCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: CustomColors.blueColor, size: 18),
                        SizedBox(width: 08),
                        Text(
                          startDate != null
                              ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                              : "Start Date",
                          style: TextStyle(color: CustomColors.whiteColor,fontFamily: 'PoppinsRegular'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                InkWell(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                    decoration: BoxDecoration(
                      color: darkCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: CustomColors.blueColor, size: 18),
                        SizedBox(width: 08),
                        Text(
                          endDate != null
                              ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                              : "End Date",
                          style: TextStyle(color: CustomColors.whiteColor,fontFamily: 'PoppinsRegular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Status Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Pending', 'Invoiced', 'Cancelled'].map((status) {
                final bool isSelected = selectedStatus == status;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedStatus = status),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? CustomColors.blueColor : darkCard,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isSelected ? CustomColors.whiteColor : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PoppinsRegular'
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            CustomSearchableDropdown(
              hintText: 'Customer',
              items: ['Savad farooque', 'savad', 'farooque'],
              selectedItem: selectedMonth,
              onItemSelected: (value) {
                setState(() {
                  selectedMonth = value;
                });
              },
            ),
            SizedBox(height: 16),

            Wrap(
              children: [
                Chip(
                  backgroundColor: darkCard,
                  label: Text(selectedCustomer, style: TextStyle(color: CustomColors.whiteColor,)),
                  deleteIcon: Icon(Icons.close, color: CustomColors.blueColor,),
                  onDeleted: () {
                    setState(() {
                      selectedCustomer = '';
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
