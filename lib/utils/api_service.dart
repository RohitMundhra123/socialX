import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiCall {
  String? stringresponse;
  Map? mapresponse;
  List listresponse = [];

  Future api() async {
    http.Response response;
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2023-09-05&to=2023-09-05&sortBy=popularity&apiKey=f4c2eaee83474cc5b7b28d629f608af2";
    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      stringresponse = response.body;
      mapresponse = json.decode(response.body);
      listresponse = mapresponse!["articles"];
      return listresponse;
    } else {
      throw Exception("Error to find news");
    }
  }
}
