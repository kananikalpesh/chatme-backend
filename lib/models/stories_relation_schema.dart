part of '../config/database.dart';

Schema storyRelationSchema = Schema(table: Tables.storyRelation.value, fields: {
  "id": {
    "type": DataType.UUID(),
    "primaryKey": true,
    "default": "uuid_generate_v4()",
  },
  "storyId": {
    "type": DataType.UUID(),
    "allowNull": false,
  },
  "media_id": {
    "type": DataType.UUID(),
    "allowNull": false,
    'reference': {'table': Tables.medias.value, 'column': 'id'},
  },
});
