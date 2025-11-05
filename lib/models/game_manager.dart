import 'dart:convert';
import 'dart:io';

import 'package:connecttic/server/server_defs.dart';
// import 'package:flutter/foundation.dart';

import 'player.dart';
import 'game.dart';
import 'pos.dart';

enum GameType { local, remote }

class GameManager {
  static GameManager? gm;

  static GameManager getGM() {
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
      GameManager.getGM().player1.playerId = response['user'];
      callbackSuccess();
    }
    return response;
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
  final url = Platform.environment['FLUTTER_ENV'] == 'release'
      ? ''
      : 'http://localhost:8080';
  final httpClient = HttpClient();

  /// The json response to return
  Map responseJson = {};

  try {
    // Run the request
    final request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    content['req'] = req;
    request.write(jsonEncode(content));

    // Get the response
    final response = await request.close();

    String responseBody = await response.transform(utf8.decoder).join();
    ;

    // Good response
    if (response.statusCode == 200) {
      print('Response data: $responseBody');
    }
    // Not good response
    else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response data: $responseBody');
    }
    // Build the response json
    responseJson = jsonDecode(responseBody) ?? {};
    responseJson['status'] = response.statusCode;
    print(responseJson);
  } catch (e) {
    // If there is an error, print the error and return it
    print('Error: $e');
    responseJson = {'error': e};
  } finally {
    httpClient.close();
  }
  // Return the responseJson
  return responseJson;
}
