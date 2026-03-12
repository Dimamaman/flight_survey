import 'package:freezed_annotation/freezed_annotation.dart';

import 'download_status.dart';

part 'download_state.freezed.dart';

@freezed
class DownloadItemState with _$DownloadItemState {
  const factory DownloadItemState({
    required int id,
    required DownloadStatus status,
    required double progress,
    required bool isDownloading,
  }) = _DownloadItemState;

  factory DownloadItemState.initial(int id) => DownloadItemState(
    id: id,
    status: DownloadStatus.notDownloaded,
    progress: 0.0,
    isDownloading: false,
  );
}

@freezed
class DownloadsState with _$DownloadsState {
  const factory DownloadsState({required List<DownloadItemState> items}) =
      _DownloadsState;

  factory DownloadsState.initial(int itemCount) => DownloadsState(
    items: List<DownloadItemState>.generate(
      itemCount,
      DownloadItemState.initial,
    ),
  );
}

sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok(value);
  factory Result.error(Exception value) => Error(value);
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.error);
  final Exception error;
}

abstract class Base {}

class A<T extends Base> {
  T? state;

  void updateState(T newState) {
    state = newState;
  }
}
