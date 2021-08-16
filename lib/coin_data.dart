import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = 'C72DE8F0-3AC6-408F-A6D1-C2D30B9377CE';
const host = 'rest.coinapi.io';
const path = 'v1/exchangerate';

class CoinData {
  Future<Map> getExchangeRateData(String currency) async {
    Map<String, String> data = {};

    for (String crypto in cryptoList) {
      String fullPath = path + '/$crypto/$currency';
      Uri url = Uri.https(host, fullPath);
      http.Response response =
          await http.get(url, headers: {'X-CoinAPI-Key': apiKey});
      if (response.statusCode == 200) {
        String bodyData = response.body;
        var decodedBodyData = jsonDecode(bodyData);
        double rate = decodedBodyData['rate'];
        data[crypto] = rate.toStringAsFixed(0);
      } else {
        print('NETWORK ERROR: ${response.statusCode}');
        data[crypto] = '?';
      }
    }

    return data;
  }
}
