// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontSize: 35),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 35,
            ),
            tooltip: 'Notifications',
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Project Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildSummaryCard('24', 'In Progress', Colors.blue),
                  buildSummaryCard('56', 'In Review', Colors.purple),
                  buildSummaryCard('16', 'On Hold', Colors.orange),
                  buildSummaryCard('45', 'Completed', Colors.green),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Project Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                    child:
                        Text('Chart Placeholder')), // Sử dụng package chart sau
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: buildStatisticCard('Total working hour',
                          '50:25:06', '↑ 34%', Colors.purple)),
                  SizedBox(width: 16),
                  Expanded(
                      child: buildStatisticCard('Total task activity',
                          '125 Task', '↓ 50%', Colors.blue)),
                ],
              ),
            ])),
      ),
    );
  }

  Widget buildSummaryCard(String number, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          Spacer(),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                percentage,
                style: TextStyle(
                    fontSize: 14,
                    color:
                        percentage.contains('↑') ? Colors.green : Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
