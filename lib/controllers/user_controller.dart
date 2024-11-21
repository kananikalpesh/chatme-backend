part of '../routes/user_routes.dart';

RequestHandler updateUser = (req, res) async {
  String username = req.body['username'] ?? "";
  String firstName = req.body['first_name'] ?? "";
  String lastName = req.body['last_name'] ?? "";
  String gender = req.body['gender'] ?? "";
  String dob = req.body['date_of_birth'] ?? "";
  String avatar = req.body['avatar'] ?? "";

  if (username.isNotEmpty) {
    Map? user = await Database().orm.findOne(table: Tables.users.value, where: {"username": username});
    if (user != null) throw "Username already in use";
  }

  Map<String, dynamic> userData = {
    if (username.isNotEmpty) ...{
      "username": username,
    },
    if (firstName.isNotEmpty) ...{
      "first_name": firstName,
    },
    if (lastName.isNotEmpty) ...{
      "last_name": lastName,
    },
    if (gender.isNotEmpty) ...{
      "gender": gender,
    },
    if (dob.isNotEmpty) ...{
      "date_of_birth": dob,
    },
    if (avatar.isNotEmpty) ...{
      "avatar": avatar,
    }
  };

  if (userData.isEmpty) throw "Body cannot be empty";

  var r = await Database().orm.update(table: Tables.users.value, data: userData, where: {'id': req.data['user_id']});
  if (r == 0) throw Strings.somethingIsWrong;

  return res.success(message: "Data updated successfully");
};

RequestHandler userDetails = (req, res) async {
  Map<String, dynamic>? userData = await Database().orm.findOne(
    table: Tables.users.value,
    fields: ['id', 'username', 'email', 'first_name', 'last_name', 'gender', 'date_of_birth', 'avatar', 'bio'],
    where: {'id': req.data['user_id']},
  );

  if (userData == null) throw Strings.somethingIsWrong;

  return res.success(data: userData);
};

RequestHandler changePassword = (req, res) async {
  String oldPassword = req.body['old_password'] ?? "";
  String newPassword = req.body['new_password'] ?? "";

  if (oldPassword.trim().isEmpty) {
    return res.validationError(message: "Old password is required");
  }
  if (newPassword.trim().isEmpty) {
    return res.validationError(message: "New password is required");
  }
  if (!passwordRegex.hasMatch(newPassword)) {
    return res.validationError(
      message: "Password must be at least 6 characters long, contain at least one letter, and one number",
    );
  }

  Map? user = await Database().orm.findOne(
    table: Tables.users.value,
    where: {"id": req.data['user_id']},
  );

  if (user == null) throw Strings.somethingIsWrong;

  bool match = BCrypt.checkpw(oldPassword, user['password']);
  if (!match) throw "Invalid old password";

  String pass = BCrypt.hashpw(req.body['password'], BCrypt.gensalt());

  var r = await Database().orm.update(table: Tables.users.value, data: {'password': pass}, where: {"id": req.data['user_id']});

  if (r == 0) throw Strings.somethingIsWrong;

  return res.success(message: "Password updated successfully");
};

RequestHandler allUsers = (req, res) async {
  Map<String, Object?> result = await Database().orm.findAncCountAll(table: Tables.users.value);
  return res.success(data: result);
};

RequestHandler userProfile = (req, res) async {
  ORM orm = Database().orm;
  String userId = req.params['id'] ?? req.data['user_id'];
  Map<String, dynamic>? userData = await orm.findOne(
    table: Tables.users.value,
    fields: ['id', 'username', 'email', 'first_name', 'last_name', 'gender', 'date_of_birth', 'avatar', 'bio'],
    where: {'id': userId},
  );

  if (userData == null) throw "User not found";

  List<dynamic> followData = await Future.wait([
    orm.count(table: Tables.userRelation.value, where: {
      Op.or: [
        {'follower_id': userId, 'following_status': true},
        {'following_id': userId, 'follower_status': true},
      ]
    }),
    orm.count(table: Tables.userRelation.value, where: {
      Op.or: [
        {'follower_id': userId, 'follower_status': true},
        {'following_id': userId, 'following_status': true},
      ]
    }),
    if (req.params['id'] != null) ...[
      orm.findOne(
        table: Tables.userRelation.value,
        fields: ['follower_id', 'following_id', 'follower_status', 'following_status'],
        where: {
          Op.or: [
            {'follower_id': req.data['user_id'], 'following_id': req.params['id']},
            {'following_id': req.data['user_id'], 'follower_id': req.params['id']},
          ]
        },
      ),
    ],
  ]);

  userData['followers'] = followData[0];
  userData['followings'] = followData[1];
  userData['follow'] = req.params['id'] != null ? followData[2] : null;

  return res.success(data: userData);
};

RequestHandler findUsers = (req, res) async {
  return res.success();
};
