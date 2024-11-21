part of '../routes/follow_following_routes.dart';

RequestHandler checkFollowingData = (req, res) async {
  String followingId = req.body['userId'] ?? "";
  if (followingId.trim().isEmpty) {
    return res.validationError(message: "User id missing");
  }
  Map<String, dynamic>? relation = await Database().orm.findOne(
    table: Tables.userRelation.value,
    fields: ['id'],
    where: {
      Op.or: [
        {'follower_id': req.data['user_id'], 'following_id': followingId},
        {'following_id': req.data['user_id'], 'follower_id': followingId},
      ]
    },
  );
  req.data['relation'] = relation;
  return req.next(res);
};

RequestHandler followUser = (req, res) async {
  String followingId = req.body['userId'] ?? "";
  Map<String, dynamic>? relation = req.data['relation'];

  if (relation != null) throw Strings.somethingIsWrong;

  Object relationData = await Database().orm.insert(
        table: Tables.userRelation.value,
        data: {"follower_id": req.data['user_id'], "following_id": followingId},
        returning: true,
      );
  return res.success(data: (relationData as List).firstOrNull);
};

RequestHandler followBackUser = (req, res) async {
  String followingId = req.body['userId'] ?? "";
  Map<String, dynamic>? relation = req.data['relation'];
  if (relation == null) throw Strings.somethingIsWrong;

  if (relation['follower_id'] == followingId && relation['follower_status'] == true && relation['following_status'] == false) {
    Object relationData = await Database().orm.update(table: Tables.userRelation.value, where: {'id': relation['id']}, data: {'following_status': true}, returning: true);
    return res.success(data: (relationData as List).firstOrNull);
  } else if (relation['follower_id'] == req.data['user_id'] && relation['follower_status'] == false && relation['following_status'] == true) {
    Object relationData = await Database().orm.update(table: Tables.userRelation.value, where: {'id': relation['id']}, data: {'follower_status': true}, returning: true);
    return res.success(data: (relationData as List).firstOrNull);
  } else {
    throw Strings.somethingIsWrong;
  }
};

RequestHandler unfollowUser = (req, res) async {
  String followingId = req.body['userId'] ?? "";
  Map<String, dynamic>? relation = req.data['relation'];
  if (relation == null) throw Strings.somethingIsWrong;

  Map<String, dynamic> updateData = {};
  if (relation['follower_id'] == followingId) {
    updateData = {
      if (relation['follower_status'] == true) ...{'following_status': false}
    };
  } else {
    updateData = {
      if (relation['following_status'] == true) ...{'follower_status': false}
    };
  }
  if (updateData.isNotEmpty) {
    Object relationData = await Database().orm.update(table: Tables.userRelation.value, where: {'id': relation['id']}, data: updateData, returning: true);
    return res.success(data: (relationData as List).firstOrNull);
  } else {
    await Database().orm.delete(table: Tables.userRelation.value, where: {'id': relation['id']});
    return res.success();
  }
};

RequestHandler followers = (req, res) async {
  String userId = req.params['id'] ?? req.data['user_id'];
  String query = """SELECT u.id,u.username,u.first_name,u.last_name,u.avatar,ur.follower_id,ur.following_id,ur.follower_status,ur.following_status FROM user_relation AS ur
  LEFT JOIN users AS u ON((ur.follower_id='$userId' AND ur.following_id=u.id) OR (ur.following_id='$userId' AND ur.follower_id=u.id))
  WHERE ((ur.follower_id = '$userId' AND ur.following_status = 'true') OR (ur.following_id = '$userId' AND ur.follower_status = 'true'))""";
  Object data = await Database().orm.rawQuery(query);
  return res.success(data: data);
};

RequestHandler followings = (req, res) async {
  String userId = req.params['id'] ?? req.data['user_id'];
  String query = """SELECT u.id,u.username,u.first_name,u.last_name,u.avatar,ur.follower_id,ur.following_id,ur.follower_status,ur.following_status FROM user_relation AS ur
  LEFT JOIN users AS u ON((ur.follower_id='$userId' AND ur.following_id=u.id) OR (ur.following_id='$userId' AND ur.follower_id=u.id))
  WHERE ((ur.follower_id = '$userId' AND ur.follower_status = 'true') OR (ur.following_id = '$userId' AND ur.following_status = 'true'))""";
  Object data = await Database().orm.rawQuery(query);
  return res.success(data: data);
};
