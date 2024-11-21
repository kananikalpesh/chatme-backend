part of '../config/database.dart';

Schema userRelationSchema = Schema(
  table: Tables.userRelation.value,
  fields: {
    "id": {
      "type": DataType.UUID(),
      "primaryKey": true,
      "default": "uuid_generate_v4()",
    },
    "follower_id": {
      "type": DataType.UUID(),
      "allowNull": false,
      'reference': {'table': Tables.users.value, 'column': 'id'},
    },
    "following_id": {
      "type": DataType.UUID(),
      "allowNull": false,
      'reference': {'table': Tables.users.value, 'column': 'id'},
    },
    "follower_status": {
      "type": DataType.BOOLEAN(),
      "allowNull": false,
      "default": true,
    },
    "following_status": {
      "type": DataType.BOOLEAN(),
      "allowNull": false,
      "default": false,
    },
  },
);
