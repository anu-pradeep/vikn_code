import 'package:flutter/material.dart';
import 'package:vikn_code/utils/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,

    required this.title,
    this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minTileHeight: 80,
          leading: Image.asset(imagePath,  width: 24,
            height: 24,
            fit: BoxFit.contain, ),
          title: Text(
            title,
            style: TextStyle(
              color: CustomColors.whiteColor,
              fontFamily: 'PoppinsRegular',
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: CustomColors.whiteColor,
            size: 16,
          ),
          onTap: onTap,
        ),
        Divider(color: Colors.white10, height: 1),
      ],
    );
  }
}
