import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtHandler {
  static final JwtHandler _jwtHandler = JwtHandler._internal();

  JwtHandler._internal();

  factory JwtHandler() => _jwtHandler;

  String generateToken({required String id}) {
    final jwt = JWT({'sub': id, 'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000, 'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000});
    return jwt.sign(SecretKey("chatme"));
  }

  (bool, String?) isValidToken({required String token}) {
    try {
      final jwt = JWT.verify(token, SecretKey("chatme"));
      return (!(jwt.payload['exp'] < DateTime.now().millisecondsSinceEpoch ~/ 1000), jwt.payload['sub']);
    } catch (_) {
      return (false, null);
    }
  }

  String generateOTPToken({
    required String id,
    bool isForgotPassword = false,
  }) {
    final jwt = JWT({
      'otp_id': id,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      if (isForgotPassword) ...{'forgot_password': isForgotPassword}
    });
    return jwt.sign(SecretKey("chatme"));
  }

  (String?, bool) getOTPTokenData(String token) {
    final jwt = JWT.verify(token, SecretKey("chatme"));
    return (jwt.payload['otp_id'], jwt.payload['forgot_password'] ?? false);
  }

  String generateForgotPasswordToken({required String userid}) {
    final jwt = JWT({
      'user_id': userid,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    });
    return jwt.sign(SecretKey("chatme"));
  }

  String? getForgotPasswordTokenData(String token) {
    final jwt = JWT.verify(token, SecretKey("chatme"));
    return (jwt.payload['user_id']);
  }
}
