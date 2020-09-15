import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskulator/Expense%20Check/services/auth.dart';

abstract class SuggestionsController {
  static Map<String, dynamic> _defaultSuggestions = {
    "names": [],
    "amounts": ["5", "10", "15", "20"],
    "descriptions": {"Rent": 0, "Grocery": 0, "Food": 0}
  };

  static Future<Map<String, dynamic>> fetchSuggestions() async {
    try {
      FirebaseUser user = await Auth.getCurrentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection("suggestions")
          .document(user.uid)
          .get();
      if (doc == null) return _defaultSuggestions;
      return {
        "names": List<String>.from(doc.data["names"]),
        "amounts": List<String>.from(doc.data["amounts"]),
        "descriptions": Map<String, int>.from(doc.data["descriptions"])
      };
    } catch (e) {
      return null;
    }
  }

  static void updateSuggestions(Map<String, dynamic> suggestions) async {
    FirebaseUser user = await Auth.getCurrentUser();
    await Firestore.instance
        .collection("suggestions")
        .document(user.uid)
        .setData(suggestions);
  }
}
