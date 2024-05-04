import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:real_time_collaboration_demo/service/websocket_service.dart';

class DocumentEditorWidget extends StatefulWidget {
  final WebsocketService websocketService;

  final QuillController quillController = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  DocumentEditorWidget({super.key, required this.websocketService});

  @override
  State<DocumentEditorWidget> createState() => _DocumentEditorWidgetState();
}

class _DocumentEditorWidgetState extends State<DocumentEditorWidget> {
  @override
  void initState() {
    widget.websocketService
        .addChangeListener((data) => widget.quillController.compose(
              Delta.fromJson(data['delta']),
              widget.quillController.selection,
              ChangeSource.remote,
            ));

    widget.quillController.changes.listen((event) {
      if (event.source == ChangeSource.local) {
        Map<String, dynamic> map = {
          'delta': event.change,
        };
        widget.websocketService.typing(map);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 850,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: widget.quillController,
                    autoFocus: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.quillController.dispose();
    super.dispose();
  }
}
