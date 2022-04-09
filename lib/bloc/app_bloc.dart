import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc/bloc/app_state.dart';
import 'package:multi_bloc/bloc/bloc_event.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> urls);

typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T randomElement() => elementAt(Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> urls) => urls.randomElement();
  Future<Uint8List> _loadUrl(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((byteData) => byteData.buffer.asUint8List());

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
  }) : super(const AppState()) {
    on<LoadNextUrlEvent>(
      (event, emit) async {
        emit(const AppState.loading());
        final url = (urlPicker ?? _pickRandomUrl)(urls);
        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }
          final data = await (urlLoader ?? _loadUrl)(url);
          emit(AppState(data: data));
        } catch (e) {
          emit(AppState(error: e));
        }
      },
    );
  }
}
