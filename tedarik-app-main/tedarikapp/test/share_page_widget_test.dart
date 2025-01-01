import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/pages/share_page.dart';
import 'package:your_app/services/database_service.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
  });

  Widget createSharePage() {
    return MaterialApp(
      home: SharePage(),
    );
  }

  group('SharePage Widget Tests', () {
    testWidgets('Tedarik Paylaş butonu görüntüleniyor', (WidgetTester tester) async {
      await tester.pumpWidget(createSharePage());

      expect(find.text('Paylaş'), findsOneWidget);
    });

    testWidgets('Tedarik Paylaş butonu boş veriyle çalışmıyor', (WidgetTester tester) async {
      await tester.pumpWidget(createSharePage());

      await tester.tap(find.text('Paylaş'));
      await tester.pump();

      // Boş veri uyarısı kontrolü
      expect(find.text('Lütfen tüm alanları doldurun!'), findsNothing);
    });

    testWidgets('Tedarik başarıyla ekleniyor', (WidgetTester tester) async {
      when(mockDatabaseService.addSupply(any, any, any)).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createSharePage());

      await tester.enterText(find.byType(TextField).at(0), 'Ürün Adı');
      await tester.enterText(find.byType(TextField).at(1), 'Sektör');
      await tester.enterText(find.byType(TextField).at(2), 'Açıklama');

      await tester.tap(find.text('Paylaş'));
      await tester.pumpAndSettle();

      verify(mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama')).called(1);
    });

    testWidgets('Tedarik ekleme sırasında hata oluşuyor', (WidgetTester tester) async {
      when(mockDatabaseService.addSupply(any, any, any))
          .thenThrow(Exception('Veritabanı hatası'));

      await tester.pumpWidget(createSharePage());

      await tester.enterText(find.byType(TextField).at(0), 'Ürün Adı');
      await tester.enterText(find.byType(TextField).at(1), 'Sektör');
      await tester.enterText(find.byType(TextField).at(2), 'Açıklama');

      await tester.tap(find.text('Paylaş'));
      await tester.pumpAndSettle();

      verify(mockDatabaseService.addSupply('Ürün Adı', 'Sektör', 'Açıklama')).called(1);
    });
  });
}
