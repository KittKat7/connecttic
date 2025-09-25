import 'dart:convert';
import 'dart:io';

import 'package:connecttic/server/server_helpers.dart';

import '../models/game.dart';
import '../models/pos.dart';
import 'server_game.dart';
import 'server_game_list.dart';

late ServerGameList gameList;

Future<void> main() async {
  gameList = ServerGameList();

  // Create a server that listens on localhost at port 8080
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
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
    // Set the response content type
    request.response.headers.contentType = ContentType.json;

    if (request.method != 'POST') {
      ReqError(HttpStatus.methodNotAllowed, '{"error": "Method not allowed"}');
    }

    String contentStr = await utf8.decoder.bind(request).join();
    Map content = {};

    // Catch invalid json
    try {
      content = jsonDecode(contentStr);
      if (!content.containsKey('req')) {
        throw Exception();
      }
    } catch (e) {
      ReqError(HttpStatus.badRequest, '{"error": "Invalid Json body"}');
    }

    int code = 500;
    String message = '';

    String req = content['req'];

    // Handle different requests
    switch (req) {
      // COFFEE
      case 'coffee':
        throw ReqError(418, 'I\'m a teapot');

      // CREATE
      case 'create':
        ServerGame sg = gameList.newGame();
        code = HttpStatus.ok;
        message = '{"hash": "${sg.hash}", "user": "${sg.user1}"}';
        break;

      // JOIN
      case 'join':
        if (!content.containsKey('hash')) {
          throw ReqError(HttpStatus.badRequest, 'missing game');
        }

        String hash = content['hash'];

        if (!gameList.contains(hash)) {
          throw ReqError(HttpStatus.badRequest, 'invalid game key');
        }

        ServerGame sg = gameList.get(hash)!;

        if (sg.user2 != null) {
          throw ReqError(HttpStatus.badRequest, 'game is full');
        }

        String p2Hash = generateHashCode(dateTimeNowStr(), 4);
        while (p2Hash == sg.user1) {
          p2Hash = generateHashCode(dateTimeNowStr(), 4);
        }

        sg.user2 = p2Hash;

        code = HttpStatus.ok;
        message = '{"user": "$p2Hash"}';

        break;

      // GET UPDATE
      case 'play':
        if (!content.containsKey('hash')) {
          throw ReqError(HttpStatus.badRequest, 'missing game');
        }

        String hash = content['hash'];

        if (!content.containsKey('user')) {
          throw ReqError(HttpStatus.badRequest, 'missing user');
        }

        String user = content['user'];

        if (!content.containsKey('pos')) {
          throw ReqError(HttpStatus.badRequest, 'missing position');
        }

        Pos pos = Pos.fromJson(content['pos']);

        if (!gameList.contains(hash)) {
          throw ReqError(HttpStatus.badGateway, 'invalid game key');
        }

        ServerGame sg = gameList.get(hash)!;

        if (user != sg.user1 && user != sg.user2) {
          throw ReqError(
              HttpStatus.badRequest, '{"error": "user not in game"}');
        }

        if ((user == sg.user1 && sg.gm.currentPlayer != Game.p1) ||
            (user == sg.user2 && sg.gm.currentPlayer != Game.p2)) {
          throw ReqError(HttpStatus.unauthorized, 'not your turn');
        }

        gameList.get(hash)!.gm.play(pos);

        code = 200;
        message = '{"hash": $hash, "game": ${sg.gm.game.toJson()}}';

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
