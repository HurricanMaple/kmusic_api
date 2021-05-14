import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:kmusic_api/migu_music.dart';
import 'package:kmusic_api/utils/answer.dart';

class MiGuRepository {
  static const int _NEED_LOGIN = 301;
  static const int _SUCCESS = 0;
  Completer<PersistCookieJar> _cookieJar = Completer();

  MiGuRepository() {
    scheduleMicrotask(() async {
      PersistCookieJar cookieJar = PersistCookieJar();
      _cookieJar.complete(cookieJar);
    });
  }

  Future<List<Cookie>> _loadCookies() async {
    var jar = await _cookieJar.future;
    if (jar == null) {
      return [];
    }
    final uri = Uri.parse('https://m.music.migu.cn');
    return jar.loadForRequest(uri);
  }

  _saveCookies(List<Cookie> cookies) async {
    var jar = await _cookieJar.future;
    if (jar == null) {
      return;
    }
    final uri = Uri.parse('https://m.music.migu.cn');
    jar.saveFromResponse(uri, cookies);
  }

  Future<dynamic> _doRequest(String path, {Map<String, dynamic> params}) async {
    List<Cookie> cookies = await _loadCookies();
    Answer answer;
    try {
      answer = await miguApi(path, parameter: params, cookie: cookies);
    } catch (e, stacktrace) {
      Future.error('request error:$e', stacktrace);
    }

    if (answer.status == HttpStatus.ok) {
      _saveCookies(answer.cookie);
    }

    final map = answer.body;
    if (map == null) {
      return Future.error('请求失败了');
    }
    /*else if (map['errmsg'].toString().contains('请登陆')) {
      return Future.error('需要登陆才能访问哦~');
    } else if (map['data'] != null) {
      return Future.error(map['errmsg'] ?? '请求失败了~');
    }*/
    return Future.value(map);
  }

  Future<dynamic> album() {
    return _doRequest('/album', params: {});
  }

  Future<dynamic> playListHotTag() {
    return _doRequest('/playList/hotTag', params: {});
  }

  Future<dynamic> playListRec() {
    return _doRequest('/playList/rec', params: {});
  }

  Future<dynamic> playListPlayNum() {
    return _doRequest('/playList/playNum', params: {
      'contentIds': ["196764163", "193392029"],
      'contentType': ["2021", "2021"],
    });
  }

  Future<dynamic> playList() {
    return _doRequest('/playList', params: {
      'page': '1',
      'tagId': '1003449727',
    });
  }

  Future<dynamic> playListTagList() {
    return _doRequest('/playList/tagList', params: {});
  }

  Future<dynamic> playListInfo() {
    return _doRequest('/playList/info', params: {
      'id': '181694965',
      'type': '2021',
    });
  }

  Future<dynamic> playListSong() {
    return _doRequest('/playList/song', params: {
      'id': '181694965',
    });
  }

  Future<dynamic> playUrl() {
    return _doRequest('/song/url', params: {
      // 'albumId': '1002508351',
      'songId': '1002508489',
      'toneFlag': 'PQ',
    });
  }
}
