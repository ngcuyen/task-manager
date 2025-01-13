// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/screens/new_task.dart';
import 'package:task_manager/screens/one_task_detail.dart';
import 'package:task_manager/widgets/task_container.dart';
import 'package:task_manager/widgets/back_button.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> generateTimes() {
    return List.generate(24, (index) {
      return '${index.toString().padLeft(2, '0')}:00'; // Định dạng HH:00
    });
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String formatDateToFirestoreFormat(DateTime date) {
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    return formatter.format(date);
  }

  String formatToDateString(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  List<Map<String, dynamic>> filterTasksByDate(
      List<Map<String, dynamic>> tasks, DateTime selectedDate) {
    return tasks.where((task) {
      final startTime = (task['startTime'] as Timestamp?)?.toDate();
      final endTime = (task['endTime'] as Timestamp?)?.toDate();
      if (startTime == null || endTime == null) return false;

      // Kiểm tra nếu task thuộc ngày được chọn
      return startTime.year == selectedDate.year &&
          startTime.month == selectedDate.month &&
          startTime.day == selectedDate.day;
    }).toList();
  }

  List<Map<String, dynamic>> filterTasksByTime(
      List<Map<String, dynamic>> tasks, DateTime selectedDate, int hour) {
    return tasks.where((task) {
      final startTime = (task['startTime'] as Timestamp?)?.toDate();
      final endTime = (task['endTime'] as Timestamp?)?.toDate();
      if (startTime == null || endTime == null) return false;

      // Kiểm tra nếu task thuộc giờ và ngày được chọn
      return startTime.year == selectedDate.year &&
          startTime.month == selectedDate.month &&
          startTime.day == selectedDate.day &&
          startTime.hour == hour;
    }).toList();
  }

  List<Map<String, dynamic>> filterTasksBySelectedDay(
      List<Map<String, dynamic>> tasks, DateTime selectedDay) {
    final selectedDateString = formatToDateString(selectedDay);

    return tasks.where((task) {
      final startTimeString =
          formatToDateString(DateTime.parse(task['startTime']));

      // So sánh chỉ ngày (yyyy-MM-dd)
      return startTimeString == selectedDateString;
    }).toList();
  }

  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];
  List<String> times = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    times = generateTimes(); // Tạo danh sách giờ
    streamTasks().listen((event) {
      tasks = event; // Lấy danh sách tasks từ Firestore
      setState(() {
        isLoading = false;
      });
    });
  }

  Stream<List<Map<String, dynamic>>> streamTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'],
          'description': data['description'],
          'category': data['category'],
          'status': data['status'],
          'startTime': data['startTime'],
          'endTime': data['endTime'],
        };
      }).toList();
    }).handleError((error) {
      // Xử lý lỗi nếu cần thiết
      print('Error in streamTasks: $error');
      return <Map<String, dynamic>>[]; // Trả về danh sách rỗng nếu có lỗi
    });
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style:
            TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final today = DateTime.now();
    final times = generateTimes();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              MyBackButton(),
              SizedBox(height: 30.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Today',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 40.0,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewTaskScreen(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Add task',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Productive Day, Uyen',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                    // Lọc task theo ngày
                    filteredTasks =
                        filterTasksBySelectedDay(tasks, selectedDay);
                  });
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false, // Ẩn nút thay đổi format
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  todayTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.blue),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Cột hiển thị theo giờ
                        Expanded(
                          flex: 1,
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  itemCount:
                                      times.length, // times là danh sách giờ
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final time =
                                        times[index]; // Lấy giờ từ danh sách
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            time, // Hiển thị giờ (AM/PM)
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        SizedBox(width: 20),
                        // Cột hiển thị tất cả các tasks trong ngày hôm nay
                        Expanded(
                          flex: 5,
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: streamTasks(), // Dòng dữ liệu từ Firestore
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error loading tasks!',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.red),
                                  ),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No tasks for this day!',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black54),
                                  ),
                                );
                              }

                              // Lọc danh sách tasks theo ngày được chọn
                              final tasks = snapshot.data!;
                              final filteredTasks = filterTasksBySelectedDay(
                                tasks,
                                _selectedDay ?? _focusedDay,
                              );

                              if (filteredTasks.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No tasks for this day!',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black54),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: filteredTasks.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  final task = filteredTasks[index];
                                  return Column(
                                    children: [
                                      _dashedText(),
                                      Container(
                                        width: double.infinity,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OneTaskScreen(
                                                  taskId: task['id'],
                                                  task: task,
                                                ),
                                              ),
                                            );
                                          },
                                          child: TaskContainer(
                                            title: task['title'],
                                            description: task['description'],
                                            boxColor: Color.fromARGB(
                                                255, 253, 238, 107),
                                            status: task['status'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
