import 'package:chatme_backend/config/database.dart';
import 'package:chatme_backend/utils/enums.dart';
import 'package:chatme_backend/utils/response_handler.dart';
import 'package:orm_plus/orm_plus.dart';

import '../utils/jwt_handler.dart';

RequestHandler verifyToken = (req, res) async {
  String? token = req.headers.value('Authorization');
  if (token == null) {
    return res.error(message: "Authorization token missing");
  }

  var jwtData = JwtHandler().isValidToken(token: token);
  if (jwtData.$1 == false || jwtData.$2 == null) throw "invalid authorization token";

  req.data['user_id'] = jwtData.$2;
  Map? user = await Database().orm.findOne(table: Tables.users.value, fields: ['id'], where: {'id': jwtData.$2});
  if (user == null) throw "invalid authorization token";
  return await req.next(res);
};
