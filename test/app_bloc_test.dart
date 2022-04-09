import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_bloc/bloc/app_bloc.dart';
import 'package:multi_bloc/bloc/app_state.dart';
import 'package:multi_bloc/bloc/bloc_event.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty',
    build: () => AppBloc(urls: []),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'load valid data and compare state',
    build: () => AppBloc(
      urls: [],
      urlLoader: (_) => Future.value(text1Data),
      urlPicker: (_) => '',
    ),
    act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
    expect: () => [
      const AppState.loading(),
      AppState(data: text1Data),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Through error and match the error',
    build: () => AppBloc(
      urls: [],
      urlLoader: (_) => Future.error(Errors.dummy),
      urlPicker: (_) => '',
    ),
    act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
    expect: () => [
      const AppState.loading(),
      const AppState(error: Errors.dummy),
    ],
  );

  blocTest<AppBloc, AppState>(
    'test multiple event handling',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (appBloc) {
      appBloc.add(const LoadNextUrlEvent());
      appBloc.add(const LoadNextUrlEvent());
    },
    expect: () => [
      const AppState.loading(),
      AppState(data: text2Data),
      const AppState.loading(),
      AppState(data: text2Data),
    ],
  );
}
