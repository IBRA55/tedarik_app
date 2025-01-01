import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import 'profile_page.dart';
import 'supply_detail_page.dart';
import 'my_supplies_page.dart';

class HomePage extends StatefulWidget {
  final String userId;
  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  String currentUserId = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Paylaştıklarım'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MySuppliesPage(userId: currentUserId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Kategoriler'),
              onTap: () {
                print('Kategoriler tıklandı');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.filter_list),
              title: Text('Filtrele'),
              onTap: () {
                print('Filtrele tıklandı');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddSupply() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String sector = '';
        String description = '';

        return AlertDialog(
          title: Text('Tedarik Paylaş'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Tedarik Adı'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Sektör'),
                onChanged: (value) {
                  sector = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Açıklama'),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                _databaseService.addSupply(name, sector, description);
                Navigator.pop(context);
              },
              child: Text('Paylaş'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Arama yapın...',
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query.toLowerCase();
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                _showMenu();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Supply>>(
        stream: _databaseService.getAllSupplies(), // Tüm tedarikleri alıyoruz
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz tedarik yok'));
          } else {
            final supplies = snapshot.data!
                .where((supply) =>
                    supply.name.toLowerCase().contains(_searchQuery) ||
                    supply.description.toLowerCase().contains(_searchQuery))
                .toList();

            return ListView.builder(
              itemCount: supplies.length,
              itemBuilder: (context, index) {
                final supply = supplies[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(Icons.arrow_forward, color: Colors.black),
                    title: Text(supply.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(supply.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SupplyDetailPage(supplyid: supply.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSupply,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
