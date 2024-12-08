import 'package:flutter/material.dart';
import '../models/settings_page_model.dart';
import '../presenters/settings_page_presenter.dart';

class SettingsPageView extends StatefulWidget {
  final SettingsPagePresenter presenter;

  const SettingsPageView({super.key, required this.presenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final TextEditingController _usernameController = TextEditingController();
  DateTime? _selectedBirthday;

  @override
  void initState() {
    super.initState();
    // Initialize controller with the current username
    _usernameController.text = widget.presenter.model.username ?? '';
    _selectedBirthday = widget.presenter.model.birthday;
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
    widget.presenter.updateUsername(_usernameController.text);
    widget.presenter.saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
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
                widget.presenter.updateProfilePicture('newPictureUrl');
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
