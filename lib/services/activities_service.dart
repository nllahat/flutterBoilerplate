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

  Future<Activity> addActivity(Activity activity) async {
    Map<String, dynamic> jsonMap = activity.toJson();
    jsonMap["organization"] = Firestore.instance.document("organizations/${jsonMap["organization"]}");

    try {
      DocumentReference docRef = await activitiesCollection.add(jsonMap);
      print("Document written with ID: ${docRef.documentID}");

      return Activity.fromFirestore(await docRef.get());
    } catch (e) {
      print("Error adding document: $e");
      throw e;
    }
  }
}
