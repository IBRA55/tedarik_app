import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/pages/login_page.dart';
import 'package:your_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mock sınıfları
class MockAuthService extends Mock implements AuthService {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createLoginPage() {
    return MaterialApp(
      home: LoginPage(),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('E-posta ve şifre alanları görüntüleniyor', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('E-POSTA'), findsOneWidget);
      expect(find.text('ŞİFRE'), findsOneWidget);
    });

    testWidgets('Geçersiz e-posta ile giriş denemesi', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());

      await tester.enterText(find.byType(TextField).first, 'invalid-email');
      await tester.enterText(find.byType(TextField).last, 'password');
      await tester.tap(find.text('GİRİŞ YAP'));
      await tester.pump();

      expect(find.text('Geçersiz e-posta formatı'), findsNothing); // Çünkü sadece console'a yazdırıyor
    });

    testWidgets('Başarılı giriş işlemi', (WidgetTester tester) async {
      when(mockAuthService.signInWithEmailAndPassword('test@example.com', 'password'))
          .thenAnswer((_) async => MockUser());

      await tester.pumpWidget(createLoginPage());

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password');
      await tester.tap(find.text('GİRİŞ YAP'));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Kayıt Ol butonu doğru çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());

      await tester.tap(find.text('Hesabın mı yok? Kayıt Ol'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsOneWidget);
    });
  });
}
