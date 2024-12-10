import '../models/settings_page_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPagePresenter {
  final SettingsPageModel model;

  SettingsPagePresenter(this.model);

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Update fields
  void updateUsername(String newUsername) {
    model.username = newUsername;
  }

  void updateBirthday(DateTime newBirthday) {
    model.birthday = newBirthday;
  }

  void updateProfilePicture(String newUrl) {
    model.profilePictureUrl = newUrl;
  }

  void updateDescription(String newDescription) {
    model.description = newDescription;
  }

  void updateJobTitle(String newJobTitle) {
    model.jobTitle = newJobTitle;
  }

  void updateSkills(List<String> newSkills) {
    model.skills = newSkills;
  }

  Future<void> saveUserProfile(String userId) async {
    try {
      await usersCollection.doc(userId).set(model.toFirestore());
      print('User profile saved to Firestore');
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  Future<void> loadUserProfile(String userId) async {
    try {
      final docSnapshot = await usersCollection.doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final loadedModel = SettingsPageModel.fromFirestore(data);
        model.username = loadedModel.username;
        model.birthday = loadedModel.birthday;
        model.profilePictureUrl = loadedModel.profilePictureUrl;
        model.description = loadedModel.description;
        model.jobTitle = loadedModel.jobTitle;
        model.skills = loadedModel.skills;
        print('User profile loaded from Firestore');
      } else {
        print('No profile data found for user');
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }
}
