import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Dùng Firestore cho logic lưu trữ

class OneTaskScreen extends StatefulWidget {
  final String taskId; // ID của task trong Firestore
  final Map<String, dynamic> task; // Dữ liệu ban đầu của task

  const OneTaskScreen({required this.taskId, required this.task, Key? key})
      : super(key: key);

  @override
  _OneTaskScreenState createState() => _OneTaskScreenState();
}

class _OneTaskScreenState extends State<OneTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  String? _selectedStatus;
  final List<String> _statusOptions = [
    'TO DO',
    'IN PROGRESS',
    'TEST',
    'DONE',
    "pending"
  ];

  @override
  void initState() {
    super.initState();

    // Khởi tạo các controller với dữ liệu từ task
    _titleController = TextEditingController(text: widget.task['title']);
    _descriptionController =
        TextEditingController(text: widget.task['description']);
    _categoryController = TextEditingController(text: widget.task['category']);
    _startTimeController =
        TextEditingController(text: widget.task['startTime']);
    _endTimeController = TextEditingController(text: widget.task['endTime']);
    _selectedStatus = widget.task['status'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'startTime': _startTimeController.text,
        'endTime': _endTimeController.text,
        'status': _selectedStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully!')),
      );
    } catch (e) {
      print('Error updating task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task.')),
      );
    }
  }

  Future<void> _deleteTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully!')),
      );
      Navigator.pop(context); // Quay lại trang trước
    } catch (e) {
      print('Error deleting task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task.')),
      );
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible:
              false, // Không cho phép đóng khi nhấn ngoài hộp thoại
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete this task?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Người dùng chọn "Cancel"
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Người dùng chọn "Confirm"
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Trả về false nếu người dùng đóng hộp thoại mà không chọn gì
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.yellow[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEditableField('Title', _titleController),
            SizedBox(height: 10),
            _buildEditableField('Description', _descriptionController),
            SizedBox(height: 10),
            _buildEditableField('Category', _categoryController),
            SizedBox(height: 10),
            _buildEditableField('Start Time', _startTimeController),
            SizedBox(height: 10),
            _buildEditableField('End Time', _endTimeController),
            SizedBox(height: 10),
            _buildDropdownField(),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirmed = await _confirmDelete(
                          context); // Gọi hộp thoại xác nhận
                      if (confirmed) {
                        _deleteTask(); // Chỉ xóa nếu người dùng xác nhận
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      items: _statusOptions.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
      },
    );
  }
}
