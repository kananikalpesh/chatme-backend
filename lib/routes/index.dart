import 'package:chatme_backend/routes/file_upload_routes.dart';
import 'package:chatme_backend/routes/follow_following_routes.dart';
import 'package:orm_plus/orm_plus.dart' show Router;

import 'auth_routes.dart';
import 'user_routes.dart';

List<Router> getAllRouters() {
  return [
    authRouter(),
    userRouter(),
    followFollowingRouter(),
    fileUploadRouter(),
  ];
}
