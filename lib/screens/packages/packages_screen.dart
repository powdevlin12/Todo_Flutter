import 'package:flutter/material.dart';
import 'package:learn_fluter/models/collection_model.dart';
import 'package:learn_fluter/services/database.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final TextEditingController _collectionNameController =
      TextEditingController();

  Future<void> _addCollection() async {
    // Kiểm tra xem người dùng đã nhập tên collection chưa
    if (_collectionNameController.text.isEmpty) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên collection'),
        ),
      );
      return;
    }

    // Tạo đối tượng Collection
    final newCollection = CollectionModel(name: _collectionNameController.text);

    // Gọi hàm insertCollection trong DatabaseHelper để thêm vào database
    await DBProvider.insertCollection(newCollection);

    // Đóng form và quay lại màn hình trước
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage package',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _collectionNameController,
                decoration: const InputDecoration(labelText: 'Tên Collection'),
              ),
              ElevatedButton(
                onPressed: _addCollection,
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
