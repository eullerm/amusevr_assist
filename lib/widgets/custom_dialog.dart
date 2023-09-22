import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Map<String, dynamic> items;
  final List<Widget>? actions;
  final Function() onConfirm;

  const CustomDialog({super.key, required this.title, this.actions, required this.items, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.entries.map((entry) => _buildInfo(entry.key.toString(), entry.value)).toList(),
      ),
      actions: [
        ButtonBar(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text("Conectar"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfo(String label, dynamic value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value.toString()))
        ],
      ),
    );
  }
}
