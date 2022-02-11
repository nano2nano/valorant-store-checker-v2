class AuthenticationFailedException implements Exception {
  static const message = 'Authentication Failed';

  @override
  String toString() => 'Authentication Failed';
}
