import 'package:bcrypt/bcrypt.dart';
import 'package:chatme_backend/controllers/common_controller.dart';
import 'package:chatme_backend/utils/response_handler.dart';
import 'package:orm_plus/orm_plus.dart';

import '../config/database.dart';
import '../utils/common.dart';
import '../utils/enums.dart';
import '../utils/strings.dart';

part '../controllers/user_controller.dart';

Router userRouter() {
  Router router = Router(endPoint: "/user");
  router.post("/update", verifyToken, [updateUser]);
  router.get("/details", verifyToken, [userDetails]);
  router.post("/change-password", verifyToken, [changePassword]);
  router.get("/profile", verifyToken, [userProfile]);
  router.get("/profile/:id", verifyToken, [userProfile]);
  router.get("/find", verifyToken, [findUsers]);

  router.get("/users", verifyToken, [allUsers]);
  return router;
}
