import '../models/settings_page_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPagePresenter {
  final SettingsPageModel model;

  SettingsPagePresenter(this.model);

  // Firestore reference to the 'users' collection
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Update fields in the model
  void updateUsername(String newUsername) {
    model.username = newUsername;
  }

  void updateBirthday(DateTime newBirthday) {
    model.birthday = newBirthday;
  }

  void updateProfilePicture(String newUrl) {
    model.profilePictureUrl = newUrl;
  }

  void updateHeadline(String newHeadline) {
    model.headline = newHeadline;
  }

  void updateJobTitle(String newJobTitle) {
    model.jobTitle = newJobTitle;
  }

  void updateSkills(List<String> newSkills) {
    model.skills = newSkills;
  }

  void updatePhoneNumber(String newPhoneNumber) {
    model.phoneNumber = newPhoneNumber;
  }

  void updateWebsite(String newWebsite) {
    model.website = newWebsite;
  }

  void updateEducation(String newEducation) {
    model.education = newEducation;
  }

  void updateCertifications(List<String> newCertifications) {
    model.certifications = newCertifications;
  }

  void updateIndustry(String newIndustry) {
    model.industry = newIndustry;
  }

  void updatePreferredLocation(String newLocation) {
    model.preferredLocation = newLocation;
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
        model.headline = loadedModel.headline;
        model.jobTitle = loadedModel.jobTitle;
        model.skills = loadedModel.skills;
        model.phoneNumber = loadedModel.phoneNumber;
        model.website = loadedModel.website;
        model.education = loadedModel.education;
        model.certifications = loadedModel.certifications;
        model.industry = loadedModel.industry;
        model.preferredLocation = loadedModel.preferredLocation;
        print('User profile loaded from Firestore');
      } else {
        print('No profile data found for user');
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }
}
