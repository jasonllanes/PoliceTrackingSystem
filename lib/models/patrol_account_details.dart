import 'package:cloud_firestore/cloud_firestore.dart';

class PatrolAccountDetails {
  final String name;
  final String first_name;
  final String last_name;
  final String rank;
  final String badge_number;
  final String deployment;
  final String image_evidence;
  final GeoPoint location;
  final String station;
  final String status;
  final Timestamp timestamp;
  final Timestamp lastUpdated;

  const PatrolAccountDetails({
    required this.name,
    required this.first_name,
    required this.last_name,
    required this.rank,
    required this.badge_number,
    required this.deployment,
    required this.image_evidence,
    required this.location,
    required this.station,
    required this.status,
    required this.timestamp,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'first_name': first_name,
        'last_name': last_name,
        'rank': rank,
        'badge_number': badge_number,
        'deployment': deployment,
        'image_evidence': image_evidence,
        'location': location,
        'station': station,
        'status': status,
        'timestamp': timestamp,
        'lastUpdated': lastUpdated,
      };

  static PatrolAccountDetails fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return PatrolAccountDetails(
      name: snap['name'],
      first_name: snap['first_name'],
      last_name: snap['last_name'],
      rank: snap['rank'],
      badge_number: snap['badge_number'],
      deployment: snap['deployment'],
      image_evidence: snap['image_evidence'],
      location: snap['location'],
      station: snap['station'],
      status: snap['status'],
      timestamp: snap['timestamp'],
      lastUpdated: snap['lastUpdated'],
    );
  }
}
