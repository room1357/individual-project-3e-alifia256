import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/categories_screen.dart';
import 'package:pemrograman_mobile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final userName = userData?['name'] ?? 'User';
    final userEmail = userData?['email'] ?? 'user@email.com';

    final List<Widget> _pages = <Widget>[
      const HomeContent(),
      const CategoriesScreen(),
      ProfileScreen(userName: userName, userEmail: userEmail),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/logo1.png', height: 32),
            const SizedBox(width: 10),
            const Text('CityFood'),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag_outlined)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, $userName!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings', arguments: userData);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  final List<Map<String, String>> products = const [
    {
      "name": "Sate Ayam",
      "price": "Rp 25.000",
      "image": "assets/Mieayam.jpeg",
    },
    {
      "name": "Nasi Goreng Spesial",
      "price": "Rp 30.000",
      "image": "assets/NasiGorengSpesial.jpeg",
    },
    {
      "name": "Es Teh Manis",
      "price": "Rp 5.000",
      "image": "assets/EsTeh.jpeg",
    },
    {
      "name": "Mie Ayam",
      "price": "Rp 20.000",
      "image": "assets/Mieayam.jpeg",
    },
    {
      "name": "Jus Alpukat",
      "price": "Rp 15.000",
      "image": "assets/JusAlpukat.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        // UBAH: Gunakan panjang daftar produk
        itemCount: products.length,
        itemBuilder: (context, index) {
          // UBAH: Kirim data produk ke card
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  // UBAH: Fungsi ini sekarang menerima satu objek produk
  Widget _buildProductCard(Map<String, String> product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // UBAH: Gunakan Image.asset untuk menampilkan gambar lokal
              child: Image.asset(
                product['image']!, // Ambil path gambar dari data produk
                fit: BoxFit.cover,
                width: double.infinity,
                // Error builder untuk menangani jika gambar tidak ditemukan
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.fastfood, size: 40, color: Colors.grey));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name']!, // Ambil nama dari data produk
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['price']!, // Ambil harga dari data produk
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}