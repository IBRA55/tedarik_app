import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final CollectionReference supplyCollection =
      FirebaseFirestore.instance.collection('supplies');

  // Tedarik ekleme
  Future<void> addSupply(String name, String sector, String description) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser; // Kullanıcı bilgisi
      if (currentUser == null) {
        print('Kullanıcı oturum açmamış.');
        return;
      }
      String userId = currentUser.uid;

      DocumentReference docRef = await supplyCollection.add({
        'name': name,
        'sector': sector,
        'description': description,
        'userId': userId, // Burada userId ekleniyor
        'createdAt': Timestamp.now(),
      });
      print("Veri başarıyla Firestore'a eklendi. Belge ID: ${docRef.id}");
    } catch (e) {
      print('Veri eklenirken bir hata oluştu: $e');
    }
  }

  // Tedarik güncelleme
  Future<void> updateSupply(
      String supplyid, String name, String sector, String description) async {
    try {
      await supplyCollection.doc(supplyid).update({
        'name': name,
        'sector': sector,
        'description': description,
      });
      print("Tedarik başarıyla güncellendi.");
    } catch (e) {
      print('Tedarik güncellenirken bir hata oluştu: $e');
    }
  }

  // Tedarik silme
  Future<void> deleteSupply(String supplyid) async {
    try {
      await supplyCollection.doc(supplyid).delete();
      print("Tedarik başarıyla silindi.");
    } catch (e) {
      print('Tedarik silinirken bir hata oluştu: $e');
    }
  }

  // Kullanıcıya ait tedarikleri alma
  Stream<List<Supply>> getUserSupplies(String userId) {
    return supplyCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(_supplyListFromSnapshot);
  }

  // Tüm tedarikleri alma (getAllSupplies metodu)
  Stream<List<Supply>> getAllSupplies() {
    return supplyCollection.snapshots().map(_supplyListFromSnapshot);
  }

  // Firestore'dan gelen verileri listeye dönüştürme
  List<Supply> _supplyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Supply.fromFirestore(doc);
    }).toList();
  }
}

// Supply Model
class Supply {
  final String id;
  final String name;
  final String sector;
  final String description;
  final String userId;
  final Timestamp createdAt;

  Supply({
    required this.id,
    required this.name,
    required this.sector,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  // Firestore verisini kullanarak Supply nesnesi oluşturma
  factory Supply.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Supply(
      id: doc.id,
      name: data['name'] ?? '',
      sector: data['sector'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Firestore'a veri eklerken kullanılacak format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sector': sector,
      'description': description,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}
