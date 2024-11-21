import 'package:chatme_backend/config/database.dart';
import 'package:chatme_backend/controllers/common_controller.dart';
import 'package:chatme_backend/utils/enums.dart';
import 'package:chatme_backend/utils/response_handler.dart';
import 'package:chatme_backend/utils/strings.dart';
import 'package:orm_plus/orm_plus.dart';

part '../controllers/follow_following_controller.dart';

Router followFollowingRouter() {
  Router router = Router(endPoint: "/user");
  router.post("/follow", verifyToken, [checkFollowingData, followUser]);
  router.post("/follow-back", verifyToken, [checkFollowingData, followBackUser]);
  router.post("/unfollow", verifyToken, [checkFollowingData, unfollowUser]);
  router.post("/followers", verifyToken, [followers]);
  router.post("/followings", verifyToken, [followings]);
  router.post("/followers/:id", verifyToken, [followers]);
  router.post("/followings/:id", verifyToken, [followings]);
  return router;
}
