import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobsity_challenge/presentation/screens/authentication_settings/authentication_settings_presenter.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';

class AuthenticationSettingsScreen extends StatefulWidget {
  const AuthenticationSettingsScreen({
    super.key,
    required this.presenter,
  });

  final AuthenticationSettingsPresenter presenter;
  static const routeName = '/settings';

  @override
  State<AuthenticationSettingsScreen> createState() =>
      _AuthenticationSettingsScreenState();
}

class _AuthenticationSettingsScreenState
    extends State<AuthenticationSettingsScreen> {
  bool shouldShowPin = true;
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: StreamBuilder<AuthenticationSettingsState>(
            stream: widget.presenter.onNewState,
            builder: (context, snapshot) {
              final data = snapshot.data;

              if (data == null) {
                return const GenericLoadingIndicator();
              } else {
                final message = data is AuthenticationDisabled
                    ? 'Create a pin password for the next time you log in!'
                    : 'Want to update your pin?';
                final buttonLabel =
                    data is AuthenticationDisabled ? 'Save pin' : 'Update pin';

                return Column(
                  children: [
                    if (data is AuthenticationDisabled)
                      const Text(
                        'Authentication disabled',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Authentication enabled',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 12,
                          )
                        ],
                      ),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: pinFormKey,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return TextFormField(
                            maxLength: 4,
                            focusNode: pinFocusNode,
                            obscureText: shouldShowPin,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.number,
                            controller: pinTextEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Insert your pin here...',
                              hintStyle: const TextStyle(fontSize: 12),
                              prefixIcon: const Icon(Icons.lock),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    shouldShowPin = !shouldShowPin;
                                  });
                                },
                                icon: Icon(
                                  shouldShowPin
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (input) {
                              if (input != null && input.length != 4) {
                                return 'Pin should have 4 numbers!';
                              }

                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        final isValid =
                            pinFormKey.currentState?.validate() ?? false;

                        if (isValid) {
                          final pin = int.parse(pinTextEditingController.text);
                          pinTextEditingController.clear();
                          widget.presenter.onUpsertPin.add(pin);
                          pinFocusNode.unfocus();
                        }
                      },
                      child: Text(buttonLabel),
                    ),
                    if (data is AuthenticationEnabled) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          pinTextEditingController.clear();
                          widget.presenter.onDeletePin.add(null);
                          pinFocusNode.unfocus();
                        },
                        child:
                            const Text('Delete pin and remove authentication'),
                      ),
                    ]
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
