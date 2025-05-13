import 'package:dinte_albastru/identifiable.dart';
import 'package:dinte_albastru/model/quote_model.dart';
import 'package:dinte_albastru/utils.dart';

class QuoteEntity implements Identifiable {
  final String text;
  final String author;
  @override
  int? id;

  QuoteEntity({this.id, required this.text, required this.author});

  QuoteEntity.fromJson(Map<String, dynamic> map)
      : text = map['q'] ?? Utils().emptyString,
        author = map['a'] ?? Utils().emptyString;

  Map<String, dynamic> toJson() {
    return {'q': text, 'a': author};
  }

  factory QuoteEntity.fromModel(QuoteModel model) {
    return QuoteEntity(text: model.text, author: model.author);
  }

  Map<String, dynamic> toMap() {
    return {'q': text, 'a': author};
  }

  factory QuoteEntity.fromMap(Map<String, dynamic> map) {
    return QuoteEntity(text: map['q'], author: map['a']);
  }
}
