part of '../routes/file_upload_routes.dart';

RequestHandler fileUpload = (req, res) async {
  if (req.body['file'] == null || req.body['file'] is! Map) {
    throw "File can not be null or empty";
  }
  if (req.body['file']?['fileName'] == null || req.body['file']?['bytes'] == null) {
    throw Strings.somethingIsWrong;
  }
  String? bucket = req.body['bucket'];
  String filePath = joinAll([
    'files',
    if (bucket != null) ...[...bucket.split(",")],
    "${DateTime.now().millisecondsSinceEpoch.toString()}_${req.body['file']['fileName']}"
  ]);

  File file = File(filePath);
  file.createSync(recursive: true);
  file.writeAsBytesSync(req.body['file']['bytes']);
  return res.success(data: {'filePath': filePath});
};
