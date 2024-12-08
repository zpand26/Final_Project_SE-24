import '../models/settings_page_model.dart';

class SettingsPagePresenter {
  final SettingsPageModel model;

  SettingsPagePresenter(this.model);

  // Methods to update user details
  void updateUsername(String newUsername) {
    model.username = newUsername;
  }

  void updateBirthday(DateTime newBirthday) {
    model.birthday = newBirthday;
  }

  void updateProfilePicture(String newUrl) {
    model.profilePictureUrl = newUrl;
  }

  // Method to save the model data (placeholder for Firebase/Firestore logic)
  void saveData() {
    // Implement Firebase or local storage save logic here
    print('Data saved: ${model.toMap()}');
  }
}
