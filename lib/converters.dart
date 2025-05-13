import 'package:dinte_albastru/model/quote_model.dart';

class Converters {
  T genericFromJson<T>(Map<String, dynamic> map,T Function(Map<String, dynamic>) factory) {
    return factory(map);
  } 

  QuoteModel fromJson(Map<String, dynamic> map) {
    return QuoteModel(text: map['q'], author: map['a']);
  }

  double kmhToMps(double kmh) {
    return kmh * (1000 / 3600);
  }
}
