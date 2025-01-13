// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final String description;
  final Color boxColor;
  final String? startTime;
  final String? endTime;
  final String? status;

  const TaskContainer({
    required this.title,
    required this.description,
    required this.boxColor,
    this.startTime,
    this.endTime,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Hàng đầu tiên: hiển thị tiêu đề và trạng thái
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hiển thị tiêu đề
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Giới hạn nếu tiêu đề quá dài
                ),
              ),
              // Hiển thị trạng thái bên phải
              if (status != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent, // Nền trạng thái
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    status!,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Màu chữ
                    ),
                  ),
                ),
            ],
          ),
          // Hiển thị mô tả bên dưới
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
