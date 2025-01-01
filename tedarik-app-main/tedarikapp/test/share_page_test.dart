import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/database_service.dart';
import 'package:your_app/pages/share_page.dart';

// Mock DatabaseService sınıfı
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
  });

  group('SharePage Unit Tests', () {
    test('Tedarik başarıyla ekleniyor', () async {
      when(mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama'))
          .thenAnswer((_) async => Future.value());

      await mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama');
      verify(mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama'))
          .called(1);
    });

    test('Tedarik ekleme sırasında hata oluşuyor', () async {
      when(mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama'))
          .thenThrow(Exception('Veritabanı hatası'));

      expect(
        () async => await mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
