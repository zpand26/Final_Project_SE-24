import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPageModel {
  String? username;
  DateTime? birthday;
  String? profilePictureUrl;

  SettingsPageModel({
    this.username,
    this.birthday,
    this.profilePictureUrl,
  });

  // Convert model to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'birthday': birthday?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Create model from Firestore document
  factory SettingsPageModel.fromFirestore(Map<String, dynamic> data) {
    return SettingsPageModel(
      username: data['username'] as String?,
      birthday: data['birthday'] != null ? DateTime.parse(data['birthday']) : null,
      profilePictureUrl: data['profilePictureUrl'] as String?,
    );
  }
}
