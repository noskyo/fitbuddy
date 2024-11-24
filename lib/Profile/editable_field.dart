import 'package:flutter/material.dart';

class EditableField extends StatefulWidget {
  final String label;
  final String fieldKey;
  final Map<String, dynamic> userData;
  final bool isEditing;
  final Function(bool) onEditToggle;

  const EditableField({
    Key? key,
    required this.label,
    required this.fieldKey,
    required this.userData,
    required this.isEditing,
    required this.onEditToggle,
  }) : super(key: key);

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.userData[widget.fieldKey]?.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        widget.isEditing
            ? TextField(
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        )
            : Text(widget.userData[widget.fieldKey]?.toString() ?? 'N/A'),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (widget.isEditing) {
                widget.userData[widget.fieldKey] = controller.text;
              }
              widget.onEditToggle(!widget.isEditing);
            });
          },
          child: Text(widget.isEditing ? 'Save' : 'Edit'),
        ),
      ],
    );
  }
}
