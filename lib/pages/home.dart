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

List<String> _list = [""];
String _searchText = "";
List<GeoPoint> pointList = <GeoPoint>[];
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var station = "";

class _HomeState extends State<Home> {
  final MapController mapController = MapController();
  LatLng _center = LatLng(8.4748454, 124.6482512);

  //Create a method that stores the list of long and lat o each user
  Stream<List<GeoPoint>> fetchAllLocations() {
    return _firestore
        .collection('Users')
        .where('status', isEqualTo: "Timed In")
        .snapshots()
        .map((querySnapshot) {
      List<GeoPoint> list = [];
      querySnapshot.docs.forEach((result) {
        GeoPoint station = result.data()['location'];
        list.add(station);
      });
      return list;
    });
  }

  Future<List<String>> fetchList() async {
    List<String> list = [];
    await _firestore.collection('Dropdown').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        List<String> stations = List<String>.from(result.data()['stations']);
        list.addAll(stations);
      });
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    fetchList().then((list) => setState(() {
          list = _list;
        }));
    fetchAllLocations().listen((list) => setState(() {
          print(pointList);
          pointList = list;
        }));
  }

  @override
  Widget build(BuildContext context) {
    var _station;

    return Scaffold(
      backgroundColor: MyColors().oxfordBlue,
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 16.0,
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
                MarkerLayer(markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _center,
                    child: Tooltip(
                        message:
                            'Location: 8.4748454, 124.6482512 \n Station: default_location',
                        child: Icon(Icons.location_on, color: Colors.red)),
                  ),
                ]),
                MarkerLayer(
                  markers: pointList.map((e) {
                    return Marker(
                      point: LatLng(e.latitude, e.longitude),
                      width: 100.0,
                      height: 100.0,
                      child: Tooltip(
                          message:
                              'Location: ${e.latitude}, ${e.longitude} \n Station: ${_station}',
                          child: Icon(Icons.location_on, color: Colors.red)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              children: [
                // CustomDropdown<String>(
                //   closedFillColor: MyColors().primaryColor,
                //   expandedFillColor: MyColors().primaryColor,
                //   expandedSuffixIcon: const Icon(
                //     Icons.arrow_drop_up,
                //     color: Colors.white,
                //   ),
                //   closedSuffixIcon: const Icon(
                //     Icons.arrow_drop_down,
                //     color: Colors.white,
                //   ),
                //   hintText: 'Select station',
                //   items: _list,

                //   // key: _For,
                //   onChanged: (value) {
                //     setState(() => station = value);

                //     print('changing value to: $value');
                //   },
                // ),
                // CustomDropdown<String>(
                //   closedFillColor: MyColors().primaryColor,
                //   expandedFillColor: MyColors().primaryColor,
                //   expandedSuffixIcon: const Icon(
                //     Icons.arrow_drop_up,
                //     color: Colors.white,
                //   ),
                //   closedSuffixIcon: const Icon(
                //     Icons.arrow_drop_down,
                //     color: Colors.white,
                //   ),
                //   hintText: 'Select deployment',
                //   items: _list,

                //   // key: _For,
                //   onChanged: (value) {
                //     setState(() => station = value);

                //     print('changing value to: $value');
                //   },
                // ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('status', isEqualTo: 'Timed In')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    final docs = snapshot.data!.docs.where((doc) {
                      return doc['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchText.toLowerCase());
                    }).toList();
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Reset Map",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    setState(() {
                                      _center = LatLng(8.4748454, 124.6482512);
                                    });
                                    mapController.move(
                                        LatLng(8.4748454, 124.6482512), 17.0);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              onChanged: ((value) {
                                setState(() {
                                  _searchText = value;
                                });
                              }),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                labelText: 'Search Name',
                                labelStyle: TextStyle(color: Colors.white),
                                suffixIcon: Icon(Icons.search),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            //Add a button to go back to original position of map

                            Expanded(
                              child: ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds = docs[index];
                                  PatrolAccountDetails patrolAccountDetails =
                                      PatrolAccountDetails.fromSnap(ds);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _center = LatLng(
                                            patrolAccountDetails
                                                .location.latitude
                                                .toDouble(),
                                            patrolAccountDetails
                                                .location.longitude
                                                .toDouble());
                                      });

                                      mapController.move(
                                          LatLng(
                                              patrolAccountDetails
                                                  .location.latitude
                                                  .toDouble(),
                                              patrolAccountDetails
                                                  .location.longitude
                                                  .toDouble()),
                                          17.0);
                                      print(patrolAccountDetails
                                              .location.latitude
                                              .toString() +
                                          ", " +
                                          patrolAccountDetails
                                              .location.longitude
                                              .toString());
                                    },
                                    child: Card(
                                      color: MyColors().pictonBlue,
                                      child: ListTile(
                                        title: Text(patrolAccountDetails.name),
                                        subtitle: Text(patrolAccountDetails
                                                .station +
                                            ", " +
                                            patrolAccountDetails.deployment),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
