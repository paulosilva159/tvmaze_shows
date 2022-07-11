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
  const GenericErrorIndicator({
    super.key,
    this.message,
    this.onTryAgain,
    this.messageStyle,
    this.backgroundColor,
  });

  final String? message;
  final Color? backgroundColor;
  final TextStyle? messageStyle;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message ?? 'Ops, something went wrong...',
              style: messageStyle,
              textAlign: TextAlign.center,
            ),
            if (onTryAgain != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onTryAgain,
                child: const Text('Try again'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
