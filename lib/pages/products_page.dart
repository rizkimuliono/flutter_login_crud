import 'package:flutter/material.dart';
import 'package:flutter_login_crud/models/product.dart';
import 'package:flutter_login_crud/services/api_service.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    List<dynamic> data = await _apiService.getProducts();
    setState(() {
      _products = data.map((json) => Product.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  _addProduct() {
    // Implementation for adding a new product
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = "";
        String description = "";
        int price = 0;

        return AlertDialog(
          title: Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                onChanged: (value) {
                  price = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () async {
                await _apiService.createProduct({
                  "title": title,
                  "description": description,
                  "price": price,
                  "categoryId": 1,
                  "images": ["https://placeimg.com/640/480/any"]
                });
                Navigator.of(context).pop();
                _loadProducts();
              },
            ),
          ],
        );
      },
    );
  }

  _editProduct(Product product) {
    // Implementation for editing a product
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = product.title;
        int price = product.price;

        return AlertDialog(
          title: Text("Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(labelText: "Title"),
                controller: TextEditingController(text: product.title),
              ),
              TextField(
                onChanged: (value) {
                  price = int.tryParse(value) ?? product.price;
                },
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: product.price.toString()),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                await _apiService.updateProduct(product.id, {
                  "title": title,
                  "price": price,
                });
                Navigator.of(context).pop();
                _loadProducts();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteProduct(int id) async {
    await _apiService.deleteProduct(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProduct,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                Product product = _products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('Price: \$${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProduct(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProduct(product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
