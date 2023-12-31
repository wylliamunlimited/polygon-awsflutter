import 'package:amplify_core/amplify_core.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:polygon/common/navigation/routes.dart';
import 'package:polygon/common/ui/inputfields/basic_inputfield_v1.dart';
import 'package:polygon/common/utils/animation/shake_widget.dart';
import 'package:polygon/common/utils/validation/input_field_validator.dart';
import 'package:polygon/common/utils/enum_constants/specific_field_val.dart';
import 'package:polygon/features/auth/controllers/auth_controller.dart';
import 'package:polygon/features/auth/ui/model/signup_steps.dart';
import 'package:polygon/features/auth/ui/components/verify_dialog.dart';

class SignUpPage extends StatefulHookConsumerWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _signUpPageState();
}

class _signUpPageState extends ConsumerState<SignUpPage> {
  // NOTE: custom loading
  // bool _loading = false;
  double currentPagePosition = 0;

  String currentPhoneNum = '';
  String currentEmail = '';
  String currentPassword = '';
  String currentFirstName = '';
  String currentLastName = '';
  String currentNickname = '';
  String currentConfirmPassword = '';
  String currentVerifyCode = '';

  final String emailErrorText = 'Invalid email :(';
  final String passwordErrorText = 'Invalid password :(';
  final String confirmPasswordErrorText =
      'Password re-entry does not match the password you made :(';
  final String firstNameErrorText = 'Invalid first name :(';
  final String lastNameErrorText = 'Invalid last name :(';
  final String nicknameErrorText = 'Invalid nickname :(';
  final String phoneNumErrorText = 'Invalid phone number :(';

  late bool emailError = false;
  late bool passwordError = false;
  late bool confirmPasswordError = false;
  late bool firstNameError = false;
  late bool lastNameError = false;
  late bool nicknameError = false;

  final GlobalKey<ShakeWidgetState> emailShakeText =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> passwordShakeText =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> confirmPasswordShakeText =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> firstNameShakeText =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> lastNameShakeText =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> nicknameShakeText =
      GlobalKey<ShakeWidgetState>();

  final PageController _pageController = PageController();

  TextEditingController phoneNumController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  late BasicInputFieldV1 emailField;
  late BasicInputFieldV1 passwordField;
  late BasicInputFieldV1 confirmPasswordField;
  late IntlPhoneField phoneField = const IntlPhoneField();
  late BasicInputFieldV1 firstNameField;
  late BasicInputFieldV1 lastNameField;
  late BasicInputFieldV1 nickNameField;
  late BasicInputFieldV1 verifyField;

  // NOTE: FUTURE IMPROVEMENTS VALIDATION CHECKER ICON SHOWING
  // late AnimatedChecker emailChecker;
  // late AnimatedChecker passwordChecker;
  // late AnimatedChecker confirmPasswordChecker;
  // late AnimatedChecker phoneNumChecker;
  // late AnimatedChecker firstNameChecker;
  // late AnimatedChecker lastNameChecker;
  // late AnimatedChecker nickNameChecker;

  late SignUpStep phoneNumStep;
  late SignUpStep emailStep;
  late SignUpStep passwordStep;
  late SignUpStep confirmPasswordStep;
  late SignUpStep namingStep;

  late VerifyDialog confirmSignUpDialog;

  late SignUpStep confirmationStep;

  // NOTE: FUTURE IMPROVEMENTS animated textview
  // late FormFieldV1 phoneNumField;
  // late FormFieldV1 emailField;
  // late FormFieldV1 passwordField;
  // late FormFieldV1 confirmPasswordField;

  @override
  void initState() {
    // NOTE: FUTURE IMPROVEMENTS animated textview
    // phoneNumField = FormFieldV1(
    //   formFade: false,
    //   formFieldController: phoneNumController,
    //   formHintText: "Phone Number",
    // );
    // emailField = FormFieldV1(
    //   formFade: false,
    //   formFieldController: emailController,
    //   formHintText: "Email",
    // );
    // passwordField = FormFieldV1(
    //   formFade: false,
    //   formFieldController: passwordController,
    //   formHintText: "Password",
    // );
    // confirmPasswordField = FormFieldV1(
    //   formFade: false,
    //   formFieldController: confirmPasswordController,
    //   formHintText: "Password",
    // );

    emailField = BasicInputFieldV1(
      textController: emailController,
      labelText: "Email",
      specificFieldValueType: SpecificFieldValueType.email,
      onTextChanged: (value) async {
        // PENDING
        // setState(() {
        //   emailError = false;
        // });
        onEmailChange(value!);
      },
    );
    passwordField = BasicInputFieldV1(
      textController: passwordController,
      specificFieldValueType: SpecificFieldValueType.password,
      labelText: "Password",
      onTextChanged: (value) {
        // PENDING
        // setState(() {
        //   passwordError = false;
        // });
        onPasswordChange(value!);
      },
    );
    confirmPasswordField = BasicInputFieldV1(
      textController: confirmPasswordController,
      labelText: "Confirm Password",
      onTextChanged: (value) {
        // PENDING
        // setState(() {
        //   confirmPasswordError = false;
        // });
        onConfirmPasswordChange(value!);
      },
    );
    phoneField = IntlPhoneField(
      onChanged: (value) async {
        currentPhoneNum = value.completeNumber;
      },
      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(
          backgroundColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelText: "Phone Number",
        filled: true,
        fillColor: const Color.fromARGB(95, 233, 233, 233),
        labelStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
          // borderSide: BorderSide.none,
        ),
      ),
      controller: phoneNumController,
    );
    firstNameField = BasicInputFieldV1(
      textController: firstNameController,
      width: 120,
      specificFieldValueType: SpecificFieldValueType.name,
      labelText: "First Name",
      onTextChanged: (value) {
        // PENDING
        // setState(() {
        //   firstNameError = false;
        // });
        onFirstNameChange(value!);
      },
    );
    lastNameField = BasicInputFieldV1(
      textController: lastNameController,
      width: 120,
      specificFieldValueType: SpecificFieldValueType.name,
      labelText: "Last Name",
      onTextChanged: (value) {
        // PENDING
        // setState(() {
        //   lastNameError = false;
        // });
        onLastNameChange(value!);
      },
    );
    nickNameField = BasicInputFieldV1(
      textController: nickNameController,
      labelText: "Nickname (Optional)",
      specificFieldValueType: SpecificFieldValueType.nickname,
      onTextChanged: (value) {
        // PENDING
        // setState(() {
        //   nicknameError = false;
        // });
        onNickNameChange(value!);
      },
    );

    // NOTE: verify input dialog
    confirmSignUpDialog = VerifyDialog(
      verifyController: verifyController,
      username: emailController.text,
      onConfirm: (code, ctx) async {
        final confirmResult = await ref
            .read(authControllerProvider)
            .confirmUser(emailController.text, code);
        if (confirmResult != null) {
          if (confirmResult.nextStep.signUpStep == AuthSignUpStep.done &&
              confirmResult.isSignUpComplete) {
            if (ctx.mounted && context.mounted) {
              ctx.pop();
              context.goNamed(PolygonRoute.home.name);
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Verification failed."),
                ),
              );
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Verification failed."),
              ),
            );
          }
        }
      },
    );

    // NOTE: FUTURE IMPROVEMENTS VALIDATION CHECKER ICON SHOWING
    // emailChecker = AnimatedChecker();
    // passwordChecker = AnimatedChecker();
    // confirmPasswordChecker = AnimatedChecker();
    // phoneNumChecker = AnimatedChecker();
    // firstNameChecker = AnimatedChecker();
    // lastNameChecker = AnimatedChecker();
    // nickNameChecker = AnimatedChecker();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    phoneNumStep = SignUpStep(
      children: [
        Text(
          'Phone Number',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Text(
          'Polygon uses phone number for real time communications.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: Stack(
            children: [
              phoneField,
            ],
          ),
        ),
      ],
    );
    emailStep = SignUpStep(
      children: [
        Text(
          'Email',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Text(
          'Polygon also uses email as an backup for account security.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: Stack(
            children: [
              emailField,
            ],
          ),
        ),
        // PENDING
        // if (emailError)
        //   ShakeWidget(
        //     key: emailShakeText,
        //     shakeCount: 3,
        //     shakeOffset: 10,
        //     shakeDuration: Duration(milliseconds: 400),
        //     child: Text(
        //       emailErrorText,
        //       style: TextStyle(color: Colors.red),
        //     ),
        //   ),
      ],
    );
    passwordStep = SignUpStep(
      children: [
        Text(
          'Account Password',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Text(
          'Customize your own password, and let your experience be secured.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: Column(
            children: [
              passwordField,
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Requirements:",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "1. Password contains at least 6 characters. \n2. Password contains at least one uppercase alphabet. \n3. Password contains at least one lowercase alphabet. \n4. Password contains at least one special character among the followings: @ # % & : _ ~",
              )
            ],
          ),
        ),
        // PENDING
        // if (passwordError)
        //   ShakeWidget(
        //     key: passwordShakeText,
        //     shakeCount: 3,
        //     shakeOffset: 10,
        //     shakeDuration: Duration(milliseconds: 400),
        //     child: Text(passwordErrorText),
        //   ),
      ],
    );
    confirmPasswordStep = SignUpStep(
      children: [
        Text(
          'Password Confirmation',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Text(
          'Make sure you remember the password to enhance security.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: Stack(
            children: [
              confirmPasswordField,
            ],
          ),
        ),
        // PENDING
        // if (confirmPasswordError)
        //   ShakeWidget(
        //     key: confirmPasswordShakeText,
        //     shakeCount: 3,
        //     shakeOffset: 10,
        //     shakeDuration: Duration(milliseconds: 400),
        //     child: Text(confirmPasswordErrorText),
        //   ),
      ],
    );
    namingStep = SignUpStep(
      children: [
        Text(
          'How should we call you?',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Text(
          'Let us know about you a bit :)',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    firstNameField,
                    // PENDING
                    // if (firstNameError)
                    //   ShakeWidget(
                    //     key: firstNameShakeText,
                    //     shakeCount: 3,
                    //     shakeOffset: 10,
                    //     shakeDuration: Duration(milliseconds: 400),
                    //     child: Text(firstNameErrorText),
                    //   ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    lastNameField,
                    // PENDING
                    // if (lastNameError)
                    //   ShakeWidget(
                    //     key: lastNameShakeText,
                    //     shakeCount: 3,
                    //     shakeOffset: 10,
                    //     shakeDuration: Duration(milliseconds: 400),
                    //     child: Text(lastNameErrorText),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              nickNameField,
              // PENDING
              // if (nicknameError)
              //   ShakeWidget(
              //     key: nicknameShakeText,
              //     shakeCount: 3,
              //     shakeOffset: 10,
              //     shakeDuration: Duration(milliseconds: 400),
              //     child: Text(nicknameErrorText),
              //   ),
            ],
          ),
        ),
      ],
    );

    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: null,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Stack(
                children: [
                  PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentPagePosition = value.toDouble();
                      });
                    },
                    children: [
                      // NOTE: onboarding widgets
                      phoneNumStep,
                      emailStep,
                      passwordStep,
                      confirmPasswordStep,
                      namingStep,
                    ],
                  ),
                  // NOTE: DOTS
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: DotsIndicator(
                        // Shows the user their progress
                        dotsCount: 5,
                        position: currentPagePosition,
                        decorator: DotsDecorator(
                          size: const Size.square(9.0),
                          activeSize: const Size(18.0, 9.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                  ),
                  // NOTE: BACK PAGE
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        onPressed: currentPagePosition != 0
                            ? previousPage
                            : () {
                                context.pop();
                              },
                        child: currentPagePosition != 0
                            ? const Text("Back")
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  // NOTE: CANCEL
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.goNamed(PolygonRoute.signin.name);
                      },
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.cancel),
                        ),
                      ),
                    ),
                  ),
                  // NOTE: NEXT PAGE
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: currentPagePosition != 4
                            ? nextPage
                            : () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showLoading();
                                signUp().then((value) {
                                  hideLoading();
                                });
                              },
                        child: currentPagePosition != 4
                            ? const Text("Next")
                            : const Text("Sign Up"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> validateAllInput() async {
    if (await validateInput(
            SpecificFieldValueType.phonenumber, currentPhoneNum) ==
        false) {
      animateToPage(0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(phoneNumErrorText),
        ),
      );
      return false;
    } else if (await validateInput(
            SpecificFieldValueType.email, currentEmail) ==
        false) {
      animateToPage(1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailErrorText),
        ),
      );
      return false;
    } else if (await validateInput(
            SpecificFieldValueType.password, currentPassword) ==
        false) {
      animateToPage(2);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordErrorText),
        ),
      );
      return false;
    } else if (currentConfirmPassword != currentPassword) {
      animateToPage(3);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmPasswordErrorText),
        ),
      );
      return false;
    } else if (await validateInput(
            SpecificFieldValueType.name, currentFirstName) ==
        false) {
      animateToPage(4);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firstNameErrorText),
        ),
      );
      return false;
    } else if (await validateInput(
            SpecificFieldValueType.name, currentLastName) ==
        false) {
      animateToPage(4);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lastNameErrorText),
        ),
      );
      return false;
    } else if (await validateInput(
            SpecificFieldValueType.nickname, currentNickname) ==
        false) {
      animateToPage(4);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nicknameErrorText),
        ),
      );
      return false;
    }
    return true;
  }

  // NOTE: ERROR TEXT
  // void shakeErrorText(int index) {
  //   switch (index) {
  //     case 0:
  //       // NOTE: PHONE NUMBER PAGE
  //       break;
  //     case 1:
  //       // NOTE: EMAIL PAGE
  //       emailShakeText.currentState?.shake();
  //       break;
  //     case 2:
  //       // NOTE: PASSWORD PAGE
  //       passwordShakeText.currentState?.shake();
  //       break;
  //     case 3:
  //       // NOTE: CONFIRM PASSWORD PAGE
  //       confirmPasswordShakeText.currentState?.shake();
  //       break;
  //     case 4:
  //       // NOTE: NAME PAGE
  //       firstNameShakeText.currentState?.shake();
  //       lastNameShakeText.currentState?.shake();
  //       nicknameShakeText.currentState?.shake();
  //       break;
  //   }
  // }

  void onPasswordChange(String password) async {
    setState(() {
      currentPassword = password;
    });
  }

  void onEmailChange(String email) async {
    setState(() {
      currentEmail = email;
    });
  }

  void onConfirmPasswordChange(String confirmPassword) {
    setState(() {
      currentConfirmPassword = confirmPassword;
    });
  }

  void onFirstNameChange(String firstName) {
    setState(() {
      currentFirstName = firstName;
    });
  }

  void onLastNameChange(String lastName) {
    setState(() {
      currentLastName = lastName;
    });
  }

  void onNickNameChange(String nickname) {
    setState(() {
      currentNickname = nickname;
    });
  }

  Future<SignUpResult?> signUp() async {
    final SignUpResult? result;

    if (await validateAllInput()) {
      result = await ref.read(authControllerProvider).signUp(
            email: emailController.text,
            password: passwordController.text,
            phoneNum: currentPhoneNum,
            givenName: currentFirstName,
            lastName: currentLastName,
            nickname: currentNickname,
          );
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "The sign up information might already be used. \nTry logging in or retrieve password by recovery."),
          ),
        );
      }
    } else {
      result = null;
    }

    if (result != null) {
      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        showDialog(
          context: context,
          builder: (context) => confirmSignUpDialog,
        );
      }
    }

    return result;
  }

  void showLoading() {
    if (context.mounted) {
      context.loaderOverlay.show();
    }
    // NOTE: for customize loading screen
    // setState(() {
    //   _loading = true;
    // });
  }

  void hideLoading() {
    if (context.mounted) {
      context.loaderOverlay.hide();
    }

    // NOTE: for customize loading screen
    // setState(() {
    //   _loading = false;
    // });
  }

  void nextPage() {
    _pageController.animateToPage(
      currentPagePosition.toInt() + 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void previousPage() {
    _pageController.animateToPage(
      currentPagePosition.toInt() - 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
