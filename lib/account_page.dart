import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';

  // Fungsi untuk mengambil data dari SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil data pengguna dari SharedPreferences
    setState(() {
      userName = prefs.getString('username') ?? 'Unknown User';
      userEmail = prefs.getString('email') ?? 'No email provided';
      userPhone = prefs.getString('phone') ?? 'No phone number provided';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Memanggil fungsi untuk memuat data pengguna
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://www.example.com/avatar.jpg'), // Gantilah dengan foto profil yang sesuai
            ),
            const SizedBox(height: 16),
            Text(
              'Name: $userName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $userEmail',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $userPhone',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengedit profil jika diperlukan
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
