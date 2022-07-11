import 'package:flutter/material.dart';

class AsyncSnapshotResponseView<Success, Loading, Error>
    extends StatelessWidget {
  const AsyncSnapshotResponseView({
    super.key,
    required this.snapshot,
    required this.successWidgetBuilder,
    this.loadingWidgetBuilder,
    this.errorWidgetBuilder,
    this.onTryAgain,
  });

  final AsyncSnapshot snapshot;
  final Widget Function(BuildContext context, Success success)
      successWidgetBuilder;
  final Widget Function(BuildContext context, Loading loading)?
      loadingWidgetBuilder;
  final Widget Function(BuildContext context, Error error)? errorWidgetBuilder;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data;

    if (data == null || data is Loading) {
      return loadingWidgetBuilder?.call(context, data) ??
          const GenericLoadingIndicator();
    } else if (data is Error) {
      return errorWidgetBuilder?.call(context, data) ??
          GenericErrorIndicator(onTryAgain: onTryAgain);
    } else if (data is Success) {
      return successWidgetBuilder(context, data);
    }

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
  const GenericErrorIndicator({super.key, this.message, this.onTryAgain});

  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? 'Ops, something went wrong...'),
          if (onTryAgain != null) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onTryAgain,
              child: const Text('Try again'),
            ),
          ]
        ],
      ),
    );
  }
}
