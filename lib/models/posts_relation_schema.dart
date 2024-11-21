part of '../config/database.dart';

Schema postRelationSchema = Schema(table: Tables.postRelation.value, fields: {
  "id": {
    "type": DataType.UUID(),
    "primaryKey": true,
    "default": "uuid_generate_v4()",
  },
  "postId": {
    "type": DataType.UUID(),
    "allowNull": false,
  },
  "media_id": {
    "type": DataType.UUID(),
    "allowNull": false,
    'reference': {'table': Tables.medias.value, 'column': 'id'},
  },
});
