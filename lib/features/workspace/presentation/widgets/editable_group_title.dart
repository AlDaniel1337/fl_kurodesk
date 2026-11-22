import 'package:flutter/material.dart';

class EditableGroupTitle extends StatefulWidget {
  final String title;
  final ValueChanged<String> onSubmitted;

  const EditableGroupTitle({
    super.key,
    required this.title,
    required this.onSubmitted,
  });

  @override
  State<EditableGroupTitle> createState() => _EditableGroupTitleState();
}

class _EditableGroupTitleState extends State<EditableGroupTitle> {
  bool _isEditing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant EditableGroupTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title && !_isEditing) {
      _controller.text = widget.title;
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      _commitEdit();
    }
  }

  void _startEdit() {
    setState(() {
      _isEditing = true;
      _controller.text = widget.title;
    });
    _focusNode.requestFocus();
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  void _commitEdit() {
    setState(() => _isEditing = false);
    widget.onSubmitted(_controller.text);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white54, width: 1.5)),
          ),
          child: EditableText(
            controller: _controller,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            backgroundCursorColor: Colors.white24,
            selectionColor: Colors.white24,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            onSubmitted: (_) => _commitEdit(),
          ),
        ),
      );
    }

    return Tooltip(
      message: 'Doble clic para renombrar',
      child: GestureDetector(
        onDoubleTap: _startEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}