import 'dart:convert';
import 'dart:io';

import 'package:connecttic/models/constants.dart';
import 'package:connecttic/server/server_defs.dart';
import 'package:connecttic/server/server_game.dart';
import 'package:connecttic/server/server_helpers.dart';

import '../models/game.dart';
import '../models/pos.dart';
import 'server_game_list.dart';

late ServerGameList gameList;

Future<void> main() async {
  gameList = ServerGameList();

  // Create a server that listens on localhost at port 8080
  var server = isRelease
      ? await HttpServer.bindSecure(
          ServerDefs.prodUrl, ServerDefs.prodPort, SecurityContext())
      : await HttpServer.bind(ServerDefs.devUrl, ServerDefs.devPort);
  print('Serving at http://${server.address.host}:${server.port}');

  // Listen for incoming requests
  await for (HttpRequest request in server) {
    // Handle the request
    handleRequest(request);
  }
}

// Function to handle incoming requests
Future<void> handleRequest(HttpRequest request) async {
  try {
    // SET CORS SO BROWSERS WILL WORK
    // Set CORS headers
    request.response.headers
        .add('Access-Control-Allow-Origin', '*'); // Allow all origins
    request.response.headers.add('Access-Control-Allow-Methods',
        'GET, POST, OPTIONS'); // Allowed methods
    request.response.headers
        .add('Access-Control-Allow-Headers', 'Content-Type'); // Allowed
    // Set the response content type
    request.response.headers.contentType = ContentType.json;

    // (CORS) Handle preflight request
    if (request.method == 'OPTIONS') {
      // Respond to preflight request
      request.response.statusCode = HttpStatus.noContent; // 204 No Content
      await request.response.close();
      return; // Exit the function after handling the OPTIONS request
    }

    // If the method is not a post, idk what it is, return error
    if (request.method != 'POST') {
      ReqError(HttpStatus.methodNotAllowed, '{"error": "Method not allowed"}');
    }

    // From now on, the method will be a POST
    String contentStr = await utf8.decoder.bind(request).join();
    Map content = {};

    // Catch invalid json
    try {
      content = jsonDecode(contentStr);
      if (!content.containsKey('req')) {
        throw Exception();
      }
    } catch (e) {
      ReqError(ServerDefs.codeAppErr, '{"error": "Invalid Json body"}');
    }

    int code = 500;
    String message = '';

    String req = content['req'];

    // Handle different requests
    switch (req) {
      // COFFEE
      case 'coffee':
        throw ReqError(418, 'I\'m a teapot');

      case 'list':
        String str = ':';
        for (String a in gameList.map.keys) {
          str += '$a:';
        }
        throw ReqError(200, str);

      // NEW
      case ServerDefs.reqNew:
        ServerGame sg = gameList.newGame();
        sg.gm.game.player1Name = "Connected"; // TODO
        code = ServerDefs.codeSucc;
        message = '{"hash": "${sg.hash}", "user": "${sg.user1}"}';
        break;

      // GET
      case ServerDefs.reqGet:
        if (!content.containsKey('hash')) {
          throw ReqError(ServerDefs.codeAppErr, 'missing hash');
        }

        String hash = content['hash'];

        if (!gameList.contains(hash)) {
          throw ReqError(ServerDefs.codeUsrErr, 'invalid game key');
        }

        ServerGame sg = gameList.get(hash)!;

        code = ServerDefs.codeSucc;
        Map<String, dynamic> messageObj = {
          'hash': hash,
          'game': sg.gm.game.toJson(),
          'tout': sg.secondsLeft,
        };
        message = jsonEncode(messageObj);

        break;

      // JOIN
      case ServerDefs.reqJoin:
        if (!content.containsKey('hash')) {
          throw ReqError(ServerDefs.codeAppErr, 'missing hash');
        }

        String hash = content['hash'];

        if (!gameList.contains(hash)) {
          throw ReqError(ServerDefs.codeUsrErr, 'invalid game key');
        }

        ServerGame sg = gameList.get(hash)!;

        if (sg.user2 != null) {
          throw ReqError(ServerDefs.codeUsrErr, 'game is full');
        }

        String p2Hash = generateHashCode(dateTimeNowStr(), 4);
        while (p2Hash == sg.user1) {
          p2Hash = generateHashCode(dateTimeNowStr(), 4);
        }

        sg.user2 = p2Hash;

        sg.resetTime();

        sg.gm.game.player2Name = "Connected"; // TODO
        code = ServerDefs.codeSucc;
        message = '{"hash": "$hash", "user": "$p2Hash"}';

        break;

      // PLAY
      case ServerDefs.reqPlay:
        if (!content.containsKey('hash')) {
          throw ReqError(ServerDefs.codeAppErr, 'missing hash');
        }

        String hash = content['hash'];

        if (!content.containsKey('user')) {
          throw ReqError(ServerDefs.codeAppErr, 'missing user');
        }

        String user = content['user'];

        if (!content.containsKey('pos')) {
          throw ReqError(ServerDefs.codeAppErr, 'missing position');
        }

        Pos pos = Pos.fromJson(content['pos']);

        if (!gameList.contains(hash)) {
          throw ReqError(ServerDefs.codeUsrErr, 'invalid game key');
        }

        ServerGame sg = gameList.get(hash)!;

        if (user != sg.user1 && user != sg.user2) {
          throw ReqError(
              ServerDefs.codeAppErr, '{"error": "user not in game"}');
        }

        if ((user == sg.user1 && sg.gm.currentPlayer == Game.p1) ||
            (user == sg.user2 && sg.gm.currentPlayer == Game.p2)) {
          gameList.get(hash)!.play(pos);
        }

        code = ServerDefs.codeSucc;
        Map<String, dynamic> messageObj = {
          "hash": hash,
          "game": sg.gm.game.toJson()
        };
        message = jsonEncode(messageObj);

        break;

      default:
        throw Object();
    }

    request.response.statusCode = code;
    request.response.write(message);
    request.response.close();
    return;
  } on ReqError catch (e) {
    request.response.statusCode = e.code;
    request.response.write('{"error": "${e.msg}"}');
    request.response.close();
    return;
  } catch (e) {
    request.response.statusCode = 500;
    request.response.write('{"error": "UNKNOWN: $e"}');
    request.response.close();
    return;
  }
}

class ReqError {
  int code;
  String msg;
  ReqError(this.code, this.msg);
}
