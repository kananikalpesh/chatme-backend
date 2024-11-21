import 'package:chatme_backend/utils/enums.dart';

Map<Environment, Map<String, dynamic>> config = {
  Environment.development: {
    'host': "localhost",
    'port': 5432,
    'database': "chatme",
    'username': "postgres",
    'password': "123456",
  },
};
