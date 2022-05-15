import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  static const DEFAULT_TIMEOUT = Duration(seconds: 15);

  NetworkUtil.internal();

  factory NetworkUtil() {
    return _instance;
  }

  factory NetworkUtil.withClient(http.Client client) {
    _instance._client = client;
    return _instance;
  }
  final _decoder = const JsonDecoder();
  var _client = http.Client();
  final _initialHeaders = {
    HttpHeaders.contentTypeHeader: "application/json",
    "Access-Control-Allow-Origin": "*",
  };

  Future<dynamic> get(String url,
      {Map<String, String>? headers, timeout = DEFAULT_TIMEOUT}) async {
    return await _makeHttpCall(
        (Map<String, String> actualHeaders) => _client
            .get(Uri.tryParse(url)!, headers: actualHeaders)
            .timeout(timeout),
        headers);
  }

  Future<dynamic> post(String url,
      {Map<String, String>? headers,
      body,
      encoding,
      bool isAuthRequest = false,
      timeout = DEFAULT_TIMEOUT}) async {
    return await _makeHttpCall(
        (Map<String, String> actualHeaders) => _client
            .post(Uri.tryParse(url)!,
                body: body, headers: actualHeaders, encoding: encoding)
            .timeout(timeout),
        headers);
  }

  Future<dynamic> put(String url,
      {Map<String, String>? headers,
        body,
        encoding,
        bool isAuthRequest = false,
        timeout = DEFAULT_TIMEOUT}) async {
    return await _makeHttpCall(
            (Map<String, String> actualHeaders) =>
            _client.put(Uri.tryParse(url)!, body: body, headers: actualHeaders, encoding: encoding).timeout(timeout),
        headers);
  }

  Future<dynamic> _makeHttpCall(
      Future<http.Response> Function(Map<String, String> actualHeaders)
          httpCall,
      Map<String, String>? requestHeaders) async {
    return _handleResponse(
        await httpCall(await _prepareHeaders(requestHeaders)));
  }

  /// Стандартная обработка http-запросов
  dynamic _handleResponse(http.Response response) {
    final String res = utf8.decode(response.bodyBytes);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400) {
      throw Exception("Ошибка $statusCode\n${utf8.decode(response.bodyBytes)}");
    }
    if (res.isEmpty) {
      return;
    }
    return _decoder.convert(res);
  }

  Future<Map<String, String>> _prepareHeaders(
      Map<String, String>? headers) async {
    final Map<String, String> resultHeaders = {};
    resultHeaders.addAll(_initialHeaders);
    if (headers != null) {
      resultHeaders.addAll(headers);
    }
    return resultHeaders;
  }
}
