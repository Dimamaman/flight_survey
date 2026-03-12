import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: MeDownloadButton()));
}

class MeDownloadButton extends StatefulWidget {
  const MeDownloadButton({super.key});

  @override
  State<MeDownloadButton> createState() => _MeDownloadButtonState();
}

class _MeDownloadButtonState extends State<MeDownloadButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum DownloadStatus { notDownloaded, fetchingDownload, downloading, downloaded }

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get status;

  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulateController extends DownloadController with ChangeNotifier {
  SimulateController({
    DownloadStatus status = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
  }) : _downloadStatus = status,
       _progress = progress,
       _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  double _progress;

  @override
  DownloadStatus get status => _downloadStatus;

  @override
  double get progress => _progress;

  VoidCallback _onOpenDownload;

  @override
  void openDownload() {
    // TODO: implement openDownload
  }

  @override
  void startDownload() {
    // TODO: implement startDownload
  }

  @override
  void stopDownload() {
    // TODO: implement stopDownload
  }
}

abstract class A extends ChangeNotifier {
  @override
  // TODO: implement hasListeners
  bool get hasListeners => super.hasListeners;
}
