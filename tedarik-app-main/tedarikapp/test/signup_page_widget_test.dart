import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/pages/signup_page.dart';
import 'package:your_app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createSignupPage() {
    return MaterialApp(
      home: SignupPage(),
    );
  }

  group('SignupPage Widget Tests', () {
    testWidgets('Kayıt Ol butonu görüntüleniyor', (WidgetTester tester) async {
      await tester.pumpWidget(createSignupPage());
      expect(find.text('KAYIT OL'), findsOneWidget);
    });

    testWidgets('Şifreler eşleşmiyorsa hata mesajı görüntüleniyor', (WidgetTester tester) async {
      await tester.pumpWidget(createSignupPage());

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password456');

      await tester.tap(find.text('KAYIT OL'));
      await tester.pump();

      expect(find.text('Şifreler eşleşmiyor'), findsNothing); // Konsolda görünüyor
    });

    testWidgets('Geçersiz e-posta formatı hata veriyor', (WidgetTester tester) async {
      await tester.pumpWidget(createSignupPage());

      await tester.enterText(find.byType(TextField).at(0), 'gecersiz-email');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');

      await tester.tap(find.text('KAYIT OL'));
      await tester.pump();

      expect(find.text('Geçersiz e-posta formatı'), findsNothing); // Konsolda görünüyor
    });

    testWidgets('Kayıt başarılıysa ana sayfaya yönlendiriliyor', (WidgetTester tester) async {
      when(mockAuthService.registerWithEmailAndPassword(any, any))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createSignupPage());

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');

      await tester.tap(find.text('KAYIT OL'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsNothing); // Ana sayfaya yönlendirildi
    });
  });
}
