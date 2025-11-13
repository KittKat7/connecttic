import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:connecttic/server/server_defs.dart';

import 'player.dart';
import 'game.dart';
import 'pos.dart';

/// [GameType] the type of game, either local or remote
enum GameType { local, remote }

/// Handles game management locally. Also handles connecting to servers if
/// playing remotely. This is also a singleton class.
class GameManager {
  /// The instance of [GameManager]
  static GameManager? gm;

  /// Return the [GameManager] instance
  static GameManager get getGM {
    return gm!;
  }

  /// Sends a request to create a remote game
  static Future<Map> createRemoteGame(
      Function callbackSuccess, Function callbackError) async {
    GameManager.gm = GameManager(
      GameType.remote,
      player1: Player(level: PlayerLevel.player),
      player2: Player(level: PlayerLevel.player),
    );

    Map response = await postData(ServerDefs.reqNew, {});
    if (response.keys.contains('error') ||
        !response.keys.contains('status') ||
        response['status'] != 200) {
      callbackError();
    } else {
      getGM.player1.playerId = 'local';
      getGM.uHash = response['user'];
      getGM.gameId = response['hash'];
      getGM.hash = response['hash'];
      callbackSuccess();
      remoteUpdate();
    }
    return response;
  }

  /// Sends a request to create a remote game
  static Future<Map> joinRemoteGame(
      String hash, Function callbackSuccess, Function callbackError) async {
    GameManager.gm = GameManager(
      GameType.remote,
      player1: Player(level: PlayerLevel.player),
      player2: Player(level: PlayerLevel.player),
    );

    Map response = await postData(ServerDefs.reqJoin, {"hash": hash});
    if (response.keys.contains('error') ||
        !response.keys.contains('status') ||
        response['status'] != 200) {
      callbackError();
    } else {
      getGM.player2.playerId = response['user'];
      getGM.uHash = response['user'];
      getGM.gameId = response['hash'];
      getGM.hash = response['hash'];
      callbackSuccess();
      remoteUpdate();
    }
    return response;
  }

  // TODO add a remote update call
  static Future<void> remoteUpdate({bool repeat = true}) async {
    if (getGM.game.status == GameStatus.draw ||
        getGM.game.status == GameStatus.player1 ||
        getGM.game.status == GameStatus.player2) {
      return;
    }
    // If the game exists, and the status is playing or idle, init a 3 second
    // loop for getting
    if (gm != null &&
        (getGM.game.status == GameStatus.idle ||
            getGM.game.status == GameStatus.playing)) {
      Map response = await postData(ServerDefs.reqGet, {"hash": getGM.gameId});
      if (response.containsKey('error') ||
          !response.containsKey('status') ||
          response['status'] != 200) {
        // TODO error
        // TODO Add a error popup widget?
        print("ERROR");
        if (getGM.errorHandler != null) getGM.errorHandler!();
        return;
      } else {
        getGM.game = Game.fromJson(response['game']);
      }
    }
    getGM.callUpdateCallback();
    // Run the callback
    if (repeat) Timer(const Duration(seconds: 3), remoteUpdate);
  }

  Game game;
  GameType type;
  void Function()? updateCallback;
  int get width => game.board.length;
  int get height => game.board[0].length;
  int getItem(Pos pos) => game.board[pos.x][pos.y];
  int get currentPlayer => game.currentPlayer;
  GameStatus get status => game.status;
  Player player1;
  Player player2;
  String? gameId;
  Function? errorHandler;

  // Remote specific vars
  /// The hash for the remote game
  late String hash;

  /// The user hash for the remote game
  late String uHash;

  /// Constructor
  GameManager(this.type, {required this.player1, required this.player2})
      : game = Game() {
    // Local play
    if (type == GameType.local) {
      game.status = GameStatus.playing;
      if (player1.level != PlayerLevel.player) {
        player1.computerPlay(this);
      }
    }
    // Remote play
    else if (type == GameType.remote) {
      game.status = GameStatus.idle;
    }
  }

  bool play(Pos pos, {bool isCPU = false}) {
    bool played = false;

    if (game.status != GameStatus.playing) {
      return false;
    }

    // Local game
    if (type == GameType.local) {
      Player cPlayer = game.currentPlayer == Game.p1 ? player1 : player2;
      Player nPlayer = game.nextPlayer() == Game.p1 ? player1 : player2;

      // Return false if its a CPU turn and a player played
      if (cPlayer.level != PlayerLevel.player && !isCPU) {
        return false;
      }

      // Whether the play was successful
      played = game.play(pos);

      if (played && nPlayer.level != PlayerLevel.player) {
        Future.delayed(const Duration(seconds: 1), () {
          nPlayer.computerPlay(this);
        });
      }
    } else if (type == GameType.remote) {
      print(pos);
      postData(ServerDefs.reqPlay, {"hash": gameId, "user": uHash, "pos": pos})
          .then((f) => remoteUpdate(repeat: false));
    }

    if (played) {
      callUpdateCallback();
    }

    return played;
  }

  /// Calls the updateCallback function if its not null, and returns true.
  /// Else returns false.
  bool callUpdateCallback() {
    if (updateCallback != null) {
      updateCallback!();
      return true;
    }
    return false;
  }
}

/// Makes a post request to the server. Takes [req] the request and the content
/// [content] and returns a Future<Map> with the json data from the response.
Future<Map> postData(String req, Map content) async {
  // If the game is running in release mode, use the prod url, otherwise use
  // localhost
  // TODO FIX Platform.environment does not work on web
/*   final url = Platform.environment['FLUTTER_ENV'] == 'release'
      ? ''
      : 'http://localhost:8080'; */
  final url = 'http://localhost:8080';
  // final httpClient = HttpClient();

  /// The json response to return
  Map responseJson = {};

  try {
    // Run the request
    // final request = await httpClient.postUrl(Uri.parse(url));
    // request.headers.set();
    content['req'] = req;
    // request.write(jsonEncode(content));

    final response = await http.post(
      Uri.http('localhost:8080'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(content),
    );

    // Get the response
    // final response = await request.close();

    String responseBody = response.body;

    // Good response
    if (response.statusCode == 200) {
      // print('Response data: $responseBody');
    }
    // Not good response
    else {
      // print('Request failed with status: ${response.statusCode}.');
      // print('Response data: $responseBody');
    }
    // Build the response json
    responseJson = jsonDecode(responseBody) ?? {};
    responseJson['status'] = response.statusCode;
    // print(responseJson);
  } catch (e) {
    // If there is an error, print the error and return it
    print('Error: $e');
    responseJson = {'error': e};
  } // Return the responseJson
  return responseJson;
}
