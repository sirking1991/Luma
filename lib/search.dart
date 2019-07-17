
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  final cities = [
    'Makati',
    'Pasay',
    'Manila',
    'Paranaque',
    'Pasig',
    'Taguig',
    'Mandaluyong',
    'Pateros',
    'Navotas',
    'Quezon city',
    'Las Pinas',
    'Valenzuela'
  ];

  final recentCities = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return Card(
      color: Colors.red,
      shape: StadiumBorder(),
      child: Center(
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone search for something
    final suggestionList = query.isEmpty
        ? recentCities
        : cities
        .where((p) => p.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}