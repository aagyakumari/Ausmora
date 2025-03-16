import 'package:flutter/material.dart';
import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BundleWidget extends StatefulWidget {
  @override
  _BundleWidgetState createState() => _BundleWidgetState();
}

class _BundleWidgetState extends State<BundleWidget> {
  Future<List<dynamic>>? _bundlesFuture;

  @override
  void initState() {
    super.initState();
    _bundlesFuture = _fetchBundles();
  }

  Future<List<dynamic>> _fetchBundles() async {
    final String? token = await HiveService().getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await http.get(
      Uri.parse('http://145.223.23.200:3004/frontend/GuestQuestion/GetQuestion?is_bundle=true'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['questions'] ?? [];
    } else {
      throw Exception("Failed to load bundles: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _bundlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No bundles available"));
        }

        final bundles = snapshot.data!;
        return ListView.builder(
          itemCount: bundles.length,
          itemBuilder: (context, index) {
            final bundle = bundles[index];

            // Handling null or empty fields
            final String question = bundle['question'] ?? "Unknown Question";
            final String imageBlob = bundle['image_blob'] ?? "";
            final double price = bundle['price'] ?? 0.0;
            final double priceBeforeDiscount = bundle['price_before_discount'] ?? 0.0;
            final double discountAmount = bundle['discount_amount'] ?? 0.0;

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: imageBlob.isNotEmpty
                    ? Image.network(imageBlob, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported),
                title: Text(question),
                subtitle: Text("Price: \$${price.toStringAsFixed(2)} (Before: \$${priceBeforeDiscount.toStringAsFixed(2)})"),
                trailing: Text("Save \$${discountAmount.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            );
          },
        );
      },
    );
  }
}
