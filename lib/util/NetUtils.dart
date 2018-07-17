import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NetUtils{
  static const String GET = "get";
  static const String POST = "post";

  static void get(String url,Function callback,{Map<String,String> params,Map<String, String> headers,Function errorCallback}) async{

    if(params != null && params.isNotEmpty){
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key,value){
        sb.write("$key=$value+&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0,paramStr.length -1);
      url += paramStr;
    }
  await _request(url, callback,method: GET,headers: headers,params: params,errorCallback: errorCallback);
  }
  static void post(String url, Function callback ,{Map<String,String> params,Map<String, String> headers,Function errorCallback}) async{
   await _request(url, callback,method: POST,headers: headers,params: params,errorCallback:  errorCallback);
  }

  /**
   * 统一处理
   */
  static Future _request(String url,Function callback,
      {String method,Map<String,String> headers,Map<String,String> params,Function errorCallback}) async{
    try{
      Map<String,String> headerMap;
      Map<String,String> paramMap;
      if(headers == null){
        headerMap= new Map();
      }else{
        headerMap = headers;
      }
      if(params == null){
        paramMap= new Map();
      }else{
        paramMap = params;
      }
      //统一添加cookie
      SharedPreferences sp = await SharedPreferences.getInstance();
      String cookie = sp.get("cookie");
      if(cookie != null && cookie.length > 0){
        headerMap['cookie'] = cookie;
      }
      http.Response response;
      if(POST == method){
        print("POST:URL= $url");
        print("POST:BODY= ${paramMap.toString()}");
        response = await http.post(url,headers: headerMap,body: paramMap);
      }else if(GET == method){
        print("GET:URL=" +url);
        response = await http.get(url,headers: headerMap);
      }
      if(response.statusCode != 200) {
        errorCallback("网络请求错误，状态码:${response.statusCode}");
        return;
      }else{
        if(callback != null){
          callback(response.body);
        }
      }
      //保存cookie
      sp.setString("cookie", response.headers['set-cookie']);
      print("Set-cookie=${response.headers['set-coookie']}");

    }catch(exception){
      if(errorCallback != null){
        errorCallback(errorCallback);
      }
    }
  }
}