import 'package:flutter/material.dart';

class SearchBarCommon extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarCommon({super.key, required this.onSearch});

  @override
  State<SearchBarCommon> createState() => SearchBarCommonState();
}

class SearchBarCommonState extends State<SearchBarCommon> {
  final TextEditingController _controllerSearch = TextEditingController();

  void handleSearch(value) {
    String valueSearch = _controllerSearch.text;
    widget.onSearch(valueSearch);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search here...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (String value) {
                handleSearch(value);
              },
              controller: _controllerSearch,
            ),
          ),
          const Icon(
            Icons.search,
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
