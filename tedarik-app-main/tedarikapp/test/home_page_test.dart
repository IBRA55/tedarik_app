import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/database_service.dart';
import 'package:your_app/pages/home_page.dart';

// Mock sınıfları
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  group('HomePage Unit Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockDatabaseService mockDatabaseService;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockDatabaseService = MockDatabaseService();
    });

    test('Kullanıcı kimliği doğru şekilde alınmalı', () {
      when(mockAuth.currentUser?.uid).thenReturn('test_user_id');
      expect(mockAuth.currentUser?.uid, equals('test_user_id'));
    });

    test('Veritabanından tedarikler alınıyor', () {
      when(mockDatabaseService.getAllSupplies()).thenAnswer((_) => Stream.value([]));
      expect(mockDatabaseService.getAllSupplies(), isA<Stream>());
    });

    test('Arama sorgusu filtreleme yapıyor', () {
      final List<Supply> supplies = [
        Supply(id: '1', name: 'Makine', description: 'Sanayi makinesi'),
        Supply(id: '2', name: 'Yazılım', description: 'ERP yazılımı'),
      ];

      final filteredSupplies = supplies
          .where((supply) =>
              supply.name.toLowerCase().contains('makine') ||
              supply.description.toLowerCase().contains('makine'))
          .toList();

      expect(filteredSupplies.length, 1);
      expect(filteredSupplies.first.name, 'Makine');
    });
  });
}
