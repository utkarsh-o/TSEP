import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PDFView extends StatefulWidget {
  String path;
  PDFView({required this.path});
  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  bool _isLoading = true;
  PDFDocument document = PDFDocument();
  getPDF() async {
    document = await PDFDocument.fromAsset(widget.path);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(document: document),
    );
  }
}
