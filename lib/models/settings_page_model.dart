import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPageModel {
  String? username;
  DateTime? birthday;
  String? profilePictureUrl;

  // New fields
  String? headline;
  String? jobTitle;
  List<String>? skills;
  String? phoneNumber;
  String? website;
  String? education;
  List<String>? certifications;
  String? industry;
  String? preferredLocation;

  SettingsPageModel({
    this.username,
    this.birthday,
    this.profilePictureUrl,
    this.headline,
    this.jobTitle,
    this.skills,
    this.phoneNumber,
    this.website,
    this.education,
    this.certifications,
    this.industry,
    this.preferredLocation,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'birthday': birthday?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'headline': headline,
      'jobTitle': jobTitle,
      'skills': skills,
      'phoneNumber': phoneNumber,
      'website': website,
      'education': education,
      'certifications': certifications,
      'industry': industry,
      'preferredLocation': preferredLocation,
    };
  }

  factory SettingsPageModel.fromFirestore(Map<String, dynamic> data) {
    return SettingsPageModel(
      username: data['username'] as String?,
      birthday: data['birthday'] != null ? DateTime.parse(data['birthday']) : null,
      profilePictureUrl: data['profilePictureUrl'] as String?,
      headline: data['headline'] as String?,
      jobTitle: data['jobTitle'] as String?,
      skills: data['skills'] != null ? List<String>.from(data['skills']) : [],
      phoneNumber: data['phoneNumber'] as String?,
      website: data['website'] as String?,
      education: data['education'] as String?,
      certifications: data['certifications'] != null
          ? List<String>.from(data['certifications'])
          : [],
      industry: data['industry'] as String?,
      preferredLocation: data['preferredLocation'] as String?,
    );
  }
}
