import 'package:flutter/material.dart';
import 'package:sentinex/models/patrol_account_details.dart';
import 'package:sentinex/utils/my_colors.dart';

class AccountsItems extends StatelessWidget {
  final PatrolAccountDetails accountDetails;
  final String column;

  const AccountsItems({
    required this.accountDetails,
    required this.column,
  });

  @override
  Widget build(BuildContext context) {
    MyColors myColors = MyColors();
    String name = accountDetails.name!;
    String badge_number = accountDetails.badge_number!;
    Color textColor = Colors.white;
    if (badge_number == "1231231231") {
      textColor = Colors.red;
    }
    if (column == "name") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${accountDetails.name!}", // replace with actual name
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      );
    } else if (column == "badge_number") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${accountDetails.badge_number!}", // replace with actual name
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
        ),
      );
    } else if (column == "date_created") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${accountDetails.timestamp!.toDate()}", // replace with actual name
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    } else if (column == "delete") {
      return const Icon(Icons.delete);
    } else if (column == "update") {
      return const Icon(Icons.upgrade);
    } else {
      return Container();
    }
  }
}
