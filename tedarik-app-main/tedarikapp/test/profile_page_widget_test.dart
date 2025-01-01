import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/pages/profile_page.dart';
import 'package:your_app/pages/share_page.dart';
import 'package:your_app/pages/applied_supplies_page.dart';
import 'package:your_app/pages/my_supplies_page.dart';
import 'package:your_app/pages/login_page.dart';

void main() {
  Widget createProfilePage() {
    return MaterialApp(
      home: ProfilePage(),
    );
  }

  group('ProfilePage Widget Tests', () {
    testWidgets('Profil sayfası başlığı doğru görüntüleniyor', (WidgetTester tester) async {
      await tester.pumpWidget(createProfilePage());
      expect(find.text('Profilim'), findsOneWidget);
    });

    testWidgets('Tedarik Paylaş butonu çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(createProfilePage());

      await tester.tap(find.text('Tedarik Paylaş'));
      await tester.pumpAndSettle();

      expect(find.byType(SharePage), findsOneWidget);
    });

    testWidgets('Başvurduğum Tedarikler butonu çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(createProfilePage());

      await tester.tap(find.text('Başvurduğum Tedarikler'));
      await tester.pumpAndSettle();

      expect(find.byType(AppliedSuppliesPage), findsOneWidget);
    });

    testWidgets('Paylaştığım Tedarikler butonu çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(createProfilePage());

      await tester.tap(find.text('Paylaştığım Tedarikler'));
      await tester.pumpAndSettle();

      expect(find.byType(MySuppliesPage), findsOneWidget);
    });

    testWidgets('Çıkış Yap butonu çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(createProfilePage());

      await tester.tap(find.text('Çıkış Yap'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
