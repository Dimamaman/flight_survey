import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'download_state.dart';
import 'download_status.dart';

export 'download_status.dart';

/// Events that drive the download state machine for a specific item index.
abstract class DownloadsEvent {
  const DownloadsEvent(this.index);
  final int index;
}

class DownloadStart extends DownloadsEvent {
  const DownloadStart(int index) : super(index);
}

class DownloadStop extends DownloadsEvent {
  const DownloadStop(int index) : super(index);
}

class DownloadOpen extends DownloadsEvent {
  const DownloadOpen(int index) : super(index);
}

/// Bloc that simulates downloads with progress updates for a list of items.
class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  DownloadsBloc({
    required int itemCount,
    required void Function(int index) onOpenDownload,
  })  : _onOpenDownload = onOpenDownload,
        super(DownloadsState.initial(itemCount)) {
    on<DownloadStart>(_onStartDownload);
    on<DownloadStop>(_onStopDownload);
    on<DownloadOpen>(_onOpenDownloadEvent);
  }

  final void Function(int index) _onOpenDownload;

  Future<void> _onStartDownload(
    DownloadStart event,
    Emitter<DownloadsState> emit,
  ) async {
    final index = event.index;
    final item = state.items[index];

    if (item.status != DownloadStatus.notDownloaded) {
      return;
    }

    await _doSimulatedDownload(index, emit);
  }

  void _onStopDownload(
    DownloadStop event,
    Emitter<DownloadsState> emit,
  ) {
    final index = event.index;
    final item = state.items[index];

    if (!item.isDownloading) {
      return;
    }

    final updated = item.copyWith(
      isDownloading: false,
      status: DownloadStatus.notDownloaded,
      progress: 0.0,
    );

    _emitForIndex(index, updated, emit);
  }

  void _onOpenDownloadEvent(
    DownloadOpen event,
    Emitter<DownloadsState> emit,
  ) {
    final index = event.index;
    final item = state.items[index];

    if (item.status == DownloadStatus.downloaded) {
      _onOpenDownload(index);
    }
  }

  Future<void> _doSimulatedDownload(
    int index,
    Emitter<DownloadsState> emit,
  ) async {
    // Move to fetching state.
    final fetching = state.items[index].copyWith(
      isDownloading: true,
      status: DownloadStatus.fetchingDownload,
      progress: 0.0,
    );
    _emitForIndex(index, fetching, emit);

    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!state.items[index].isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    final downloading = state.items[index].copyWith(
      status: DownloadStatus.downloading,
    );
    _emitForIndex(index, downloading, emit);

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
    for (final stop in downloadProgressStops) {
      // Wait a second to simulate varying download speeds.
      await Future<void>.delayed(const Duration(seconds: 1));

      // If the user chose to cancel the download, stop the simulation.
      if (!state.items[index].isDownloading) {
        return;
      }

      // Update the download progress.
      final updated = state.items[index].copyWith(
        progress: stop,
      );
      _emitForIndex(index, updated, emit);
    }

    // Wait a second to simulate a final delay.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!state.items[index].isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
    final completed = state.items[index].copyWith(
      status: DownloadStatus.downloaded,
      isDownloading: false,
      progress: 1.0,
    );
    _emitForIndex(index, completed, emit);
  }

  void _emitForIndex(
    int index,
    DownloadItemState updatedItem,
    Emitter<DownloadsState> emit,
  ) {
    final items = List<DownloadItemState>.from(state.items);
    items[index] = updatedItem;
    emit(state.copyWith(items: items));
  }
}
