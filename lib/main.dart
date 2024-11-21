import 'package:chatme_backend/seeder/seeder.dart';
import 'package:chatme_backend/utils/response_handler.dart';

import 'config/database.dart';
import 'package:orm_plus/orm_plus.dart';
import 'routes/index.dart';

bool sync = false;

void run(List<String> args) async {
  try {
    Server server = Server();

    Database database = Database();
    await database.connect();
    if (sync) {
      await database.orm.rawQuery("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"");
      await database.orm.sync(syncTable: sync);
      await Seeder.seedData();
      print("Data seed complete");
    }

    server.get("/", (req, res) async {
      return res.write("Server are running fine.");
    });

    server.get("/test", (req, res) async {
      return res.success();
    });

    server.registerRouters(getAllRouters());

    server.onError((error, res) {
      res.error(message: error.toString());
    });

    server.listen(
      port: 9999,
      callback: () {
        print("Server are listening on port 9999");
      },
    );
  } catch (e) {
    print("Exception: $e");
  }
}
