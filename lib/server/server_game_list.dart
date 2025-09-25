import 'server_helpers.dart';
import 'server_game.dart';

class ServerGameList {
  /// A map of all the active games
  Map<String, ServerGame> map;

  ServerGameList() : map = {};

  /// Returns true if a game of [hash] is in the map
  bool contains(String hash) {
    return map.containsKey(hash);
  }

  /// Gets the game [hash]
  ServerGame? get(String hash) {
    return map[hash];
  }

  /// Creates and returns a new server game
  ServerGame newGame() {
    // Set temp variables
    String dtn = dateTimeNowStr();
    int off = 0;
    // Generate the hash
    String hash = generateHashCode(dtn, 4);
    // As long as the hash already exists, keep creating new ones
    while (map.containsKey(hash)) {
      off++;
      hash = generateHashCode(dtn, 4, off);
    }

    // Create the user1 hash
    String u1h = generateHashCode(dateTimeNowStr(), 4);

    // Create the [ServerGame] and add it to the map
    ServerGame sg = ServerGame(
        hash: hash, user1: u1h, timeoutCallback: () => deleteGame(hash));
    map[hash] = sg;

    return sg;
  }

  /// Deletes the game with [hash] from the list
  void deleteGame(String hash) {
    map.remove(hash);
  }
}
