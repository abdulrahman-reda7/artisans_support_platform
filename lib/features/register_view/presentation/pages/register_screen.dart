import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/Custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_text_form_field.dart';
import 'package:support_local_artisans/core/utils/dialogs.dart';
import 'package:support_local_artisans/core/utils/validators.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_states.dart';
import '../../../../config/routes_manager/routes.dart';
import '../../domain/entities/RegisterResponseEntity.dart';
import '../manager/cubit/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel viewModel = getIt<RegisterScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedUserType = 'client';
  RegisterResponseEntity state = RegisterResponseEntity();
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterScreenViewModel, RegisterStates>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          DialogUtils.showLoadingDialog(context, message: "Loading....");
        } else if (state is RegisterErrorState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: state.failures.errorMessage,
            posButtonTitle: "ok",
          );
        } else if (state is RegisterSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: "Register Successfully.",
            posButtonTitle: "Ok",
            posButtonAction: () {
              Navigator.pushReplacementNamed(context, Routes.homeRoute);
            },
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xffF8F0EC),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0E0705),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'create an account to start your journey.',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff9D9896),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomLabelTextField(label: "Full Name"),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _person_3.0x.png"),
                      hint: "Enter your full name",
                      keyboardType: TextInputType.text,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        return null;
                      },
                      controller: viewModel.nameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomLabelTextField(label: "Mobile Number"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      hint: "Enter phone number",
                      keyboardType: TextInputType.number,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.isValidEgyptianPhoneNumber(text);
                        return null;
                      },
                      controller: viewModel.phoneController,
                      prefixIcon: const Icon(
                        Icons.mobile_friendly,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomLabelTextField(label: "Email Address"),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.validateEmail(text);
                        //return null;
                      },
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomLabelTextField(label: "Password"),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.validatePassword(text);
                        return null;
                      },
                      controller: viewModel.passwordController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomLabelTextField(label: "Confirm Password"),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.isEmpty) {
                          if (text.trim().isEmpty) {
                            return "this field is required";
                          }
                          return "Please enter password";
                        }
                        if (viewModel.passwordController.text != text) {
                          return "Password doesn't match";
                        }
                        return null;
                      },
                      controller: viewModel.confirmPasswordController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUserTypeCard(
                            bc: const Color(0xffEDD3CA),
                            'client',
                            'assets/images/3.0x/Group_3.0x.png'),
                        const SizedBox(width: 10),
                        _buildUserTypeCard(
                            bc: const Color(0xffDDDAD9),
                            'seller',
                            'assets/images/3.0x/Character_3.0x.png'),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String roleToSend = selectedUserType == "client"
                                  ? "User"
                                  : "Artisan";
                              viewModel.register(Role: roleToSend);
                              // ✅ ضيفه هنا
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8C4931),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'sign up',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffEEEDEC)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF9D9896)),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.loginRoute);
                          },
                          child: Text(
                            "log in",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontFamily: "Roboto",
                                  color: const Color(0xff8C4931),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(String type, String imagePath,
      {required Color bc}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserType = type;
        });
      },
      child: Container(
        width: 160,
        height: 165,
        //padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        decoration: BoxDecoration(
          color: bc,
          // color: selectedUserType == type
          //     ? Colors.brown.shade600
          //     : Color(0xffDDDAD9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: Radio<String>(
                    value: type,
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = value!;
                      });
                    },
                    activeColor: const Color(0xff8C4931),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45.0, left: 7),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0E0705),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(imagePath, height: 175),
          ],
        ),
      ),
    );
  }
}
