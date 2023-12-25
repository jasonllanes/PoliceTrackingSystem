import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sentinex/utils/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/patrol_account_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

List<String> _list = [];
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rankSelected = "";

Future<List<String>> fetchList() async {
  QuerySnapshot querySnapshot = await _firestore.collection('Dropdown').get();
  return querySnapshot.docs.map((doc) => doc['data']).toList().cast<String>();
}

class _HomeState extends State<Home> {
  final MapController mapController = MapController();
  LatLng _center = LatLng(8.4748454, 124.6482512);

  @override
  void initState() {
    super.initState();
    fetchList().then((list) => setState(() {
          _list = list;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 17.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 100,
                    height: 100,
                    child: Tooltip(
                        message: 'Location: 8.4748454, 124.6482512',
                        child: Icon(Icons.location_on, color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
        //Generate a list of accounts
        //Create 2 dropdowns for Station and Deployment

        Container(
          width: 300,
          child: CustomDropdown<String>(
            closedFillColor: MyColors().primaryColor,
            expandedFillColor: MyColors().primaryColor,
            expandedSuffixIcon: const Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
            ),
            closedSuffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            hintText: 'Select rank',
            items: _list,

            // key: _For,
            onChanged: (value) {
              setState(() => rankSelected = value);

              print('changing value to: $value');
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  PatrolAccountDetails patrolAccountDetails =
                      PatrolAccountDetails.fromSnap(ds);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _center = LatLng(
                            patrolAccountDetails.location.latitude.toDouble(),
                            patrolAccountDetails.location.longitude.toDouble());
                      });

                      mapController.move(
                          LatLng(
                              patrolAccountDetails.location.latitude.toDouble(),
                              patrolAccountDetails.location.longitude
                                  .toDouble()),
                          17.0);
                      print(patrolAccountDetails.location.latitude.toString() +
                          ", " +
                          patrolAccountDetails.location.longitude.toString());
                    },
                    child: Card(
                      color: MyColors().primaryColor,
                      child: ListTile(
                          title: Text(patrolAccountDetails.name),
                          subtitle: Text(patrolAccountDetails.badge_number),
                          trailing: Text(patrolAccountDetails.location.latitude
                                  .toString() +
                              ", " +
                              patrolAccountDetails.location.longitude
                                  .toString())),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
