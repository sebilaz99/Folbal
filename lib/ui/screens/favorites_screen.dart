import 'package:flutter/material.dart';
import 'package:dinte_albastru/data/repository.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/model/quote_entity.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Repository repository = Repository();
  final searchController = TextEditingController();
  List<QuoteEntity> quotes = List.empty();
  List<QuoteEntity> quotesFromDb = List.empty();

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  Future<void> fetchAll() async {
    quotesFromDb = await Helper().locator<Repository>().getQuotes();
    setState(() {
      quotes = List.from(quotesFromDb);
    });
  }

  Future<void> searchInDb(String query) async {
    setState(() {
      quotes = query.isEmpty
          ? List.of(quotesFromDb)
          : quotesFromDb
              .where((quote) =>
                  quote.text.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Favourite quotes')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SearchBar(
              controller: searchController,
              hintText: "Search quote",
              onChanged: searchInDb,
              leading: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: quotes.isEmpty
                ? const Center(child: Text("No quote found"))
                : ListView.builder(
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      final quote = quotes[index];
                      return Dismissible(
                        key: Key(quote.id.toString()),
                        onDismissed: (_) async {
                          await repository.deleteFavQuote(quote.id!);
                          fetchAll(); // Refresh the list
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Quote of ${quote.author} dismissed'),
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(quote.text),
                          subtitle: Text(quote.author),
                          titleTextStyle: const TextStyle(color: Colors.black),
                          subtitleTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          )
        ]));
  }
}
