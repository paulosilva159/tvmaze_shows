import 'package:flutter/material.dart';

class AsyncSnapshotResponseView<Success, Loading, Error>
    extends StatelessWidget {
  const AsyncSnapshotResponseView({
    super.key,
    required this.snapshot,
    required this.successWidgetBuilder,
    this.loadingWidgetBuilder,
    this.errorWidgetBuilder,
  });

  final AsyncSnapshot snapshot;
  final Widget Function(BuildContext context, Success success)
      successWidgetBuilder;
  final Widget Function(BuildContext context, Loading loading)?
      loadingWidgetBuilder;
  final Widget Function(BuildContext context, Error error)? errorWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data;

    if (data == null || data is Loading) {
      return loadingWidgetBuilder?.call(context, data) ??
          const GenericLoadingIndicator();
    } else if (data is Error) {
      return errorWidgetBuilder?.call(context, data) ??
          const GenericErrorIndicator();
    } else if (data is Success) {
      return successWidgetBuilder(context, data);
    }

    // TODO(paulosilva): Implement custom exception
    throw Exception();
  }
}

class GenericLoadingIndicator extends StatelessWidget {
  const GenericLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}
