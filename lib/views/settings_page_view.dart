import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/settings_page_model.dart';
import '../presenters/settings_page_presenter.dart';
import '../models/theme_model.dart';
import '../views/auth_page_view.dart';

class SettingsPageView extends StatefulWidget {
  final SettingsPagePresenter presenter;

  const SettingsPageView({super.key, required this.presenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _certificationsController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? _selectedBirthday;
  User? _currentUser;
  bool _isUploading = false;

  final List<String> _skills = [];
  final List<String> _certifications = [];
  final List<Map<String, String>> _education = [];

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      widget.presenter.loadUserProfile(_currentUser!.uid).then((_) {
        setState(() {
          _nameController.text = widget.presenter.model.name ?? '';
          _usernameController.text = widget.presenter.model.username ?? '';
          _descriptionController.text = widget.presenter.model.description ?? '';
          _jobTitleController.text = widget.presenter.model.jobTitle ?? '';
          _skills.addAll(widget.presenter.model.skills ?? []);
          _certifications.addAll(widget.presenter.model.certifications ?? []);
          if (widget.presenter.model.education != null) {
            for (var edu in widget.presenter.model.education!.split(';')) {
              final parts = edu.split('|');
              if (parts.length == 2) {
                _education.add({'university': parts[0], 'degree': parts[1]});
              }
            }
          }
          _selectedBirthday = widget.presenter.model.birthday;
        });
      });
    }
  }

  Future<void> _pickBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        widget.presenter.updateBirthday(picked);
      });
    }
  }

  void _addOrEditEducation({Map<String, String>? existing}) {
    final TextEditingController universityController = TextEditingController(
      text: existing?['university'] ?? '',
    );
    final TextEditingController degreeController = TextEditingController(
      text: existing?['degree'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add Education' : 'Edit Education'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: universityController,
                decoration: const InputDecoration(labelText: 'University'),
              ),
              TextField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: 'Degree'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (existing != null) {
                    _education.remove(existing);
                  }
                  _education.add({
                    'university': universityController.text,
                    'degree': degreeController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveProfile() {
    if (_currentUser == null) return;

    widget.presenter.updateName(_nameController.text);
    widget.presenter.updateUsername(_usernameController.text);
    widget.presenter.updateDescription(_descriptionController.text);
    widget.presenter.updateJobTitle(_jobTitleController.text);
    widget.presenter.updateSkills(_skills);
    widget.presenter.updateCertifications(_certifications);
    widget.presenter.updateEducation(
      _education.map((edu) => '${edu['university']}|${edu['degree']}').join(';'),
    );

    widget.presenter.saveUserProfile(_currentUser!.uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Settings Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'Appearance Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeModel.isDarkMode,
                onChanged: (isDark) {
                  themeModel.toggleTheme();
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture Section
            const Text('Profile Picture'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {}, // Placeholder for profile picture update
              child: CircleAvatar(
                radius: 50,
                backgroundImage: widget.presenter.model.profilePictureUrl != null
                    ? NetworkImage(widget.presenter.model.profilePictureUrl!)
                    : null,
                child: widget.presenter.model.profilePictureUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),


            // Username Section
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Personal info card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                    // Name Section
                    const Text(
                      'Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Birthday Section
                    const Text(
                      'Birthday',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickBirthday,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedBirthday != null
                                  ? '${_selectedBirthday!.year}-${_selectedBirthday!.month}-${_selectedBirthday!.day}'
                                  : 'Select your birthday',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Professional Information Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Professional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    TextField(
                      controller: _jobTitleController,
                      decoration: const InputDecoration(labelText: 'Job Title'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Skills'),
                    TextField(
                      controller: _skillsController,
                      decoration: const InputDecoration(labelText: 'Add a Skill'),
                      onSubmitted: (_) {
                        final skill = _skillsController.text.trim();
                        if (skill.isNotEmpty) {
                          setState(() {
                            _skills.add(skill);
                            _skillsController.clear();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: _skills
                          .map((skill) => Chip(
                        label: Text(skill),
                        onDeleted: () {
                          setState(() {
                            _skills.remove(skill);
                          });
                        },
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Education and Certifications Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Education & Certifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // Education Section
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _education.length,
                      itemBuilder: (context, index) {
                        final edu = _education[index];
                        return ListTile(
                          title: Text(edu['university'] ?? ''),
                          subtitle: Text(edu['degree'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _addOrEditEducation(existing: edu),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _education.remove(edu);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => _addOrEditEducation(),
                      child: const Text('Add Education'),
                    ),
                    const Divider(),
                    // Certifications Section
                    const Text('Certifications'),
                    TextField(
                      controller: _certificationsController,
                      decoration: const InputDecoration(labelText: 'Add a Certification'),
                      onSubmitted: (_) {
                        final cert = _certificationsController.text.trim();
                        if (cert.isNotEmpty) {
                          setState(() {
                            _certifications.add(cert);
                            _certificationsController.clear();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: _certifications
                          .map((cert) => Chip(
                        label: Text(cert),
                        onDeleted: () {
                          setState(() {
                            _certifications.remove(cert);
                          });
                        },
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
