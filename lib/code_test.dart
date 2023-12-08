// import 'package:flutter/material.dart';
// import 'package:sentinex/utils/my_colors.dart';


// class TextCode extends StatefulWidget {
//   const TextCode({super.key});

//   @override
//   State<TextCode> createState() => _TextCodeState();
// }

// class _TextCodeState extends State<TextCode> {
//   @override
//   Widget build(BuildContext context) {
//     MyColors my_colors = MyColors();
//     return  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: 1000,
//                     child: SingleChildScrollView(
//                       child: DataTable(
//                           border: TableBorder.all(
//                               color: my_colors.primaryColor, width: 2),
//                           sortColumnIndex: 0,
//                           showBottomBorder: true,
//                           headingRowColor: MaterialStateColor.resolveWith(
//                               (states) => my_colors.primaryColor),
//                           dataRowColor: MaterialStateColor.resolveWith(
//                               (states) =>
//                                   my_colors.primaryColor.withOpacity(0.2)),
//                           dividerThickness: 2,
//                           columns: [
//                             DataColumn(
//                                 onSort: (columnIndex, ascending) {
//                                   setState(() {
//                                     // if (columnIndex == 0) {
//                                     //   if (sortAscending) {
//                                     //     _patrolAccounts.sort((a, b) =>
//                                     //         (a as PatrolAccountDetails)
//                                     //             .name!
//                                     //             .compareTo(
//                                     //                 (b as PatrolAccountDetails)
//                                     //                     .name!));
//                                     //     sortAscending = false;
//                                     //   } else {
//                                     //     _patrolAccounts.sort((a, b) =>
//                                     //         (b as PatrolAccountDetails)
//                                     //             .name!
//                                     //             .compareTo(
//                                     //                 (a as PatrolAccountDetails)
//                                     //                     .name!));
//                                     //     sortAscending = true;
//                                     //   }
//                                     // }
//                                   });
//                                 },
//                                 label: Text('Name')),
//                             DataColumn(label: Text('Badge Number')),
//                             DataColumn(label: Text('Date Created')),
//                             DataColumn(label: Text('')),
//                             DataColumn(label: Text('')),
//                           ],
//                           rows: [
//                             for (var i = 0; i < _patrolAccounts.length; i++)
//                               DataRow(
//                                 cells: [
//                                   DataCell(
//                                     showEditIcon: true,
//                                     onTap: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return Dialog(
//                                               backgroundColor: Colors.white,
//                                               child: IntrinsicHeight(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(
//                                                       28.0),
//                                                   child: Column(
//                                                     children: [
//                                                       Text(
//                                                         (_patrolAccounts[i]
//                                                                 as PatrolAccountDetails)
//                                                             .name,
//                                                         style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 20,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ));
//                                         },
//                                       );
//                                     },
//                                     AccountsItems(
//                                       accountDetails: _patrolAccounts[i]
//                                           as PatrolAccountDetails,
//                                       column: "name",
//                                     ),
//                                   ),
//                                   DataCell(
//                                     AccountsItems(
//                                       accountDetails: _patrolAccounts[i]
//                                           as PatrolAccountDetails,
//                                       column: "badge_number",
//                                     ),
//                                   ),
//                                   DataCell(
//                                     AccountsItems(
//                                       accountDetails: _patrolAccounts[i]
//                                           as PatrolAccountDetails,
//                                       column: "date_created",
//                                     ),
//                                   ),
//                                   DataCell(
//                                     AccountsItems(
//                                       accountDetails: _patrolAccounts[i]
//                                           as PatrolAccountDetails,
//                                       column: "delete",
//                                     ),
//                                   ),
//                                   DataCell(
//                                     AccountsItems(
//                                       accountDetails: _patrolAccounts[i]
//                                           as PatrolAccountDetails,
//                                       column: "update",
//                                     ),
//                                   ),
//                                 ],
//                               )
//                           ]),
//                     ),
//                   ),
//                 ),
//   }
// }


