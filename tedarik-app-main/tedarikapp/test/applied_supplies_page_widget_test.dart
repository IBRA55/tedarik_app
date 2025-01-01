import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/applied_supplies_page.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  testWidgets('AppliedSuppliesPage doğru şekilde yükleniyor', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth();
    final mockFirestore = MockFirebaseFirestore();

    when(mockAuth.currentUser?.uid).thenReturn('test_user_id');

    when(mockFirestore.collection('applications').where('userId', isEqualTo: 'test_user_id').snapshots())
        .thenAnswer((_) => Stream.value(MockQuerySnapshot()));

    await tester.pumpWidget(MaterialApp(
      home: AppliedSuppliesPage(),
    ));

    expect(find.text('Başvurduğum Tedarikler'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Veri boş olduğunda doğru mesaj gösteriliyor', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth();
    final mockFirestore = MockFirebaseFirestore();
    final mockSnapshot = MockQuerySnapshot();

    when(mockAuth.currentUser?.uid).thenReturn('test_user_id');
    when(mockSnapshot.docs).thenReturn([]);

    when(mockFirestore.collection('applications').where('userId', isEqualTo: 'test_user_id').snapshots())
        .thenAnswer((_) => Stream.value(mockSnapshot));

    await tester.pumpWidget(MaterialApp(
      home: AppliedSuppliesPage(),
    ));

    await tester.pump();

    expect(find.text('Henüz başvurduğunuz tedarik yok.'), findsOneWidget);
  });

  testWidgets('Tedarik verisi doğru gösteriliyor', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth();
    final mockFirestore = MockFirebaseFirestore();
    final mockSnapshot = MockQuerySnapshot();
    final mockDocSnapshot = MockDocumentSnapshot();

    when(mockAuth.currentUser?.uid).thenReturn('test_user_id');
    when(mockSnapshot.docs).thenReturn([
      MockQueryDocumentSnapshot()
    ]);
    when(mockDocSnapshot.exists).thenReturn(true);
    when(mockDocSnapshot.data()).thenReturn({'name': 'Test Tedarik', 'sector': 'Sanayi'});

    when(mockFirestore.collection('applications').where('userId', isEqualTo: 'test_user_id').snapshots())
        .thenAnswer((_) => Stream.value(mockSnapshot));

    when(mockFirestore.collection('supplies').doc(any).get())
        .thenAnswer((_) async => mockDocSnapshot);

    await tester.pumpWidget(MaterialApp(
      home: AppliedSuppliesPage(),
    ));

    await tester.pump();

    expect(find.text('Tedarik: Test Tedarik'), findsOneWidget);
    expect(find.text('Sektör: Sanayi'), findsOneWidget);
  });
}
