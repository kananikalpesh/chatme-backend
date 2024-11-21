part of '../config/database.dart';

Schema userSchema = Schema(
  table: Tables.users.value,
  fields: {
    "id": {
      "type": DataType.UUID(),
      "primaryKey": true,
      "default": "uuid_generate_v4()",
    },
    "username": {
      "type": DataType.STRING(50),
      "unique": true,
      "allowNull": false,
    },
    "first_name": DataType.STRING(50),
    "last_name": DataType.STRING(50),
    "gender": DataType.STRING(10),
    "date_of_birth": DataType.TIMESTAMP(),
    "avatar": DataType.TEXT(),
    "bio": DataType.TEXT(),
    "email": {
      "type": DataType.STRING(100),
      "unique": true,
      "allowNull": false,
    },
    "password": {
      "type": DataType.TEXT(),
      "allowNull": false,
    },
    "verify": {
      "type": DataType.BOOLEAN(),
      "default": "FALSE",
      "allowNull": false,
    },
    "created_at": {
      "type": DataType.TIMESTAMP(true),
      "default": "CURRENT_TIMESTAMP",
      "allowNull": false,
    }
  },
);
