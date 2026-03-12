// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DownloadItemState {
  int get id => throw _privateConstructorUsedError;
  DownloadStatus get status => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  bool get isDownloading => throw _privateConstructorUsedError;

  /// Create a copy of DownloadItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadItemStateCopyWith<DownloadItemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadItemStateCopyWith<$Res> {
  factory $DownloadItemStateCopyWith(
    DownloadItemState value,
    $Res Function(DownloadItemState) then,
  ) = _$DownloadItemStateCopyWithImpl<$Res, DownloadItemState>;
  @useResult
  $Res call({
    int id,
    DownloadStatus status,
    double progress,
    bool isDownloading,
  });
}

/// @nodoc
class _$DownloadItemStateCopyWithImpl<$Res, $Val extends DownloadItemState>
    implements $DownloadItemStateCopyWith<$Res> {
  _$DownloadItemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? progress = null,
    Object? isDownloading = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DownloadStatus,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            isDownloading: null == isDownloading
                ? _value.isDownloading
                : isDownloading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DownloadItemStateImplCopyWith<$Res>
    implements $DownloadItemStateCopyWith<$Res> {
  factory _$$DownloadItemStateImplCopyWith(
    _$DownloadItemStateImpl value,
    $Res Function(_$DownloadItemStateImpl) then,
  ) = __$$DownloadItemStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    DownloadStatus status,
    double progress,
    bool isDownloading,
  });
}

/// @nodoc
class __$$DownloadItemStateImplCopyWithImpl<$Res>
    extends _$DownloadItemStateCopyWithImpl<$Res, _$DownloadItemStateImpl>
    implements _$$DownloadItemStateImplCopyWith<$Res> {
  __$$DownloadItemStateImplCopyWithImpl(
    _$DownloadItemStateImpl _value,
    $Res Function(_$DownloadItemStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DownloadItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? progress = null,
    Object? isDownloading = null,
  }) {
    return _then(
      _$DownloadItemStateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DownloadStatus,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        isDownloading: null == isDownloading
            ? _value.isDownloading
            : isDownloading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$DownloadItemStateImpl implements _DownloadItemState {
  const _$DownloadItemStateImpl({
    required this.id,
    required this.status,
    required this.progress,
    required this.isDownloading,
  });

  @override
  final int id;
  @override
  final DownloadStatus status;
  @override
  final double progress;
  @override
  final bool isDownloading;

  @override
  String toString() {
    return 'DownloadItemState(id: $id, status: $status, progress: $progress, isDownloading: $isDownloading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadItemStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.isDownloading, isDownloading) ||
                other.isDownloading == isDownloading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, status, progress, isDownloading);

  /// Create a copy of DownloadItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadItemStateImplCopyWith<_$DownloadItemStateImpl> get copyWith =>
      __$$DownloadItemStateImplCopyWithImpl<_$DownloadItemStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DownloadItemState implements DownloadItemState {
  const factory _DownloadItemState({
    required final int id,
    required final DownloadStatus status,
    required final double progress,
    required final bool isDownloading,
  }) = _$DownloadItemStateImpl;

  @override
  int get id;
  @override
  DownloadStatus get status;
  @override
  double get progress;
  @override
  bool get isDownloading;

  /// Create a copy of DownloadItemState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadItemStateImplCopyWith<_$DownloadItemStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DownloadsState {
  List<DownloadItemState> get items => throw _privateConstructorUsedError;

  /// Create a copy of DownloadsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadsStateCopyWith<DownloadsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadsStateCopyWith<$Res> {
  factory $DownloadsStateCopyWith(
    DownloadsState value,
    $Res Function(DownloadsState) then,
  ) = _$DownloadsStateCopyWithImpl<$Res, DownloadsState>;
  @useResult
  $Res call({List<DownloadItemState> items});
}

/// @nodoc
class _$DownloadsStateCopyWithImpl<$Res, $Val extends DownloadsState>
    implements $DownloadsStateCopyWith<$Res> {
  _$DownloadsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<DownloadItemState>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DownloadsStateImplCopyWith<$Res>
    implements $DownloadsStateCopyWith<$Res> {
  factory _$$DownloadsStateImplCopyWith(
    _$DownloadsStateImpl value,
    $Res Function(_$DownloadsStateImpl) then,
  ) = __$$DownloadsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DownloadItemState> items});
}

/// @nodoc
class __$$DownloadsStateImplCopyWithImpl<$Res>
    extends _$DownloadsStateCopyWithImpl<$Res, _$DownloadsStateImpl>
    implements _$$DownloadsStateImplCopyWith<$Res> {
  __$$DownloadsStateImplCopyWithImpl(
    _$DownloadsStateImpl _value,
    $Res Function(_$DownloadsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DownloadsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$DownloadsStateImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<DownloadItemState>,
      ),
    );
  }
}

/// @nodoc

class _$DownloadsStateImpl implements _DownloadsState {
  const _$DownloadsStateImpl({required final List<DownloadItemState> items})
    : _items = items;

  final List<DownloadItemState> _items;
  @override
  List<DownloadItemState> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'DownloadsState(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of DownloadsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsStateImplCopyWith<_$DownloadsStateImpl> get copyWith =>
      __$$DownloadsStateImplCopyWithImpl<_$DownloadsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DownloadsState implements DownloadsState {
  const factory _DownloadsState({
    required final List<DownloadItemState> items,
  }) = _$DownloadsStateImpl;

  @override
  List<DownloadItemState> get items;

  /// Create a copy of DownloadsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadsStateImplCopyWith<_$DownloadsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
