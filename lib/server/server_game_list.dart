import 'server_helpers.dart';
import 'server_game.dart';

class ServerGameList {
  Map<String, ServerGame> map;

  ServerGameList() : map = {};

  bool contains(String hash) {
    return map.containsKey(hash);
  }

  ServerGame? get(String hash) {
    return map[hash];
  }

  ServerGame newGame() {
    String dtn = dateTimeNowStr();
    int off = 0;
    String hash = generateHashCode(dtn, 4);
    while (map.containsKey(hash)) {
      off++;
      hash = generateHashCode(dtn, 4, off);
      print(hash);
    }

    String p1h = generateHashCode(dateTimeNowStr(), 4);

    ServerGame sg = ServerGame(hash: hash, user1: p1h, timeout: () {});

    map[hash] = sg;

    return sg;
  }
}
