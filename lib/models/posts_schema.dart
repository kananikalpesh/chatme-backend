part of '../config/database.dart';

Schema postsSchema = Schema(
  table: Tables.posts.value,
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
    "content": DataType.TEXT(),
    "media": {
      "type": DataType.UUID(),
      "allowNull": false,
      'reference': {'table': Tables.postRelation.value, 'column': 'id'},
    },
    "created_at": {
      "type": DataType.TIMESTAMP(true),
      "default": "CURRENT_TIMESTAMP",
      "allowNull": false,
    },
    "updated_at": {
      "type": DataType.TIMESTAMP(true),
      "default": "CURRENT_TIMESTAMP",
      "allowNull": false,
    }
  },
);
