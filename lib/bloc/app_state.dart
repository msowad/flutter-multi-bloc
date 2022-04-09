import 'dart:typed_data';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;

  const AppState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  const AppState.loading()
      : isLoading = true,
        data = null,
        error = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'hasData': data != null,
        'error': error
      }.toString();
}
