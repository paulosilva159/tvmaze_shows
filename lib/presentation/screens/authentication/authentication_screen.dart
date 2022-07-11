import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobsity_challenge/presentation/screens/authentication/authentication_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/action_stream_listener.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({
    super.key,
    required this.presenter,
  });

  final AuthenticationPresenter presenter;
  static const routeName = '/';

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool shouldShowValidationMessage = false;
  final pinTextEditingController = TextEditingController();
  final pinFocusNode = FocusNode();
  final pinFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinFocusNode.dispose();
    pinFormKey.currentState?.dispose();
    pinTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ActionStreamListener<AuthenticationAction>(
        actionStream: widget.presenter.onNewAction,
        onReceived: (action) {
          if (action is NavigateToHomeAction) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }
        },
        child: StreamBuilder<AuthenticationState>(
            stream: widget.presenter.onNewState,
            builder: (context, snapshot) {
              final data = snapshot.data;
              shouldShowValidationMessage = true;

              if (data is RequestAuthentication) {
                final isAuthenticated = data.isAuthenticated;

                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                  child: Column(
                    children: [
                      const Text(
                        'Insert your pin here!',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: pinFormKey,
                        child: StatefulBuilder(builder: (context, setState) {
                          return TextFormField(
                            onTap: () {
                              setState(() {
                                pinFormKey.currentState?.reset();
                                shouldShowValidationMessage = false;
                              });
                            },
                            maxLength: 4,
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.always,
                            focusNode: pinFocusNode,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.number,
                            controller: pinTextEditingController,
                            decoration: const InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            validator: (input) {
                              if (isAuthenticated != null &&
                                  !isAuthenticated &&
                                  shouldShowValidationMessage) {
                                return 'Invalid pin!';
                              }

                              return null;
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 32),
                      if ((isAuthenticated ?? false))
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () {
                            final isValid =
                                pinFormKey.currentState?.validate() ?? false;

                            if (isValid) {
                              final pin =
                                  int.parse(pinTextEditingController.text);
                              pinTextEditingController.clear();
                              pinFocusNode.unfocus();
                              widget.presenter.onValidatePin.add(pin);
                            }
                          },
                          child: const Text('Validate'),
                        ),
                    ],
                  ),
                );
              }

              return const GenericLoadingIndicator();
            }),
      ),
    );
  }
}
