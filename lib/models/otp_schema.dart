part of '../config/database.dart';

Schema otpSchema = Schema(
  table: Tables.opt.value,
  fields: {
    "id": {
      "type": DataType.UUID(),
      "primaryKey": true,
      "default": "uuid_generate_v4()",
    },
    "userId": {
      "type": DataType.UUID(),
      "allowNull": false,
      'reference': {'table': Tables.users.value, 'column': 'id'},
    },
    "otp": {
      "type": DataType.STRING(6),
      "allowNull": false,
    },
    "expiresAt": {
      "type": DataType.TIMESTAMP(true),
      "allowNull": false,
    }
  },
);
