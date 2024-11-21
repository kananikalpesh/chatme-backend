import 'package:bcrypt/bcrypt.dart';
import 'package:chatme_backend/config/database.dart';
import 'package:chatme_backend/utils/common.dart';
import 'package:chatme_backend/utils/enums.dart';
import 'package:chatme_backend/utils/strings.dart';
import 'package:orm_plus/orm_plus.dart';
import '../utils/jwt_handler.dart';
import '../utils/otp_generator.dart';
import '../utils/response_handler.dart';

part '../controllers/auth_controller.dart';

Router authRouter() {
  Router router = Router(endPoint: "/auth");

  router.post("/login", loginValidate, [loginUser]);

  router.post("/register", registerValidate, [registerUser, registerUserOtpSent]);

  router.post("/verifyOtp", otpVerify);

  router.post("/forgotPassword", forgotPassword);

  router.post("/resetPassword", resetPassword);

  return router;
}
