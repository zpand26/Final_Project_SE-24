import '../models/settings_page_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPagePresenter {
  final SettingsPageModel model;

  SettingsPagePresenter(this.model);

  // Firestore reference to the 'users' collection
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Update the username in the model
  void updateUsername(String newUsername) {
    model.username = newUsername;
  }

  // Update the birthday in the model
  void updateBirthday(DateTime newBirthday) {
    model.birthday = newBirthday;
  }

  // Save user profile data to Firestore
  Future<void> saveUserProfile(String userId) async {
    try {
      await usersCollection.doc(userId).set(model.toFirestore());
      print('User profile saved to Firestore');
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  // Load user profile data from Firestore
  Future<void> loadUserProfile(String userId) async {
    try {
      final docSnapshot = await usersCollection.doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final loadedModel = SettingsPageModel.fromFirestore(data);
        model.username = loadedModel.username;
        model.birthday = loadedModel.birthday;
        model.profilePictureUrl = loadedModel.profilePictureUrl;
        print('User profile loaded from Firestore');
      } else {
        print('No profile data found for user');
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }
}
