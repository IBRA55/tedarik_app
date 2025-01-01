import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/database_service.dart';
import 'package:your_app/models/supply.dart';

// Mock sınıfı
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
  });

  group('MySuppliesPage Unit Tests', () {
    test('Kullanıcıya ait tedarikler getiriliyor', () async {
      when(mockDatabaseService.getUserSupplies('user123'))
          .thenAnswer((_) => Stream.value([
                Supply(
                    id: '1',
                    name: 'Malzeme 1',
                    sector: 'İnşaat',
                    description: 'Açıklama 1'),
                Supply(
                    id: '2',
                    name: 'Malzeme 2',
                    sector: 'Tekstil',
                    description: 'Açıklama 2'),
              ]));

      final stream = mockDatabaseService.getUserSupplies('user123');
      expectLater(
        stream,
        emits([
          isA<Supply>(),
          isA<Supply>(),
        ]),
      );
    });

    test('Tedarik güncelleme doğru çalışıyor', () async {
      when(mockDatabaseService.updateSupply('1', 'Yeni Ad', 'Yeni Sektör', 'Yeni Açıklama'))
          .thenAnswer((_) async => Future.value());

      await mockDatabaseService.updateSupply('1', 'Yeni Ad', 'Yeni Sektör', 'Yeni Açıklama');

      verify(mockDatabaseService.updateSupply('1', 'Yeni Ad', 'Yeni Sektör', 'Yeni Açıklama'))
          .called(1);
    });

    test('Tedarik silme doğru çalışıyor', () async {
      when(mockDatabaseService.deleteSupply('1'))
          .thenAnswer((_) async => Future.value());

      await mockDatabaseService.deleteSupply('1');

      verify(mockDatabaseService.deleteSupply('1')).called(1);
    });
  });
}
