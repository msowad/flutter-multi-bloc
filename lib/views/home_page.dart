import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc/bloc/bottom_bloc.dart';
import 'package:multi_bloc/bloc/top_bloc.dart';
import 'package:multi_bloc/models/constants.dart';
import 'package:multi_bloc/views/app_bloc_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (context) => TopBloc(
                waitBeforeLoading: const Duration(seconds: 1),
                urls: images,
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (context) => BottomBloc(
                waitBeforeLoading: const Duration(seconds: 1),
                urls: images,
              ),
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
