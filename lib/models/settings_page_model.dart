import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPageModel {
  String? username;
  String? name;
  DateTime? birthday;
  String? profilePictureUrl;
  String? education;
  List<String>? certifications;

  // Updated fields
  String? description; // Replaces "headline"
  String? jobTitle;
  List<String>? skills; // New skills field

  SettingsPageModel({
    this.username,
    this.name,
    this.birthday,
    this.profilePictureUrl,
    this.description,
    this.jobTitle,
    this.skills,
    this.education,
    this.certifications,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'name': name,
      'birthday': birthday?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'description': description,
      'jobTitle': jobTitle,
      'skills': skills,
      'education': education,
      'certifications': certifications,
    };
  }

  factory SettingsPageModel.fromFirestore(Map<String, dynamic> data) {
    return SettingsPageModel(
      username: data['username'] as String?,
      name: data['name'] as String?,
      birthday: data['birthday'] != null ? DateTime.parse(data['birthday']) : null,
      profilePictureUrl: data['profilePictureUrl'] as String?,
      description: data['description'] as String?,
      jobTitle: data['jobTitle'] as String?,
      skills: data['skills'] != null ? List<String>.from(data['skills']) : [],
      education: data['education'] as String?,
      certifications: data['certifications'] != null ? List<String>.from(data['certifications']) : [],
    );
  }
}
