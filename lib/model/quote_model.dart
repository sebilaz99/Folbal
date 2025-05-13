import 'quote_entity.dart';

class QuoteModel {
  final String text;
  final String author;

  QuoteModel({required this.text, required this.author});

  factory QuoteModel.fromEntity(QuoteEntity entity) {
    return QuoteModel(author: entity.author, text: entity.text);
  }
}
