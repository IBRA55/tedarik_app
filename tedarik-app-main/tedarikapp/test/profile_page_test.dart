import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_app/pages/profile_page.dart';

// Mock FirebaseAuth sınıfı
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
  });

  group('ProfilePage Unit Tests', () {
    test('Kullanıcı kimliği doğru alınıyor', () {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user123');

      final userId = mockFirebaseAuth.currentUser?.uid ?? '';
      expect(userId, equals('user123'));
    });

    test('Kullanıcı kimliği boş dönüyor', () {
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      final userId = mockFirebaseAuth.currentUser?.uid ?? '';
      expect(userId, equals(''));
    });
  });
}
