import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('SignupPage Unit Tests', () {
    test('Kayıt başarılı', () async {
      when(mockAuthService.registerWithEmailAndPassword('test@example.com', 'password123'))
          .thenAnswer((_) async => MockUser());

      var user = await mockAuthService.registerWithEmailAndPassword('test@example.com', 'password123');
      expect(user, isA<User>());
    });

    test('Kayıt başarısız', () async {
      when(mockAuthService.registerWithEmailAndPassword('test@example.com', 'password123'))
          .thenAnswer((_) async => null);

      var user = await mockAuthService.registerWithEmailAndPassword('test@example.com', 'password123');
      expect(user, isNull);
    });

    test('Geçersiz e-posta formatı', () {
      final email = 'gecersiz-email';
      final isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
      expect(isValid, false);
    });

    test('Şifreler eşleşmiyor', () {
      final password = 'password123';
      final confirmPassword = 'password456';
      expect(password == confirmPassword, false);
    });
  });
}
