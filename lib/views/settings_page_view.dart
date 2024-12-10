import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/settings_page_model.dart';
import '../presenters/settings_page_presenter.dart';
import 'auth_page_view.dart';
import '../models/theme_model.dart';

class SettingsPageView extends StatefulWidget {
  final SettingsPagePresenter presenter;

  const SettingsPageView({super.key, required this.presenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();

  DateTime? _selectedBirthday;
  User? _currentUser;
  bool _isUploading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> predefinedImages = [
    'https://www.usatoday.com/gcdn/media/2020/09/11/USATODAY/usatsports/ghows_gallery-WL-822009996-7ffc2013.jpg?crop=1440,810,x0,y495&width=1440&height=720&format=pjpg&auto=webp',
    'https://www.bkacontent.com/wp-content/uploads/2016/06/Depositphotos_31146757_l-2015.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR131D9ROq-XWTaZL0clqCsild1L_MmWUvY8Q&s',
    'https://faroutguides.com/wp-content/uploads/2021/06/north-star-blog-header-image.jpg',
    'https://www.frontierfireprotection.com/wp-content/uploads/freshizer/730cbf2e2455c64c961be8e18e793f6b_3-Things-a-Fire-Needs-2000-c-90.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      widget.presenter.loadUserProfile(_currentUser!.uid).then((_) {
        setState(() {
          _usernameController.text = widget.presenter.model.username ?? '';
          _headlineController.text = widget.presenter.model.headline ?? '';
          _jobTitleController.text = widget.presenter.model.jobTitle ?? '';
          _phoneNumberController.text = widget.presenter.model.phoneNumber ?? '';
          _websiteController.text = widget.presenter.model.website ?? '';
          _industryController.text = widget.presenter.model.industry ?? '';
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

  Future<void> _selectProfilePicture() async {
    final selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select a Profile Picture'),
          children: predefinedImages.map((imageUrl) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, imageUrl); // Return the selected URL
              },
              child: Row(
                children: [
                  Image.network(imageUrl, width: 50, height: 50),
                  const SizedBox(width: 10),
                  const Text('Select'),
                ],
              ),
            );
          }).toList(),
        );
      },
    );

    if (selectedImage != null && _currentUser != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        widget.presenter.updateProfilePicture(selectedImage);
        await widget.presenter.saveUserProfile(_currentUser!.uid);

        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      } catch (e) {
        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile picture: $e')),
        );
      }
    }
  }

  void _saveProfile() {
    if (_currentUser == null) return;

    widget.presenter.updateUsername(_usernameController.text);
    widget.presenter.updateHeadline(_headlineController.text);
    widget.presenter.updateJobTitle(_jobTitleController.text);
    widget.presenter.updatePhoneNumber(_phoneNumberController.text);
    widget.presenter.updateWebsite(_websiteController.text);
    widget.presenter.updateIndustry(_industryController.text);

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
              onTap: _selectProfilePicture,
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
                    const SizedBox(height: 10),
                    TextField(
                      controller: _headlineController,
                      decoration: const InputDecoration(labelText: 'Headline'),
                    ),
                    TextField(
                      controller: _jobTitleController,
                      decoration: const InputDecoration(labelText: 'Job Title'),
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      controller: _websiteController,
                      decoration: const InputDecoration(labelText: 'Website'),
                    ),
                    TextField(
                      controller: _industryController,
                      decoration: const InputDecoration(labelText: 'Industry'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button
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
