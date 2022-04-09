import 'package:flutter/material.dart';
import 'package:multi_bloc/bloc/app_bloc.dart';
import 'package:multi_bloc/bloc/app_state.dart';
import 'package:multi_bloc/bloc/bloc_event.dart';
import 'package:multi_bloc/extensions/stream/start_with.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 15),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
          if (state.data != null) {
            return Image.memory(
              state.data!,
              fit: BoxFit.fitHeight,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
