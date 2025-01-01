import 'package:flutter/material.dart';
import 'share_page.dart';
import 'login_page.dart';
import 'applied_supplies_page.dart'; // Başvurduğum Tedarikler sayfası import edildi
import 'my_supplies_page.dart'; // Paylaşılan tedarikler sayfası import edildi
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth kullanıyoruz

class ProfilePage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Kullanıcıyı FirebaseAuth ile alıyoruz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kullanıcı Adı',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'example@mail.com',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tedarik Paylaş', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SharePage()),
              );
              print('Tedarik Paylaş tıklandı');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Başvurduğum Tedarikler', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // Başvurduğum Tedarikler sayfasına yönlendirme
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppliedSuppliesPage()), // Burada AppliedSuppliesPage yönlendirmesi ekleniyor
              );
              print('Başvurduğum Tedarikler tıklandı');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Paylaştığım Tedarikler', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // MySuppliesPage'e yönlendirme ve kullanıcı ID'sini geçme
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MySuppliesPage(userId: userId), // Burada kullanıcı ID'sini geçiyoruz
                ),
              );
              print('Paylaştığım Tedarikler tıklandı');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              print('Çıkış Yap tıklandı');
            },
          ),
        ],
      ),
    );
  }
}
