import 'package:flutter/material.dart';
import 'package:dinte_albastru/data/repository.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/model/quote_entity.dart';
import 'package:dinte_albastru/model/quote_model.dart';
import 'package:dinte_albastru/navigator.dart';
import 'package:dinte_albastru/ui/screens/favorites_screen.dart';
import 'package:dinte_albastru/utils.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  QuoteModel quote =
      QuoteModel(text: Utils().emptyString, author: Utils().emptyString);
  Helper helper = Helper();
  late Future<dynamic> futureQuotes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Quotes Screen"),
          actions: [
            IconButton(
                onPressed: () {
                  navigateTo(const FavoritesScreen(), context);
                },
                icon: const Icon(Icons.list)),
            IconButton(
                onPressed: () {
                  refreshContent();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: FutureBuilder(
            future: futureQuotes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 100),
                        Text('Error! ${snapshot.error}')
                      ],
                    ),
                  ),
                );
              } else {
                QuoteModel newQuote = snapshot.data as QuoteModel;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    quote = newQuote;
                  });
                });
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(newQuote.text,
                        style: const TextStyle(
                            fontSize: 26, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center),
                    Text(
                      newQuote.author,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ]),
                ));
              }
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              QuoteEntity quoteEntity =
                  QuoteEntity(text: quote.text, author: quote.author);
              Map<String, String> quoteMap = {
                'a': quoteEntity.author,
                'q': quoteEntity.text
              };
              Helper().locator<Repository>().insertQuote(quoteMap).then((id) {
                final message = (id == 0)
                    ? 'An error occurred. The quote could not be added.'
                    : 'The quote of ${quoteEntity.author} was successfully added.';

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 4)));
              }).then((_) =>
                  navigateWithAnimation(const FavoritesScreen(), context));
            }));
  }

  void refreshContent() {
    setState(() {
      futureQuotes = Helper().locator<Repository>().getQuote();
    });
  }
}
