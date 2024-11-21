import 'package:orm_plus/orm_plus.dart';

import '../utils/enums.dart';

part '../models/user_schema.dart';
part '../models/otp_schema.dart';
part '../models/user_relation_schema.dart';
part '../models/media_schema.dart';
part '../models/posts_schema.dart';
part '../models/stories_schema.dart';
part '../models/posts_relation_schema.dart';
part '../models/stories_relation_schema.dart';

class Database {
  static final Database _database = Database._internal();

  Database._internal();

  factory Database() => _database;

  late final ORM? _orm;

  ORM get orm {
    if (_orm == null) throw "Database are not initialized";
    return _orm;
  }

  Future<void> connect() async {
    PostgresClient client = PostgresClient(host: 'localhost', database: 'chatme', userName: 'postgres', password: "123456");
    await client.connect();
    _orm = ORM(client: client, schemas: [userSchema, otpSchema, userRelationSchema, mediaSchema, postRelationSchema, storyRelationSchema, postsSchema, storySchema], logging: true);
  }
}
