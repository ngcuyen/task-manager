import 'package:flutter/material.dart';
import 'package:task_manager/services/firebase_service.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/widgets/back_button.dart';
import 'package:task_manager/widgets/textfield.dart';
import 'package:task_manager/widgets/top_container.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

  // Lưu trữ danh mục đã chọn
  String _selectedCategory = '';

  // Kiểm tra trạng thái tải dữ liệu
  bool _isLoading = false;

  final List<String> categories = [
    'SPORT APP',
    'MEDICAL APP',
    'RENT APP',
    'NOTES',
    'GAMING PLATFORM APP'
  ];

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final selectedTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        if (isStartTime) {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _validateInputs() {
    if (_titleController.text.isEmpty) {
      _showError('Please enter a title');
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      _showError('Please enter a description');
      return false;
    }
    if (_startTime == null) {
      _showError('Please select start time');
      return false;
    }
    if (_endTime == null) {
      _showError('Please select end time');
      return false;
    }
    if (_selectedCategory.isEmpty) {
      _showError('Please select a category');
      return false;
    }
    if (_endTime!.isBefore(_startTime!)) {
      _showError('End time cannot be before start time');
      return false;
    }
    return true;
  }

  Future<void> _createTask() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final newTask = Task(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: _startTime!,
        endTime: _endTime!,
        category: _selectedCategory,
      );

      await _firebaseService.addTask(newTask);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (mounted) {
        _showError('Failed to create task: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Create new task',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyTextField(
                          label: 'Title',
                          controller: _titleController,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectTime(context, true),
                            child: MyTextField(
                              label: 'Start Time',
                              icon: downwardIcon,
                              enabled: false,
                              controller: TextEditingController(
                                text: _formatTime(_startTime),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectTime(context, false),
                            child: MyTextField(
                              label: 'End Time',
                              icon: downwardIcon,
                              enabled: false,
                              controller: TextEditingController(
                                text: _formatTime(_endTime),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    MyTextField(
                      label: 'Description',
                      minLines: 3,
                      maxLines: 3,
                      controller: _descriptionController,
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 5.0,
                            children: categories.map((category) {
                              final isSelected = _selectedCategory == category;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                                child: Chip(
                                  label: Text(category),
                                  backgroundColor: isSelected 
                                    ? Colors.blue 
                                    : Colors.grey[300],
                                  labelStyle: TextStyle(
                                    color: isSelected 
                                      ? Colors.white 
                                      : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: _isLoading ? null : _createTask,
                    child: Container(
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Create Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      width: width - 40,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.blue[300] : Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
