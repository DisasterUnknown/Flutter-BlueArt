// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:blue_art_mad2/network/user/resetPassword.dart';
import 'package:blue_art_mad2/network/user/updateProfile.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _usernameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;
  bool _showProfileMsg = false;
  bool _showPasswordMsg = false;

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }

  Future<void> _loadProfileDetails() async {
    final username = await LocalSharedPreferences.getString(SharedPrefValues.userName);
    final profileBase64 = await LocalSharedPreferences.getString(SharedPrefValues.userPfp);

    Uint8List? imageBytes;
    if (profileBase64 != null && profileBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(profileBase64);
      } catch (_) {
        imageBytes = null;
      }
    }

    setState(() {
      _usernameController.text = username ?? '';
      _profileImageBytes = imageBytes;
    });
  }

  Future<bool> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (status.isDenied) return (await Permission.camera.request()).isGranted;
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<bool> _checkGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isGranted) return true;
    if (status.isDenied) return (await Permission.photos.request()).isGranted;
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<void> _changeProfilePhoto() async {
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: CustomColors.getThemeColor(context, 'primary')),
                title: Text(
                  "Camera",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.getThemeColor(context, 'textColor')),
                ),
                onTap: () async {
                  bool granted = await _checkCameraPermission();
                  if (!granted) return Navigator.pop(ctx);
                  final file = await _picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(ctx, file);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: CustomColors.getThemeColor(context, 'primary')),
                title: Text(
                  "Gallery",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.getThemeColor(context, 'textColor')),
                ),
                onTap: () async {
                  bool granted = await _checkGalleryPermission();
                  if (!granted) return Navigator.pop(ctx);
                  final file = await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(ctx, file);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _profileImageBytes = bytes;
      });
      await LocalSharedPreferences.saveString(SharedPrefValues.userPfp, base64Encode(bytes));
    }
  }

  void _saveProfileSection() async {
    setState(() => _usernameError = null);

    if (_usernameController.text.isEmpty) {
      setState(() => _usernameError = "Username cannot be empty");
      return;
    }

    String base64Image = '';
    if (_profileImageBytes != null) {
      base64Image = base64Encode(_profileImageBytes!);
    }

    final result = await UpdateProfile(ref).update(name: _usernameController.text, pFPdata: base64Image);
    if (result['statusCode'] == 200) {
      setState(() => _showProfileMsg = true);
      Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showProfileMsg = false);
      });
    } else {
      final message = result['body']['message'] ?? "Failed to Update Profile!";
      setState(() => _passwordError = message.toString());
    }
  }

  void _savePasswordSection() async {
    setState(() => _passwordError = null);

    if (_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      setState(() => _passwordError = "All password fields are required");
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _passwordError = "Passwords do not match!");
      return;
    }

    final result = await ResetPassword(ref).reset(oldPassword: _oldPasswordController.text, newPassword: _newPasswordController.text, newPasswordConfirmation: _confirmPasswordController.text);
    if (result['statusCode'] == 200) {
      setState(() => _showPasswordMsg = true);
      Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showPasswordMsg = false);
      });
    } else {
      final message = result['body']['message'] ?? "Failed to reset password";
      setState(() => _passwordError = message.toString());
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              width: formWidth,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'), width: 1.5),
                borderRadius: BorderRadius.circular(12),
                color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  Text(
                    "Profile Settings",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomColors.getThemeColor(context, 'textColor')),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blueGrey.shade300,
                        backgroundImage: _profileImageBytes != null ? MemoryImage(_profileImageBytes!) : null,
                        child: _profileImageBytes == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
                        onPressed: _changeProfilePhoto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: CustomColors.getThemeColor(context, 'textColor'), fontSize: 18),
                    decoration: InputDecoration(labelText: "Username", errorText: _usernameError),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showProfileMsg ? 1.0 : 0.0,
                    child: Text(
                      'Profile Updated Successfully',
                      style: TextStyle(color: CustomColors.getThemeColor(context, 'labelSmall'), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveProfileSection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.getThemeColor(context, 'primary'),
                      foregroundColor: CustomColors.getThemeColor(context, 'onPrimary'),
                    ),
                    child: const Text("Save Profile"),
                  ),
                ],
              ),
            ),
            // Password Section
            Container(
              width: formWidth,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'), width: 1.5),
                borderRadius: BorderRadius.circular(12),
                color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomColors.getThemeColor(context, 'textColor')),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(_oldPasswordController, "Old Password", _showOldPassword, (val) => setState(() => _showOldPassword = val)),
                  const SizedBox(height: 16),
                  _buildPasswordField(_newPasswordController, "New Password", _showNewPassword, (val) => setState(() => _showNewPassword = val)),
                  const SizedBox(height: 16),
                  _buildPasswordField(_confirmPasswordController, "Confirm Password", _showConfirmPassword, (val) => setState(() => _showConfirmPassword = val)),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showPasswordMsg ? 1.0 : 0.0,
                    child: Text(
                      'Password Updated Successfully',
                      style: TextStyle(color: CustomColors.getThemeColor(context, 'labelSmall'), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _savePasswordSection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.getThemeColor(context, 'primary'),
                      foregroundColor: CustomColors.getThemeColor(context, 'onPrimary'),
                    ),
                    child: const Text("Save Password"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool showPassword, Function(bool) toggleShow) {
    return TextField(
      controller: controller,
      obscureText: !showPassword,
      style: TextStyle(color: CustomColors.getThemeColor(context, 'textColor'), fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        errorText: _passwordError,
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: CustomColors.getThemeColor(context, 'onPrimary')),
          onPressed: () => toggleShow(!showPassword),
        ),
      ),
    );
  }
}
