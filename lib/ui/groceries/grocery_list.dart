import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

enum GrocceryTab { groceriesListTab, searchTab }

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});


  @override
  State<GroceryList> createState() => _GroceryListState();

}

class _GroceryListState extends State<GroceryList> {

  GrocceryTab _currentTab = GrocceryTab.groceriesListTab;

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          GroceriesListTab(),
          SearchTab()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        selectedItemColor: Colors.blue,
        onTap: (index){
          setState(() {
            _currentTab = GrocceryTab.values[index];
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Groceries'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search'
          ),
        ]
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}


class GroceriesListTab extends StatelessWidget {
  const GroceriesListTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (dummyGroceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: dummyGroceryItems.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: dummyGroceryItems[index]),
      );
    }
    return content;
  }
}


class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  
  String search = '';

  void onSearch(String value) {
    setState(() {
      search = value;
    });
  }

  List<Grocery> searchList() {
    if (search.isEmpty) return dummyGroceryItems;
    return dummyGroceryItems
        .where((grocery) =>
              grocery.name.toLowerCase().startsWith(search.trim().toLowerCase()),
        ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              label: Text("Search"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchList().length,
              itemBuilder: (context, index) =>
                  GroceryTile(grocery: searchList()[index]),
            ),
          ),
        ],
      ),
    );
  }
}