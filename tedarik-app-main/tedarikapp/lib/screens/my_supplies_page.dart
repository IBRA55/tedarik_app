import 'package:flutter/material.dart';
import '../services/database_service.dart';

class MySuppliesPage extends StatefulWidget {
  final String userId; // Kullanıcı ID'si parametre olarak alınıyor

  MySuppliesPage({required this.userId});

  @override
  _MySuppliesPageState createState() => _MySuppliesPageState();
}

class _MySuppliesPageState extends State<MySuppliesPage> {
  final DatabaseService _databaseService = DatabaseService();

  void _showUpdateDialog(Supply supply) {
    String updatedName = supply.name;
    String updatedSector = supply.sector;
    String updatedDescription = supply.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tedarik Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Tedarik Adı'),
                controller: TextEditingController(text: supply.name),
                onChanged: (value) {
                  updatedName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Sektör'),
                controller: TextEditingController(text: supply.sector),
                onChanged: (value) {
                  updatedSector = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Açıklama'),
                controller: TextEditingController(text: supply.description),
                onChanged: (value) {
                  updatedDescription = value;
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
                _databaseService.updateSupply(
                  supply.id,
                  updatedName,
                  updatedSector,
                  updatedDescription,
                );
                Navigator.pop(context);
              },
              child: Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSupply(String supplyId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tedarik Sil'),
          content: Text('Bu tedariki silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                _databaseService.deleteSupply(supplyId);
                Navigator.pop(context);
              },
              child: Text('Sil'),
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
        title: Text('Paylaştıklarım'),
      ),
      body: StreamBuilder<List<Supply>>(
        stream: _databaseService.getUserSupplies(widget.userId), // Kullanıcı ID'si burada kullanılıyor
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz paylaştığınız bir tedarik yok'));
          } else {
            final supplies = snapshot.data!;
            return ListView.builder(
              itemCount: supplies.length,
              itemBuilder: (context, index) {
                final supply = supplies[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      supply.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(supply.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showUpdateDialog(supply);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteSupply(supply.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
