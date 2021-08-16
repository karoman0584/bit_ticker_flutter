import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';
import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> data = {};
  bool isWaiting = false;
  CoinData _coinData = CoinData();

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void updateUI() async {
    isWaiting = true;
    try {
      var exchangeData = await _coinData.getExchangeRateData(selectedCurrency);
      isWaiting = false;
      setState(() {
        data = exchangeData;
      });
    } catch (e) {
      print(e);
    }
  }

  List<CryptoCard> getCryptoCards() {
    List<CryptoCard> cryptoCards = [];

    for (String crypto in cryptoList) {
      CryptoCard cryptoCard = CryptoCard(
        cryptoName: crypto,
        currencyQuantity: isWaiting ? '?' : data[crypto],
        currency: selectedCurrency,
      );
      cryptoCards.add(cryptoCard);
    }

    return cryptoCards;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> items = [];

    for (String currency in currenciesList) {
      DropdownMenuItem<String> item = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      items.add(item);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        selectedCurrency = value;
        updateUI();
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> items = [];

    for (String currency in currenciesList) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        updateUI();
      },
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: getCryptoCards(),
            ),
            Container(
              color: Colors.lightBlue,
              alignment: Alignment.center,
              height: 100.0,
              padding: EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            )
          ]),
    );
  }
}
