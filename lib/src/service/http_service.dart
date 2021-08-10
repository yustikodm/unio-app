import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> getService(String uri, {String token, onSuccess, onError}) async {
  try {
    dynamic url = Uri.parse(uri);

    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if (token != null) {
      headers.addAll({HttpHeaders.authorizationHeader: 'Bearer ' + token});
    }

    dynamic response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return onSuccess != null ? onSuccess(response) : print(response.body);
    } else {
      return onError != null ? onError(response) : print(response.body);
    }
  } on SocketException {
    throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
  }
}

Future<void> postService(String uri,
    {String token,
    Map<dynamic, dynamic> body,
    Function onSuccess,
    Function onError}) async {
  try {
    dynamic url = Uri.parse(uri);

    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if (token != null) {
      headers.addAll({HttpHeaders.authorizationHeader: 'Bearer ' + token});
    }

    dynamic response =
        await http.post(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      return onSuccess != null ? onSuccess(response) : print(response.body);
    } else {
      return onError != null ? onError(response) : print(response.body);
    }
  } on SocketException {
    throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
  }
}

Future<void> putService(String uri,
    {String token,
    Map<dynamic, dynamic> body,
    Function onSuccess,
    Function onError}) async {
  try {
    dynamic url = Uri.parse(uri);

    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if (token != null) {
      headers.addAll({HttpHeaders.authorizationHeader: 'Bearer ' + token});
    }

    dynamic response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      return onSuccess != null ? onSuccess(response) : print(response.body);
    } else {
      return onError != null ? onError(response) : print(response.body);
    }
  } on SocketException {
    throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
  }
}
