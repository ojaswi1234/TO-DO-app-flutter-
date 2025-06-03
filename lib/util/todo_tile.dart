import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(), // Corrected motion to StretchMotion
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12), // Added borderRadius
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.yellow[300],
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                shape: const CircleBorder(),
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              Text(taskName, style: TextStyle(decoration: taskCompleted ? TextDecoration.lineThrough : TextDecoration.none, color: taskCompleted ? Colors.grey[600] : Colors.black, fontSize: 16, fontWeight: taskCompleted ? FontWeight.w400 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
