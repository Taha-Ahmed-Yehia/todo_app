
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Data/size_config.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import 'package:flutter_unicons/flutter_unicons.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    if (kDebugMode) {
      print("Screen(W,H) => ${sizeConfig.screenWidth}, ${sizeConfig.screenHeight}");
    }
    return Consumer<AppThemeData>(
      builder: (context, appThemeData, child) => Scaffold(
        backgroundColor: appThemeData.selectedTheme.secondaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topScreen(sizeConfig, appThemeData),
            sizeConfig.screenHeight > 640 ? const Expanded(child: SizedBox()) : SizedBox(height: 50 * sizeConfig.blockSizeVertical,),
            bottomScreen(sizeConfig, appThemeData),
          ],
        ),
      ),
    );
  }

  Widget topScreen(SizeConfig sizeConfig, AppThemeData appThemeData) {
    return SafeArea(
      child: Padding(
                padding: EdgeInsets.all(20 * sizeConfig.blockSmallest),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // welcome text
                    Text(
                        "Login",
                        style: TextStyle(
                          color: appThemeData.selectedTheme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 64 * sizeConfig.blockSmallest,
                        ),
                        textAlign: TextAlign.center
                    ),
                    SizedBox(height: 20 * sizeConfig.blockSizeVertical,),
                    Text(
                      "Hello There, please sign in to continue.",
                      style: TextStyle(color: appThemeData.selectedTheme.textColor.withAlpha(200), fontSize: 24 * sizeConfig.blockSmallest),
                      //textAlign: TextAlign.center
                    )
                  ],
                ),
              ),
    );
  }

  Widget bottomScreen(SizeConfig sizeConfig, AppThemeData appThemeData) {
    return Expanded(
      flex: 2,
      child: Container(
          decoration: BoxDecoration(
              color: appThemeData.selectedTheme.secondaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(100 * sizeConfig.blockSmallest))
          ),
          padding: EdgeInsets.only(top: 100.0 * sizeConfig.blockSmallest,left: 20.0 * sizeConfig.blockSmallest,right: 20.0 * sizeConfig.blockSmallest),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // email text field
              customTextField(sizeConfig, appThemeData, hintText: "Username"),
              SizedBox(height: 10 * sizeConfig.blockSizeVertical),
              // password text field
              customTextField(sizeConfig, appThemeData, hintText: "Phone Number"),
              SizedBox(height: 10 * sizeConfig.blockSizeVertical),
              // sign in button
              signInButton(appThemeData, sizeConfig),
              SizedBox(height: 20 * sizeConfig.blockSizeVertical),
              // sign in with google or facebook or Guest
              orDivider(sizeConfig, appThemeData),
              SizedBox(height: 10 * sizeConfig.blockSizeVertical),
              loginOptions(appThemeData, sizeConfig),
              // not a user "register" now. "" => text button
              registerButton(appThemeData, sizeConfig)
              //
            ],
          )
      ),
    ) ;
  }

  Widget registerButton(AppThemeData appThemeData, SizeConfig sizeConfig) {
    return Row(
              children: [
                Text(
                    "Don't have an account?",
                    style: TextStyle(color: appThemeData.selectedTheme.textDarkColor, fontSize: 18 * sizeConfig.blockSmallest)
                ),
                TextButton(
                    onPressed: (){},
                    child: Text(
                        "Sign Up",
                        style: TextStyle(color: appThemeData.selectedTheme.primaryColor, fontSize: 18 * sizeConfig.blockSmallest, fontWeight: FontWeight.bold)
                    )
                )
              ],
            );
  }

  Widget forgetPasswordButton(AppThemeData appThemeData, SizeConfig sizeConfig) {
    return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: (){

                    },
                    child: Text(
                        "Forgot Password?!",
                        style: TextStyle(color: appThemeData.selectedTheme.textDarkColor.withAlpha(200), fontSize: 18 * sizeConfig.blockSmallest)
                    )
                  ),
              ],
            );
  }

  Widget signInButton(AppThemeData appThemeData, SizeConfig sizeConfig) {
    return Container(
        decoration: BoxDecoration(
            color: appThemeData.selectedTheme.primaryColor,
            borderRadius: BorderRadius.circular(20 * sizeConfig.blockSmallest),
            boxShadow: [
              BoxShadow(
                  color: appThemeData.selectedTheme.primaryLightColor,
                  blurRadius: 6,
                  offset: const Offset(2, 4)
              ),
            ]
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.primaryColor, 
            elevation: 0, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20 * sizeConfig.blockSmallest)),
          ),
          onPressed: (){
            if (kDebugMode) {
              print("Sign In");
            }
          },
          child: Text(
            "Sign in",
            style: TextStyle(color: appThemeData.selectedTheme.textColor, fontWeight: FontWeight.bold, fontSize: 24 * sizeConfig.blockSmallest),
            textAlign: TextAlign.center
        ),
      ),
    );
  }

  Widget loginOptions(AppThemeData appThemeData, SizeConfig sizeConfig) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.secondaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20 * sizeConfig.blockSmallest)),
          ),
          onPressed: (){

          },
          child: Unicon(
            Unicons.uniGoogle,
            color: appThemeData.selectedTheme.primaryColor,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.secondaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20 * sizeConfig.blockSmallest)),
          ),
          onPressed: (){

          },
          child: Unicon(
            Unicons.uniFacebook,
            color: appThemeData.selectedTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget customTextField(SizeConfig sizeConfig, AppThemeData appThemeData, {String hintText = "", bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * sizeConfig.blockSmallest),
      child: Container(
        padding: EdgeInsets.all(5 * sizeConfig.blockSmallest),
        decoration: BoxDecoration(
          color: appThemeData.selectedTheme.primaryLightColor,
          borderRadius: BorderRadius.circular(20 * sizeConfig.blockSmallest),
          boxShadow: [
            BoxShadow(
              color: appThemeData.selectedTheme.primaryColor,
              blurRadius: 4,
              offset: const Offset(2,4)
            ),
          ]
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20 * sizeConfig.blockSmallest, right: 20 * sizeConfig.blockSmallest),
          child: TextField(
            obscureText: isPassword,
            style: TextStyle(
                color: appThemeData.selectedTheme.textDarkColor,
                fontSize: 32 * sizeConfig.blockSmallest
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                  color: appThemeData.selectedTheme.textDarkColor.withAlpha(175),
                  fontSize: 32 * sizeConfig.blockSmallest
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget orDivider(SizeConfig sizeConfig, AppThemeData appThemeData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50 * sizeConfig.blockSmallest),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: appThemeData.selectedTheme.textDarkColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * sizeConfig.blockSmallest),
            child: Text(
              "or",
              style: TextStyle(
                fontSize: 18 * sizeConfig.blockSmallest,
                fontWeight: FontWeight.bold,
                color: appThemeData.selectedTheme.textDarkColor
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: appThemeData.selectedTheme.textDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}