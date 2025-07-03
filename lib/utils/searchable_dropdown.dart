// import 'package:flutter/material.dart';
//
// class MonthDropdown extends StatefulWidget {
//   final String hintText;
//   final Function(String) onItemSelected;
//
//   const MonthDropdown({
//     super.key,
//     required this.hintText,
//     required this.onItemSelected,
//   });
//
//   @override
//   State<MonthDropdown> createState() => _MonthDropdownState();
// }
//
// class _MonthDropdownState extends State<MonthDropdown> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   final GlobalKey _fieldKey = GlobalKey();
//   OverlayEntry? _overlayEntry;
//
//   final List<String> items = ["This Month", "Last Month", "Custom"];
//   List<String> filteredItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_filterItems);
//     filteredItems = List.from(items);
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _showDropdown();
//       } else {
//         _hideDropdown();
//       }
//     });
//   }
//
//   void _filterItems() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredItems =
//           items.where((item) => item.toLowerCase().contains(query)).toList();
//     });
//     _hideDropdown();
//     if (_focusNode.hasFocus) {
//       _showDropdown();
//     }
//   }
//
//   void _selectItem(String item) {
//     setState(() {
//       _searchController.text = item;
//     });
//     _hideDropdown();
//     widget.onItemSelected(item);
//     FocusScope.of(context).unfocus();
//   }
//
//   void _showDropdown() {
//     _hideDropdown();
//     final RenderBox renderBox =
//     _fieldKey.currentContext!.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: size.width,
//         child: Material(
//           elevation: 4.0,
//           borderRadius: BorderRadius.circular(8.0),
//           child: Container(
//             constraints: const BoxConstraints(maxHeight: 200),
//             decoration: BoxDecoration(
//               color:  Colors.black,
//               border: Border.all(color:  Colors.white),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: filteredItems.isEmpty
//                 ? Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "No items found",
//                 style: TextStyle(
//                   color:  Colors.black,
//                   fontSize: 15,
//                   fontFamily: 'PoppinsRegular',
//                 ),
//               ),
//             )
//                 : ListView.builder(
//               shrinkWrap: true,
//               padding: EdgeInsets.zero,
//               itemCount: filteredItems.length,
//               itemBuilder: (context, index) {
//                 final item = filteredItems[index];
//                 return ListTile(
//                   title: Text(
//                     item,
//                     style: TextStyle(
//                       color:  Colors.white,
//                       fontSize: 15,
//                       fontFamily: 'PoppinsRegular',
//                     ),
//                   ),
//                   onTap: () => _selectItem(item),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//
//     Overlay.of(context).insert(_overlayEntry!);
//   }
//
//   void _hideDropdown() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       key: _fieldKey,
//       controller: _searchController,
//       focusNode: _focusNode,
//       // readOnly: true,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         hintStyle: TextStyle(
//           color:  Colors.white,
//           fontSize: 15,
//           fontFamily: 'PoppinsRegular',
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(Icons.arrow_drop_down, color:  Colors.white),
//           onPressed: () {
//             if (_focusNode.hasFocus) {
//               _focusNode.unfocus();
//             } else {
//               _focusNode.requestFocus();
//             }
//           },
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.black, width: 0.5),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color:  Colors.black, width: 0.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color:  Colors.black, width: 0.5),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'colors.dart';

class CustomSearchableDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? selectedItem;
  final Function(String) onItemSelected;

  const CustomSearchableDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
  });

  @override
  State<CustomSearchableDropdown> createState() =>
      _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.selectedItem ?? '';
    _searchController.addListener(_filterItems);
    filteredItems = List.from(widget.items);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      } else {
        _hideDropdown();
      }
    });
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
    _hideDropdown();
    if (_focusNode.hasFocus) {
      _showDropdown();
    }
  }

  void _selectItem(String item) {
    setState(() {
      _searchController.text = item;
    });
    _hideDropdown();
    widget.onItemSelected(item);
    FocusScope.of(context).unfocus();
  }

  void _showDropdown() {
    _hideDropdown();
    final RenderBox renderBox =
        _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: CustomColors.blackColor,
              border: Border.all(color: CustomColors.blackColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: filteredItems.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No items found",
                      style: TextStyle(
                        color: CustomColors.whiteColor,
                        fontSize: 15,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(
                          item,
                          style: TextStyle(
                            color: CustomColors.whiteColor,
                            fontSize: 15,
                            fontFamily: 'PoppinsRegular',
                          ),
                        ),
                        onTap: () => _selectItem(item),
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      controller: _searchController,
      focusNode: _focusNode,
      style: TextStyle(color: CustomColors.whiteColor),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: CustomColors.whiteColor,
          fontSize: 15,
          fontFamily: 'PoppinsRegular',
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
          onPressed: () {
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            } else {
              _focusNode.requestFocus();
            }
          },
        ),
        filled: true,
        fillColor: CustomColors.blackColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: CustomColors.blackColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: CustomColors.blackColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: CustomColors.blackColor, width: 0.5),
        ),
      ),
    );
  }
}
