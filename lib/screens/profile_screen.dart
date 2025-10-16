import 'package:flutter/material.dart';

// MODIFIKASI: Ubah menjadi StatelessWidget dan terima data lewat constructor
class ProfileScreen extends StatelessWidget {
  // Terima nama dan email dari parent widget
  final String userName;
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  // Widget helper untuk membuat field profil
  Widget _buildProfileField(
      {required String label, required String value, required IconData icon}) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MODIFIKASI: Hapus Scaffold, AppBar, dan Drawer.
    // Widget ini sekarang hanya mengembalikan kontennya saja.
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  child:
                      Icon(Icons.person, size: 70, color: Colors.blue.shade800),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon:
                          Icon(Icons.camera_alt, color: Colors.white, size: 22),
                      onPressed: () {
                        // Handle ganti foto profil
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          _buildProfileField(
              label: 'Nama Lengkap', value: userName, icon: Icons.person_outline),
          SizedBox(height: 20),
          _buildProfileField(
              label: 'Email', value: userEmail, icon: Icons.email_outlined),
        ],
      ),
    );
  }
}