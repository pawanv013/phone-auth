import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_flutter/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth_flutter/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth_flutter/screens/mobile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Home Page',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            Row(
              children: [
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoggedOutState) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileScreen(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: Text('LOGOUT'),
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).signOut();
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
