part of '../config/database.dart';

Schema storySchema = Schema(
  table: Tables.stories.value,
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
    "media": {
      "type": DataType.UUID(),
      "allowNull": false,
      'reference': {'table': Tables.storyRelation.value, 'column': 'id'},
    },
    "created_at": {
      "type": DataType.TIMESTAMP(true),
      "default": "CURRENT_TIMESTAMP",
      "allowNull": false,
    }
  },
);
