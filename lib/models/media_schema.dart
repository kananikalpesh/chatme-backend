part of '../config/database.dart';

Schema mediaSchema = Schema(
  table: Tables.medias.value,
  fields: {
    "id": {
      "type": DataType.UUID(),
      "primaryKey": true,
      "default": "uuid_generate_v4()",
    },
    "media_type": {
      "type": DataType.STRING(10),
      "allowNull": false,
    },
    "media": {
      "type": DataType.STRING(),
      "allowNull": false,
    }
  },
);
