import 'dart:io';
import 'package:orm_plus/orm_plus.dart' show Res;

extension ResponseHandler on Res {
  Res validationError({required String message}) {
    return json(
      {
        'status': HttpStatus.badRequest,
        'message': message,
      },
      toEncodable: (nonEncodable) {
        if (nonEncodable is DateTime) {
          return nonEncodable.toIso8601String();
        }
        return nonEncodable?.toString();
      },
    );
  }

  Res error({Map? data, String? message, int? statusCode}) {
    return json(
      {
        'status': statusCode ?? HttpStatus.badRequest,
        'message': message ?? "Fail",
        if ((data ?? {}).isNotEmpty) ...{'data': data},
      },
      toEncodable: (nonEncodable) {
        if (nonEncodable is DateTime) {
          return nonEncodable.toIso8601String();
        }
        return nonEncodable?.toString();
      },
    );
  }

  Res success({Object? data, String? message, int? statusCode}) {
    return json(
      {
        'status': statusCode ?? HttpStatus.ok,
        'message': message ?? "Success",
        if (data != null && ((data is Map && data.isNotEmpty) || (data is List && data.isNotEmpty))) ...{'data': data},
      },
      toEncodable: (nonEncodable) {
        if (nonEncodable is DateTime) {
          return nonEncodable.toIso8601String();
        }
        return nonEncodable?.toString();
      },
    );
  }
}
