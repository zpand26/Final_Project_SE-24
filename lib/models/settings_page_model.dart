import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPageModel {
  String? username;
  DateTime? birthday;
  String? profilePictureUrl;

  // Updated fields
  String? description; // Replaces "headline"
  String? jobTitle;
  List<String>? skills; // New skills field

  SettingsPageModel({
    this.username,
    this.birthday,
    this.profilePictureUrl,
    this.description,
    this.jobTitle,
    this.skills,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'birthday': birthday?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'description': description,
      'jobTitle': jobTitle,
      'skills': skills,
    };
  }

  factory SettingsPageModel.fromFirestore(Map<String, dynamic> data) {
    return SettingsPageModel(
      username: data['username'] as String?,
      birthday: data['birthday'] != null ? DateTime.parse(data['birthday']) : null,
      profilePictureUrl: data['profilePictureUrl'] as String?,
      description: data['description'] as String?,
      jobTitle: data['jobTitle'] as String?,
      skills: data['skills'] != null ? List<String>.from(data['skills']) : [],
    );
  }
}
