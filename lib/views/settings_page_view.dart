import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/settings_page_model.dart';
import '../presenters/settings_page_presenter.dart';
import '../models/theme_model.dart'; // For ThemeModel
import '../views/auth_page_view.dart'; // Ensure this is correctly imported

class SettingsPageView extends StatefulWidget {
  final SettingsPagePresenter presenter;

  const SettingsPageView({super.key, required this.presenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key for sidebar

  DateTime? _selectedBirthday;
  User? _currentUser;
  bool _isUploading = false;

  final List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      widget.presenter.loadUserProfile(_currentUser!.uid).then((_) {
        setState(() {
          _usernameController.text = widget.presenter.model.username ?? '';
          _descriptionController.text = widget.presenter.model.description ?? '';
          _jobTitleController.text = widget.presenter.model.jobTitle ?? '';
          _skills.addAll(widget.presenter.model.skills ?? []);
          _selectedBirthday = widget.presenter.model.birthday;
        });
      });
    }
  }

  void _addSkill() {
    final skill = _skillsController.text.trim();
    if (skill.isNotEmpty) {
      setState(() {
        _skills.add(skill);
        _skillsController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _saveProfile() {
    if (_currentUser == null) return;

    widget.presenter.updateUsername(_usernameController.text);
    widget.presenter.updateDescription(_descriptionController.text);
    widget.presenter.updateJobTitle(_jobTitleController.text);
    widget.presenter.updateSkills(_skills);

    widget.presenter.saveUserProfile(_currentUser!.uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
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

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key here
      appBar: AppBar(
        title: const Text('Settings Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Use the key to open the sidebar
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
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),

            // Birthday Section
            ListTile(
              title: const Text('Birthday'),
              subtitle: Text(
                _selectedBirthday != null
                    ? '${_selectedBirthday!.year}-${_selectedBirthday!.month}-${_selectedBirthday!.day}'
                    : 'Not set',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickBirthday,
            ),
            const SizedBox(height: 20),

            // Professional Information Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Professional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
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
                      onSubmitted: (_) => _addSkill(),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: _skills
                          .map((skill) => Chip(
                        label: Text(skill),
                        onDeleted: () => _removeSkill(skill),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button at the Bottom
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
