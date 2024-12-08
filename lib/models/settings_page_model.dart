class SettingsPageModel {
  String? username;
  DateTime? birthday;
  String? profilePictureUrl;

  SettingsPageModel({
    this.username,
    this.birthday,
    this.profilePictureUrl,
  });

  // Method to save user data (could be connected to Firebase Firestore in the future)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'birthday': birthday?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Method to load user data from a map (useful for Firebase integration)
  factory SettingsPageModel.fromMap(Map<String, dynamic> map) {
    return SettingsPageModel(
      username: map['username'] as String?,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'])
          : null,
      profilePictureUrl: map['profilePictureUrl'] as String?,
    );
  }
}
