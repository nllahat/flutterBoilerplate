import '../models/activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesService {
  // collection reference
  final CollectionReference activitiesCollection =
      Firestore.instance.collection('activities');

  // activity list from snapshot
  List<Activity> _activityListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => Activity.fromFirestore(doc))
        .toList();
  }

  // get activities stream
  Stream<List<Activity>> get activities {
    return activitiesCollection.snapshots().map(_activityListFromSnapshot);
  }
}
