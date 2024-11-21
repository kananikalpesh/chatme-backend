part of '../routes/auth_routes.dart';

//
/// User Register
//

RequestHandler registerValidate = (req, res) async {
  String username = req.body['username'] ?? "";
  String email = req.body['email'] ?? "";
  String password = req.body['password'] ?? "";

  if (username.trim().isEmpty) {
    return res.validationError(message: "Username is required");
  }
  if (email.trim().isEmpty) {
    return res.validationError(message: "Email is required");
  }
  if (!emailRegex.hasMatch(email)) {
    return res.validationError(message: "Invalid email address");
  }
  if (password.trim().isEmpty) {
    return res.validationError(message: "Password is required");
  }
  if (!passwordRegex.hasMatch(password)) {
    return res.validationError(message: "Password must be at least 6 characters long, contain at least one letter, and one number");
  }
  Map? user = await Database().orm.findOne(table: Tables.users.value, where: {
    Op.or: {
      "username": username,
      "email": email,
    }
  });

  if (user != null) {
    if (username == user['username']) throw "Username already in use";
    if (email == user['email']) throw "Email already in use";
  }

  return req.next(res);
};

RequestHandler registerUser = (req, res) async {
  String pass = BCrypt.hashpw(req.body['password'], BCrypt.gensalt());
  var datas = await Database().orm.insert(
        table: Tables.users.value,
        data: {
          "username": req.body['username']!,
          "email": req.body['email']!,
          "password": pass,
        },
        returning: true,
      );
  if ((datas as List).isEmpty) throw Strings.somethingIsWrong;
  req.data['user'] = datas.first;
  return await req.next(res);
};

RequestHandler registerUserOtpSent = (req, res) async {
  String otp = OtpGenerator.generateOTP();
  var datas = await Database().orm.insert(
    table: Tables.opt.value,
    returning: true,
    data: {
      "userId": req.data['user']['id'],
      "otp": otp,
      "expiresAt": DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
    },
  );

  if ((datas as List).isEmpty) throw Strings.somethingIsWrong;

  String token = JwtHandler().generateOTPToken(id: datas.first['id']);
  return res.success(message: "User register successfully!", data: {
    "otp_token": token,
  });
};

//
/// User Login
//

RequestHandler loginValidate = (req, res) async {
  // final {'email': String email, 'password': String password} = req.body;

  String email = req.body['email'] ?? "";
  String password = req.body['password'] ?? "";

  if (email.trim().isEmpty) {
    return res.validationError(message: "Email is required");
  }
  if (!emailRegex.hasMatch(email)) {
    return res.validationError(message: "Invalid email address");
  }
  if (password.trim().isEmpty) {
    return res.validationError(message: "Password is required");
  }
  if (!passwordRegex.hasMatch(password)) {
    return res.validationError(
      message: "Password must be at least 6 characters long, contain at least one letter, and one number",
    );
  }

  Map? user = await Database().orm.findOne(
    table: Tables.users.value,
    where: {"email": email},
  );

  if (user == null) throw "Email or Password are not match";

  bool match = BCrypt.checkpw(req.body['password'], user['password']);
  if (!match) throw "Email or Password are not match";
  req.data.addAll(user);
  return await req.next(res);
};

RequestHandler loginUser = (req, res) async {
  Database db = Database();

  if (req.data['verify'] ?? false) {
    String token = JwtHandler().generateToken(id: req.data['id']);
    return res.success(message: "Login successfully!", data: {
      "userId": req.data['id'],
      "token": token,
      "verify": true,
    });
  }
  String otp = OtpGenerator.generateOTP();
  await db.orm.transactions.start();
  await db.orm.delete(
    table: Tables.opt.value,
    where: {"userId": req.data['id']},
  );
  var datas = await db.orm.insert(
    table: Tables.opt.value,
    returning: true,
    data: {
      "userId": req.data['id'],
      "otp": otp,
      "expiresAt": DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
    },
  );
  await db.orm.transactions.commit();

  if ((datas as List).isEmpty) throw Strings.somethingIsWrong;

  String token = JwtHandler().generateOTPToken(id: datas.first['id']);
  return res.success(message: "OTP sent successfully!", data: {
    "otp_token": token,
    "verify": false,
  });
};

//
/// Forgot password
//

RequestHandler forgotPassword = (req, res) async {
  Database db = Database();

  String email = req.body['email'] ?? "";
  if (email.trim().isEmpty) {
    return res.validationError(message: "Email is required");
  }
  if (!emailRegex.hasMatch(email)) {
    return res.validationError(message: "Invalid email address");
  }

  Map? user = await db.orm.findOne(
    table: Tables.users.value,
    where: {"email": email},
  );

  if (user == null) throw "User does not exist";

  String otp = OtpGenerator.generateOTP();
  await db.orm.transactions.start();
  await db.orm.delete(
    table: Tables.opt.value,
    where: {"userId": user['id']},
  );
  var datas = await db.orm.insert(
    table: Tables.opt.value,
    returning: true,
    data: {
      "userId": user['id'],
      "otp": otp,
      "expiresAt": DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
    },
  );

  await db.orm.transactions.commit();

  if ((datas as List).isEmpty) throw Strings.somethingIsWrong;

  String token = JwtHandler().generateOTPToken(id: datas.first['id'], isForgotPassword: true);
  return res.success(message: "OTP sent successfully!", data: {"otp_token": token});
};

//
/// OTP verify
//

RequestHandler otpVerify = (req, res) async {
  Database db = Database();
  try {
    String otp = req.body['otp'] ?? "";
    String token = req.body['otp_token'] ?? "";
    if (otp.trim().isEmpty || otp.trim().length != 6) {
      return res.validationError(message: "Invalid OTP");
    }
    if (token.trim().isEmpty) {
      return res.validationError(message: "OTP Token is required");
    }
    (String?, bool) tokenData = JwtHandler().getOTPTokenData(token);
    String tokenId = tokenData.$1 ?? "";
    if (tokenId.isEmpty) throw "Invalid OTP Token";

    Map? otpData = await db.orm.findOne(
      table: Tables.opt.value,
      where: {"id": tokenId},
    );

    if (otpData == null) throw "Invalid OTP or it may have expired";

    DateTime? expireTime = otpData['expiresAt'];
    if (expireTime == null || DateTime.now().toUtc().isAfter(expireTime)) {
      throw "Invalid OTP or it may have expired";
    }
    String userId = otpData['userId'];
    await db.orm.transactions.start();
    await db.orm.delete(
      table: Tables.opt.value,
      where: {"userId": userId},
    );
    if (!tokenData.$2) {
      await db.orm.update(
        table: Tables.users.value,
        data: {'verify': true},
        where: {'id': userId, 'verify': false},
      );
    }
    db.orm.transactions.commit();
    String t = tokenData.$2 ? JwtHandler().generateForgotPasswordToken(userid: userId) : JwtHandler().generateToken(id: userId);
    return res.success(message: "OTP verify successfully!", data: {
      if (!tokenData.$2) ...{"userId": userId},
      "token": t,
    });
  } catch (e) {
    db.orm.transactions.rollback();
    rethrow;
  }
};

//
/// Reset Password
//

RequestHandler resetPassword = (req, res) async {
  Database db = Database();

  String password = req.body['password'] ?? "";
  String token = req.body['token'] ?? "";

  if (password.trim().isEmpty) {
    return res.validationError(message: "Password is required");
  }
  if (!passwordRegex.hasMatch(password)) {
    return res.validationError(
      message: "Password must be at least 6 characters long, contain at least one letter, and one number",
    );
  }

  String userId = JwtHandler().getForgotPasswordTokenData(token) ?? "";
  if (userId.isEmpty) throw "Invalid OTP Token";

  String pass = BCrypt.hashpw(req.body['password'], BCrypt.gensalt());

  var datas = await db.orm.update(
    table: Tables.users.value,
    returning: true,
    data: {'password': pass},
    where: {'id': userId},
  );

  if ((datas as List).isEmpty) throw Strings.somethingIsWrong;

  return res.success(message: "Password reset has been successfully");
};
