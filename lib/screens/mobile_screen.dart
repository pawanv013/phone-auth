import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_flutter/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth_flutter/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth_flutter/screens/auth_screen.dart';

class MobileScreen extends StatelessWidget {
  MobileScreen({Key? key}) : super(key: key);

  late final TextEditingController _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In With Phone Number'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                onChanged: (value) {},
                controller: _phoneNumber,
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthCodeSendState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoaddingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                String phoneNumber = '+91' + _phoneNumber.text;
                                BlocProvider.of<AuthCubit>(context)
                                    .sendOtp(phoneNumber);
                              },
                              child: Text('GET OTP'),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
