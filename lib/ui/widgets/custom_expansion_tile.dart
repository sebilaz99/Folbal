import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionTile({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTile();
}

class _CustomExpansionTile extends State<CustomExpansionTile>
    with ChangeNotifier {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        title: Text(widget.title),
        collapsedBackgroundColor: Colors.white70,
        trailing: Icon(
          isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: Colors.blueAccent,
        ),
        backgroundColor: Colors.white70,
        children: widget.children,
      ),
    );
  }
}
