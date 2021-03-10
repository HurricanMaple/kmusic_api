part of '../module.dart';

/*
*歌曲信息
*/
Handler songInfo = (Map query, cookie) {
  final data = {
    "data": json.encode({
      "comm": {"ct": 24, "cv": 0},
      "songInfo": {
        "module": "music.pf_song_detail_svr",
        "method": "get_song_detail_yqq",
        "param": {
          "song_type": 0,
          "song_mid": "0039MnYb0qxYhV",
          "song_id": 97773,
        }
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  );
};

/*
* 歌曲信息
* 参数为歌曲Id，不是Mid
*/
Handler songLyric = (Map query, cookie) {
  final data = {
    "nobase64": 1,
    "format": 'json',
    "musicid": query['songid'],
  };
  return request(
    'GET',
    "https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_yqq.fcg",
    data,
    cookies: cookie,
  );
};

/*
* 歌曲信息
* 参数为歌曲Id，不是Mid
*/
Handler songLyricNew = (Map query, cookie) {
  final data = {
    "nobase64": 1, //是否base64显示
    "format": 'json',
    "musicid": query['songid'],
  };
  return request(
    'GET',
    "https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg",
    data,
    cookies: cookie,
  );
};

/*
 * 相关MV
 */
Handler songMv = (Map query, cookie) {
  final data = {
    "data": json.encode({
      "comm": {"ct": 24, "cv": 0},
      "mv": {
        "module": "MvService.MvInfoProServer",
        "method": "GetMvBySongid",
        "param": {
          "mids": ["${query['songmid']}"],
        }
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  );
};

/*
* 相关歌单
* 参数为歌曲Id，不是Mid
* */
Handler songPlayList = (Map query, cookie) {
  final data = {
    "data": json.encode({
      "comm": {"ct": 24, "cv": 0},
      "playList": {
        "module": "music.mb_gedan_recommend_svr",
        "method": "get_related_gedan",
        "param": {
          "song_id": query['songid'],
          "song_type": 1,
          "sin": 0,
          "last_id": 0,
        }
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  );
};
/*
* 歌曲评论，mv评论也是这个，pid不一样
* 参数为歌曲Id，不是Mid
* 分页从0开始
* */
Handler songComment = (Map query, cookie) {
  final data = {
    "biztype": 1,
    "topid": query['songid'],
    "cmd": 8,
    "pagenum": query['page'] ?? 0,
    "pagesize": 25,
    "lasthotcommentid": query['lasthotcommentid'] ?? '',
    "domain": 'qq.com',
  };
  return request(
    'GET',
    "https://c.y.qq.com/base/fcgi-bin/fcg_global_comment_h5.fcg",
    data,
    cookies: cookie,
  );
};

/*
 * 暂时只能获取非VIP的，req/freeflowsip+req_0/midurlinfo
 */
Handler songListen = (Map query, cookie) {
  final data = {
    "data": json.encode({
      "req": {
        "module": "CDN.SrfCdnDispatchServer",
        "method": "GetCdnDispatch",
        "param": {"guid": "3982823384"}
      },
      //普通音乐获取播放地址
      "req_0": {
        "method": "CgiGetVkey",
        "module": "vkey.GetVkeyServer",
        "param": {
          "guid": "3982823384",
          "songmid": ["002usg9o4GTAKf"],
          "songtype": [0],
          "uin": "0",
          "loginflag": 1,
          "platform": "20"
        }
      },
      //vip获取试听地址、普通加密音乐
      //RS02为收费音乐固定开头，格式MP3
      //O6M0为普通音乐固定开头，格式mgg，这个参数暂时有问题，可能没办法播放
      "queryvkey": {
        "method": "CgiGetEVkey",
        "module": "vkey.GetEVkeyServer",
        "param": {
          "guid": "3982823384",
          "filename": [
            //file下media_mid
            "RS02004I6V6C3OjmqV.mp3",
          ],
          "songmid": [
            "002usg9o4GTAKf",
          ],
          "songtype": [
            1,
          ],
          "uin": "0"
        }
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  ).then((value) {
    print(value.body['req']["data"]['freeflowsip'][0] + value.body['queryvkey']['data']["midurlinfo"][0]['purl'] + '&fromtag=77');
    print(value.body['req']["data"]['freeflowsip'][0] + value.body['req_0']['data']["midurlinfo"][0]['purl'] + '&fromtag=77');

    return value;
  });
};
