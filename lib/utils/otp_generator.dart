import 'dart:math';

class OtpGenerator {
  static String generateOTP() {
    String otp = (100000 + Random().nextInt(900000)).toString();
    if (otp.length != 6) return generateOTP();
    return otp;
  }
}
