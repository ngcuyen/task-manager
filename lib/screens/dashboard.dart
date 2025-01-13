import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/widgets/chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    });
  }

  Map<String, int> countTasksByStatus(List<Map<String, dynamic>> tasks) {
    final Map<String, int> counts = {
      'TO DO': 0,
      'IN PROGRESS': 0,
      'TEST': 0,
      'DONE': 0,
    };

    for (var task in tasks) {
      final status = task['status'] as String?;
      if (status != null && counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontSize: 35),
        ),
        backgroundColor: Colors.yellow[50],
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 35,
            ),
            tooltip: 'Notifications',
            onPressed: () {
              // Handle the press
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: streamTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks available.'));
          }

          final taskCounts = countTasksByStatus(snapshot.data!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  childAspectRatio: 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildSummaryCard(
                      taskCounts['TO DO']?.toString() ?? '0',
                      'TO DO',
                      Colors.blue,
                    ),
                    buildSummaryCard(
                      taskCounts['IN PROGRESS']?.toString() ?? '0',
                      'IN PROGRESS',
                      Colors.purple,
                    ),
                    buildSummaryCard(
                      taskCounts['TEST']?.toString() ?? '0',
                      'TEST',
                      Colors.orange,
                    ),
                    buildSummaryCard(
                      taskCounts['DONE']?.toString() ?? '0',
                      'DONE',
                      Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Project Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: Chart()), // Placeholder for chart
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: buildStatisticCard(
                        'Total working hour',
                        '50:25:06',
                        '↑ 34%',
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildStatisticCard(
                        'Total task activity',
                        '125 Task',
                        '↓ 50%',
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSummaryCard(String number, String title, Color color) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ],
      ),
    );
  }

  Widget buildStatisticCard(
      String title, String value, String percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 14,
                  color: percentage.contains('↑') ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
