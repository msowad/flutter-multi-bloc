import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc/bloc/app_state.dart';
import 'package:multi_bloc/bloc/bloc_event.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> urls);

extension RandomElement<T> on Iterable<T> {
  T randomElement() => elementAt(Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> urls) => urls.randomElement();

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(const AppState()) {
    on<LoadNextUrlEvent>(
      (event, emit) async {
        emit(const AppState.loading());
        final url = (urlPicker ?? _pickRandomUrl)(urls);
        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }
          final bundle = NetworkAssetBundle(Uri.parse(url));
          final data = (await bundle.load(url)).buffer.asUint8List();
          emit(AppState(data: data));
        } catch (e) {
          emit(AppState(error: e));
        }
      },
    );
  }
}
