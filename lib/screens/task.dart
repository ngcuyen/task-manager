import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedStatus = 'Complete';
  String? selectedTaskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatusTabs(),
            Expanded(
              child: _buildTaskList(),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.purple[100],
          child: const Icon(Icons.add, color: Colors.purple),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.purple,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Task List',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sync, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildStatusChip('Complete', '45'),
          const SizedBox(width: 8),
          _buildStatusChip('To Do', '45'),
          const SizedBox(width: 8),
          _buildStatusChip('In Review', '3'),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String count) {
    final isSelected = selectedStatus == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = label;
          selectedTaskId = null; // Reset selected task when changing status
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[300]!,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    // Sample task data with unique IDs
    final tasks = [
      TaskData(
        id: '1',
        title: 'Dashboard design for admin',
        priority: 'High',
        priorityColor: Colors.red,
        status: 'On Track',
        statusColor: Colors.purple,
        date: '14 oct 2022',
        views: 5,
        comments: 5,
      ),
      TaskData(
        id: '2',
        title: 'Konom web application',
        priority: 'Low',
        priorityColor: Colors.green,
        status: 'Meeting',
        statusColor: Colors.purple,
        date: '14 Nov 2022',
        views: 2,
        comments: 4,
      ),
      TaskData(
        id: '3',
        title: 'Research and development',
        priority: 'Medium',
        priorityColor: Colors.black,
        status: 'At Risk',
        statusColor: Colors.black,
        date: '14 oct 2022',
        views: 6,
        comments: 2,
      ),
      TaskData(
        id: '4',
        title: 'Event booking application',
        priority: 'Medium',
        priorityColor: Colors.orange,
        status: 'Meeting',
        statusColor: Colors.purple,
        date: '14 oct 2022',
        views: 5,
        comments: 5,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTaskId = selectedTaskId == task.id ? null : task.id;
            });
          },
          child: TaskCard(
            title: task.title,
            priority: task.priority,
            priorityColor: task.priorityColor,
            status: task.status,
            statusColor: task.statusColor,
            date: task.date,
            views: task.views,
            comments: task.comments,
            isHighlighted: selectedTaskId == task.id,
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.grid_4x4, color: Colors.grey),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Task',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const Icon(Icons.bar_chart, color: Colors.grey),
          const CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=1',
            ),
          ),
        ],
      ),
    );
  }
}

// Data class for task
class TaskData {
  final String id;
  final String title;
  final String priority;
  final Color priorityColor;
  final String status;
  final Color statusColor;
  final String date;
  final int views;
  final int comments;

  TaskData({
    required this.id,
    required this.title,
    required this.priority,
    required this.priorityColor,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.views,
    required this.comments,
  });
}

class TaskCard extends StatelessWidget {
  final String title;
  final String priority;
  final Color priorityColor;
  final String status;
  final Color statusColor;
  final String date;
  final int views;
  final int comments;
  final bool isHighlighted;

  const TaskCard({
    Key? key,
    required this.title,
    required this.priority,
    required this.priorityColor,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.views,
    required this.comments,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.green[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: isHighlighted ? 0 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.more_horiz),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              const Icon(Icons.remove_red_eye_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                views.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                comments.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=2'),
                  ),
                  Positioned(
                    left: 16,
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}