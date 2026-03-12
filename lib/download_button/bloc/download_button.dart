import 'dart:developer';

import 'package:flight_survey/download_button/data/controller.dart';
import 'package:flight_survey/download_button/data/download_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleCupertinoDownloadButton(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleCupertinoDownloadButton extends StatefulWidget {
  const ExampleCupertinoDownloadButton({super.key});

  @override
  State<ExampleCupertinoDownloadButton> createState() =>
      _ExampleCupertinoDownloadButtonState();
}

class _ExampleCupertinoDownloadButtonState
    extends State<ExampleCupertinoDownloadButton> {
  late final DownloadsBloc _downloadsBloc;

  @override
  void initState() {
    super.initState();
    _downloadsBloc = DownloadsBloc(
      itemCount: 20,
      onOpenDownload: _openDownload,
    );
  }

  @override
  void dispose() {
    _downloadsBloc.close();
    super.dispose();
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Open App ${index + 1}')));
  }

  @override
  Widget build(BuildContext context) {
    Timeline.startSync('ExampleCupertinoDownloadButton.build');
    try {
      return Scaffold(
        appBar: AppBar(title: const Text('Apps')),
        body: BlocBuilder<DownloadsBloc, DownloadsState>(
          bloc: _downloadsBloc,
          builder: (context, state) {
            return ListView.separated(
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) =>
                  _buildListItem(context, index, state),
            );
          },
        ),
      );
    } finally {
      Timeline.finishSync();
    }
  }

  Widget _buildListItem(BuildContext context, int index, DownloadsState state) {
    Timeline.startSync('_buildListItem[$index]');
    try {
      final theme = Theme.of(context);
      final itemState = state.items[index];
      return ListTile(
        leading: const DemoAppIcon(),
        title: Text(
          'App ${index + 1}',
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        subtitle: Text(
          'Lorem ipsum dolor #${index + 1}',
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        trailing: SizedBox(
          width: 96,
          child: DownloadButton(
            status: itemState.status,
            downloadProgress: itemState.progress,
            onDownload: () => _downloadsBloc.add(DownloadStart(index)),
            onCancel: () => _downloadsBloc.add(DownloadStop(index)),
            onOpen: () => _downloadsBloc.add(DownloadOpen(index)),
          ),
        ),
      );
    } finally {
      Timeline.finishSync();
    }
  }
}

@immutable
class DemoAppIcon extends StatelessWidget {
  const DemoAppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    Timeline.startSync('DemoAppIcon.build');
    try {
      return const AspectRatio(
        aspectRatio: 1,
        child: FittedBox(
          child: SizedBox(
            width: 80,
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Icon(Icons.ac_unit, color: Colors.white, size: 40),
              ),
            ),
          ),
        ),
      );
    } finally {
      Timeline.finishSync();
    }
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    Timeline.startSync('DownloadButton.build');
    try {
      return GestureDetector(
        onTap: _onPressed,
        child: Stack(
          children: [
            ButtonShapeWidget(
              transitionDuration: transitionDuration,
              isDownloaded: _isDownloaded,
              isDownloading: _isDownloading,
              isFetching: _isFetching,
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                duration: transitionDuration,
                opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
                curve: Curves.ease,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ProgressIndicatorWidget(
                      downloadProgress: downloadProgress,
                      isDownloading: _isDownloading,
                      isFetching: _isFetching,
                    ),
                    if (_isDownloading)
                      const Icon(
                        Icons.stop,
                        size: 14,
                        color: CupertinoColors.activeBlue,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } finally {
      Timeline.finishSync();
    }
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    Timeline.startSync('ButtonShapeWidget.build');
    try {
      final ShapeDecoration shape;
      if (isDownloading || isFetching) {
        shape = const ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.transparent,
        );
      } else {
        shape = const ShapeDecoration(
          shape: StadiumBorder(),
          color: CupertinoColors.lightBackgroundGray,
        );
      }

      return AnimatedContainer(
        duration: transitionDuration,
        curve: Curves.ease,
        width: double.infinity,
        decoration: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: isDownloading || isFetching ? 0.0 : 1.0,
            curve: Curves.ease,
            child: Text(
              isDownloaded ? 'OPEN' : 'GET',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
        ),
      );
    } finally {
      Timeline.finishSync();
    }
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    Timeline.startSync('ProgressIndicatorWidget.build');
    try {
      return AspectRatio(
        aspectRatio: 1,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: downloadProgress),
          duration: const Duration(milliseconds: 200),
          builder: (context, progress, child) {
            return CircularProgressIndicator(
              backgroundColor: isDownloading
                  ? CupertinoColors.lightBackgroundGray
                  : Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                isFetching
                    ? CupertinoColors.lightBackgroundGray
                    : CupertinoColors.activeBlue,
              ),
              strokeWidth: 2,
              value: isFetching ? null : progress,
            );
          },
        ),
      );
    } finally {
      Timeline.finishSync();
    }
  }
}
