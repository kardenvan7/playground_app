import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuthButtonScreen extends StatelessWidget {
  const LocalAuthButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: const LocalAuthButton(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class LocalAuthButton extends StatelessWidget {
  const LocalAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final auth = LocalAuthentication();
        final avB = await auth.getAvailableBiometrics();

        debugPrint('Available biometrics: $avB');

        await auth.authenticate(
          localizedReason: 'Localized Reason',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      },
      child: const Text('Local Auth'),
    );
  }
}
