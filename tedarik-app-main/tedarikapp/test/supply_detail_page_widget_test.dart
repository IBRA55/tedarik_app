import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_app/pages/supply_detail_page.dart';
import 'package:your_app/services/database_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirestoreInstance extends Mock implements FirebaseFirestore {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirestoreInstance mockFirestoreInstance;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestoreInstance = MockFirestoreInstance();
  });

  Widget createSupplyDetailPage() {
    return MaterialApp(
      home: SupplyDetailPage(supplyid: 'sampleSupplyId'),
    );
  }

  group('SupplyDetailPage Widget Tests', () {
    testWidgets('Tedarik detayları başarıyla gösteriliyor', (WidgetTester tester) async {
      // Mock veriyi ekliyoruz
      when(mockFirestoreInstance.collection('supplies').doc('sampleSupplyId').get())
          .thenAnswer((_) async => MockDocumentSnapshot());
      
      await tester.pumpWidget(createSupplyDetailPage());

      expect(find.text('Tedarik Detayı'), findsOneWidget);
      expect(find.text('Ürünün Adı: Belirtilmemiş'), findsOneWidget); // Varsayılan veri
    });

    testWidgets('Başvuru butonu tıklanabiliyor ve mesaj görünüyor', (WidgetTester tester) async {
      await tester.pumpWidget(createSupplyDetailPage());

      await tester.tap(find.text('Başvur'));
      await tester.pump();

      expect(find.text('Başvurunuz başarıyla yapıldı!'), findsOneWidget); // Mesajı kontrol et
    });

    testWidgets('Giriş yapılmamışsa hata mesajı gösteriliyor', (WidgetTester tester) async {
      when(mockFirebaseAuth.currentUser).thenReturn(null); // Kullanıcı girişi yapılmadı

      await tester.pumpWidget(createSupplyDetailPage());

      await tester.tap(find.text('Başvur'));
      await tester.pump();

      expect(find.text('Giriş yapmalısınız!'), findsOneWidget); // Hata mesajını kontrol et
    });
  });
}
