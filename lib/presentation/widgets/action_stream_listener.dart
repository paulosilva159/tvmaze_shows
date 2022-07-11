import 'package:flutter/material.dart';
import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

class ActionStreamListener<T> extends StatefulWidget {
  const ActionStreamListener({
    super.key,
    required this.child,
    required this.actionStream,
    required this.onReceived,
  });

  final Widget child;
  final Stream<T> actionStream;
  final void Function(T action) onReceived;

  @override
  State<ActionStreamListener<T>> createState() =>
      _ActionStreamListenerState<T>();
}

class _ActionStreamListenerState<T> extends State<ActionStreamListener<T>>
    with SubscriptionHolder {
  @override
  void initState() {
    super.initState();
    widget.actionStream
        .listen((event) => widget.onReceived(event))
        .addTo(subscriptions);
  }

  @override
  void dispose() {
    super.dispose();
    disposeAll();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
