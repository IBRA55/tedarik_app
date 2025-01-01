import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/database_service.dart';
import 'package:your_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mock sınıfları
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  group('HomePage Widget Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockDatabaseService mockDatabaseService;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockDatabaseService = MockDatabaseService();
    });

    testWidgets('HomePage başlığı doğru görüntüleniyor', (WidgetTester tester) async {
      when(mockAuth.currentUser?.uid).thenReturn('test_user_id');
      when(mockDatabaseService.getAllSupplies()).thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(MaterialApp(
        home: HomePage(userId: 'test_user_id'),
      ));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Arama yapın...'), findsOneWidget);
    });

    testWidgets('Yükleniyor göstergesi doğru görüntüleniyor', (WidgetTester tester) async {
      when(mockDatabaseService.getAllSupplies()).thenAnswer(
        (_) => Stream.empty(),
      );

      await tester.pumpWidget(MaterialApp(
        home: HomePage(userId: 'test_user_id'),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Boş veri durumu kontrol ediliyor', (WidgetTester tester) async {
      when(mockDatabaseService.getAllSupplies()).thenAnswer(
        (_) => Stream.value([]),
      );

      await tester.pumpWidget(MaterialApp(
        home: HomePage(userId: 'test_user_id'),
      ));

      await tester.pump();

      expect(find.text('Henüz tedarik yok'), findsOneWidget);
    });

    testWidgets('Tedarik listesi doğru şekilde görüntüleniyor', (WidgetTester tester) async {
      when(mockDatabaseService.getAllSupplies()).thenAnswer(
        (_) => Stream.value([
          Supply(id: '1', name: 'Makine', description: 'Sanayi makinesi'),
          Supply(id: '2', name: 'Yazılım', description: 'ERP yazılımı'),
        ]),
      );

      await tester.pumpWidget(MaterialApp(
        home: HomePage(userId: 'test_user_id'),
      ));

      await tester.pump();

      expect(find.text('Makine'), findsOneWidget);
      expect(find.text('Sanayi makinesi'), findsOneWidget);
      expect(find.text('Yazılım'), findsOneWidget);
    });

    testWidgets('Tedarik detay sayfasına geçiş yapılıyor', (WidgetTester tester) async {
      when(mockDatabaseService.getAllSupplies()).thenAnswer(
        (_) => Stream.value([
          Supply(id: '1', name: 'Makine', description: 'Sanayi makinesi'),
        ]),
      );

      await tester.pumpWidget(MaterialApp(
        home: HomePage(userId: 'test_user_id'),
      ));

      await tester.pump();

      await tester.tap(find.text('Makine'));
      await tester.pumpAndSettle();

      expect(find.byType(SupplyDetailPage), findsOneWidget);
    });

    testWidgets('Profil sayfasına geçiş yapılıyor', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(userId: 'test_user_id'),
      ));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePage), findsOneWidget);
    });
  });
}
