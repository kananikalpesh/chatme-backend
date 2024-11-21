import 'dart:math';

import 'package:chatme_backend/config/database.dart';
import 'package:chatme_backend/seeder/seeder_data.dart';
import 'package:chatme_backend/utils/common.dart';
import 'package:chatme_backend/utils/enums.dart';

class Seeder {
  static Future<void> seedData() async {
    Random random = Random();
    await Database().orm.multiinsert(table: Tables.users.value, data: users);
    List<Map<String, dynamic>> usersData = await Database().orm.findAll(table: Tables.users.value);
    List<String> ids = usersData.map((e) => e['id'].toString()).toList();
    ids.shuffle();
    List<Map<String, dynamic>> userRelationData = [];
    for (int i = 0; i < 10000; i++) {
      String followerId = ids[random.nextInt(ids.length)];
      String followingId = ids[random.nextInt(ids.length)];

      Map<String, dynamic>? relation = userRelationData.firstWhereOrNull((e) => ((e['follower_id'] == followerId && e['following_id'] == followingId) || (e['follower_id'] == followingId && e['following_id'] == followerId)));
      if (relation == null) {
        userRelationData.add({'follower_id': followerId, 'following_id': followingId, 'follower_status': random.nextBool(), 'following_status': random.nextBool()});
      }
    }
    if (userRelationData.isNotEmpty) {
      await Database().orm.multiinsert(table: Tables.userRelation.value, data: userRelationData);
    }
  }
}
