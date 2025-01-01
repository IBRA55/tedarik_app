import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppliedSuppliesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Başvurduğum Tedarikler'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final applications = snapshot.data?.docs ?? [];
          if (applications.isEmpty) {
            return Center(child: Text("Henüz başvurduğunuz tedarik yok."));
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var application = applications[index];
              var supplyid = application['supplyid'];  // supplyid kullanıldı

              if (supplyid == null || supplyid == '') {
                return ListTile(
                  title: Text('Tedarik ID’si eksik'),
                  subtitle: Text('Bu başvuru için geçerli tedarik bulunamadı.'),
                );
              }

              String supplyidString = supplyid.toString().trim();
              print('Başvuru SupplyID: $supplyidString');

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('supplies')
                    .doc(supplyidString)
                    .get(),
                builder: (context, supplySnapshot) {
                  if (supplySnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (supplySnapshot.hasError) {
                    return ListTile(
                      title: Text('Tedarik Yüklenirken Hata'),
                      subtitle: Text('Hata: ${supplySnapshot.error}'),
                    );
                  }

                  if (!supplySnapshot.hasData || !supplySnapshot.data!.exists) {
                    return ListTile(
                      title: Text('Tedarik Bulunamadı'),
                      subtitle: Text('Bu tedarik verisi bulunamadı.'),
                    );
                  }

                  Map<String, dynamic> supplyData =
                      supplySnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    title: Text('Tedarik: ${supplyData['name'] ?? 'Bilinmeyen İsim'}'),
                    subtitle: Text('Sektör: ${supplyData['sector'] ?? 'Bilinmeyen Sektör'}'),
                    trailing: Text(
                      'Başvuru Zamanı: ${application['timestamp'] != null ? application['timestamp'].toDate().toString() : 'Bilinmiyor'}',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
