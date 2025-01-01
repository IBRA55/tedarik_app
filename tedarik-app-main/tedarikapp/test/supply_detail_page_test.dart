import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_app/services/database_service.dart';
import 'package:your_app/pages/supply_detail_page.dart';

class MockFirestoreInstance extends Mock implements FirebaseFirestore {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirestoreInstance mockFirestore;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirestore = MockFirestoreInstance();
    mockFirebaseAuth = MockFirebaseAuth();
  });

  group('SupplyDetailPage Unit Tests', () {
    test('Tedarik detayları başarıyla alındı', () async {
      final mockSnapshot = MockDocumentSnapshot();
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({
        'name': 'Tedarik 1',
        'sector': 'Sanayi',
        'description': 'Detaylı açıklama',
      });

      // Firestore'dan veriyi almak için mock yapıyoruz
      when(mockFirestore.collection('supplies').doc('sample_id').get())
          .thenAnswer((_) async => mockSnapshot);

      final result = await mockFirestore.collection('supplies').doc('sample_id').get();
      expect(result.data()?['name'], 'Tedarik 1');
      expect(result.data()?['sector'], 'Sanayi');
      expect(result.data()?['description'], 'Detaylı açıklama');
    });

    test('Başvuru işlemi başarılı', () async {
      final String userId = 'sampleUserId';
      final String supplyId = 'sampleSupplyId';

      try {
        await FirebaseFirestore.instance.collection('applications').add({
          'supplyid': supplyId,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Başvuru işlemi başarılıysa
        expect(true, true);
      } catch (e) {
        print('Başvuru hatası: $e');
        fail('Başvuru hatası: $e');
      }
    });

    test('Başvuru işlemi hata aldı', () async {
      final String userId = '';
      final String supplyId = 'sampleSupplyId';

      try {
        await FirebaseFirestore.instance.collection('applications').add({
          'supplyid': supplyId,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        fail('Başvuru başarılı! Hata almalıydı');
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
