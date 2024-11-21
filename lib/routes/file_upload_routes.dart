import 'dart:io';
import 'package:chatme_backend/controllers/common_controller.dart';
import 'package:chatme_backend/utils/response_handler.dart';
import 'package:chatme_backend/utils/strings.dart';
import 'package:orm_plus/orm_plus.dart';
import 'package:path/path.dart';

part '../controllers/file_upload_controller.dart';

Router fileUploadRouter() {
  Router router = Router(endPoint: "/upload");
  router.post('/file', verifyToken, [fileUpload]);
  return router;
}
