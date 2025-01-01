import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_app/services/auth_service.dart';

// Mock sınıfları
class MockAuthService extends Mock implements AuthService {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('LoginPage Unit Tests', () {
    test('Geçerli e-posta formatı kontrolü', () {
      final validEmail = 'test@example.com';
      final invalidEmail = 'invalid-email';

      final emailRegex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

      expect(emailRegex.hasMatch(validEmail), isTrue);
      expect(emailRegex.hasMatch(invalidEmail), isFalse);
    });

    test('Kullanıcı başarılı giriş yapıyor', () async {
      when(mockAuthService.signInWithEmailAndPassword('test@example.com', 'password'))
          .thenAnswer((_) async => MockUser());

      final user = await mockAuthService.signInWithEmailAndPassword('test@example.com', 'password');
      expect(user, isA<User>());
    });

    test('Kullanıcı girişinde hata oluşuyor', () async {
      when(mockAuthService.signInWithEmailAndPassword('test@example.com', 'wrongpassword'))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () async => await mockAuthService.signInWithEmailAndPassword('test@example.com', 'wrongpassword'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });
}
