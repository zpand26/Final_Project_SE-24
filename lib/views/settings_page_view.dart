import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/settings_page_model.dart';
import '../presenters/settings_page_presenter.dart';
import 'auth_page_view.dart';

class SettingsPageView extends StatefulWidget {
  final SettingsPagePresenter presenter;

  const SettingsPageView({super.key, required this.presenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final TextEditingController _usernameController = TextEditingController();
  DateTime? _selectedBirthday;
  User? _currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;

    // Load user profile if logged in
    if (_currentUser != null) {
      widget.presenter.loadUserProfile(_currentUser!.uid).then((_) {
        setState(() {
          _usernameController.text = widget.presenter.model.username ?? '';
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

  void _saveProfile() {
    if (_currentUser == null) return;

    widget.presenter.updateUsername(_usernameController.text);
    widget.presenter.saveUserProfile(_currentUser!.uid);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      appBar: AppBar(
        title: const Text('Settings Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Use the key to open the drawer
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Appearance Settings',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Dark mode switch
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false, // Placeholder, replace with theme logic
                onChanged: (isDark) {
                  // Add theme toggle logic here
                },
              ),
            ),
            const Divider(), // Adds a divider for clarity
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: _logout,
            ),
            ListTile(
              title: const Text('Credits'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Data Sources & Credits'),
                      content: const Text(
                        'This app uses the following data sets:\n\n'
                            '1. Software Engineer Jobs & Salaries 2024 by Emre Öksüz, on Kaggle\n'
                            '2. Jobs and Salaries in Data Science by Hummaam Qaasim on Kaggle\n\n'
                            'Thank you to all the contributors!',
                        style: TextStyle(fontSize: 14),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
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
            const Text('Profile Picture', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Add profile picture selection logic here
              },
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
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
