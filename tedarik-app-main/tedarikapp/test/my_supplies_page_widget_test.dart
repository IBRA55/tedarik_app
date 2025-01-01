import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/pages/my_supplies_page.dart';
import 'package:your_app/services/database_service.dart';
import 'package:your_app/models/supply.dart';

// Mock sınıfı
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
  });

  Widget createMySuppliesPage() {
    return MaterialApp(
      home: MySuppliesPage(userId: 'user123'),
    );
  }

  group('MySuppliesPage Widget Tests', () {
    testWidgets('Sayfa yüklenirken gösterge görüntüleniyor', (WidgetTester tester) async {
      when(mockDatabaseService.getUserSupplies('user123'))
          .thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(createMySuppliesPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Tedarikler doğru şekilde listeleniyor', (WidgetTester tester) async {
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

      await tester.pumpWidget(createMySuppliesPage());
      await tester.pump();

      expect(find.text('Malzeme 1'), findsOneWidget);
      expect(find.text('Malzeme 2'), findsOneWidget);
    });

    testWidgets('Tedarik güncelleme diyalogu açılıyor', (WidgetTester tester) async {
      when(mockDatabaseService.getUserSupplies('user123'))
          .thenAnswer((_) => Stream.value([
                Supply(
                    id: '1',
                    name: 'Malzeme 1',
                    sector: 'İnşaat',
                    description: 'Açıklama 1'),
              ]));

      await tester.pumpWidget(createMySuppliesPage());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Tedarik Güncelle'), findsOneWidget);
    });

    testWidgets('Tedarik silme diyalogu açılıyor', (WidgetTester tester) async {
      when(mockDatabaseService.getUserSupplies('user123'))
          .thenAnswer((_) => Stream.value([
                Supply(
                    id: '1',
                    name: 'Malzeme 1',
                    sector: 'İnşaat',
                    description: 'Açıklama 1'),
              ]));

      await tester.pumpWidget(createMySuppliesPage());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Tedarik Sil'), findsOneWidget);
    });
  });
}
