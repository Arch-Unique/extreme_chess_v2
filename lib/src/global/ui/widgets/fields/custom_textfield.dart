import 'package:flutter/material.dart';
import 'package:extreme_chess_v2/src/utils/formatters/num_formatters.dart';
import 'package:icons_plus/icons_plus.dart';
import '/src/src_barrel.dart';

import '../../ui_barrel.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final FPL varl;
  final Color col, iconColor;
  final VoidCallback? onTap, customOnChanged;
  final TextInputAction tia;
  final dynamic suffix;
  final bool autofocus, hasBottomPadding;
  final double fs;
  final FontWeight fw;
  final bool readOnly, shdValidate;
  final TextAlign textAlign;
  final String? oldPass;
  const CustomTextField(this.hint, this.controller,
      {this.varl = FPL.text,
      this.fs = 16,
      this.hasBottomPadding = true,
      this.fw = FontWeight.w300,
      this.col = AppColors.textColor,
      this.iconColor = AppColors.primaryColor,
      this.tia = TextInputAction.next,
      this.oldPass,
      this.onTap,
      this.autofocus = false,
      this.customOnChanged,
      this.readOnly = false,
      this.shdValidate = true,
      this.textAlign = TextAlign.start,
      this.suffix,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool isShow = varl == FPL.password;
    String? vald;
    Color borderCol =
        suffix != null ? AppColors.disabledColor : AppColors.darkTextColor;
    // bool hasTouched = false;

    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: Ui.width(context) - 48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller,
              readOnly: readOnly,
              textAlign: textAlign,
              autofocus: autofocus,
              onChanged: (s) async {
                // if (s.isNotEmpty) {
                //   setState(() {
                //     hasTouched = true;
                //   });
                // } else {
                //   setState(() {
                //     hasTouched = false;
                //   });
                // }
                if (customOnChanged != null) customOnChanged!();
              },
              keyboardType: varl.textType,
              textInputAction: tia,
              maxLines: varl == FPL.multi ? 5 : 1,
              maxLength: varl.maxLength,
              onTap: onTap,
              inputFormatters: [
                if (varl == FPL.cardNo) CreditCardFormatter(),
                if (varl == FPL.money) ThousandsFormatter(),
                // if (varl == FPL.dateExpiry) DateInputFormatter()
              ],
              validator: shdValidate
                  ? (value) {
                      // setState(() {
                      vald = oldPass == null
                          ? Validators.validate(varl, value)
                          : Validators.confirmPasswordValidator(
                              value, oldPass!);

                      //   Future.delayed(const Duration(seconds: 1), () {
                      //     vald = null;
                      //   });
                      // });
                      return vald;
                    }
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(fontSize: fs, fontWeight: fw, color: col),
              obscureText: varl == FPL.password && isShow,
              textAlignVertical:
                  varl == FPL.multi ? TextAlignVertical.top : null,
              decoration: InputDecoration(
                fillColor:
                    suffix != null ? AppColors.white : AppColors.accentColor,
                filled: true,
                enabledBorder: customBorder(color: borderCol),
                focusedBorder: customBorder(color: borderCol),
                border: customBorder(color: borderCol),
                focusedErrorBorder: customBorder(color: AppColors.red),
                counter: SizedBox.shrink(),
                errorStyle: const TextStyle(fontSize: 12, color: AppColors.red),
                errorBorder: customBorder(color: borderCol),
                suffixIconConstraints: suffix != null
                    ? BoxConstraints(minWidth: 24, minHeight: 24)
                    : null,
                isDense: suffix != null,
                suffixIcon: suffix != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: AppIcon(suffix,
                            color:
                                // hasTouched
                                //     ? AppColors.textColor
                                //     :
                                iconColor),
                      )
                    : varl == FPL.password
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isShow = !isShow;
                              });
                            },
                            icon: AppIcon(
                                isShow ? Iconsax.eye_outline : Iconsax.eye_slash_outline,
                                color:
                                    // hasTouched
                                    //     ? AppColors.textColor
                                    //     :
                                    AppColors.disabledColor))
                        : null,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.disabledColor),
              ),
            ),
            SizedBox(
              height: hasBottomPadding ? 24 : 0,
            )
            // vald == null
            //     ? const SizedBox(
            //         height: 24,
            //       )
            //     : Align(
            //         alignment: Alignment.centerLeft,
            //         child: Padding(
            //           padding: EdgeInsets.only(top: 8, bottom: 24),
            //           child: AppText.thin("$vald",
            //               fontSize: 12, color: AppColors.red),
            //         ))
          ],
        ),
      );
    });
  }

  static bool isUserVal(String s) {
    return !(s.isEmpty || s.contains(RegExp(r'[^\w.]')) || s.length < 8);
  }

  OutlineInputBorder customBorder({Color color = AppColors.textColor}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8),
      gapPadding: 8,
    );
  }

  static password(String hint, TextEditingController controller,
      {String? oldPass,
      TextInputAction tia = TextInputAction.done,
      bool hbp = true}) {
    return CustomTextField(
      hint,
      controller,
      tia: tia,
      varl: FPL.password,
      oldPass: oldPass,
      hasBottomPadding: hbp,
    );
  }

  static search(String hint, TextEditingController controller,
      VoidCallback customOnChanged) {
    return CustomTextField(hint, controller,
        hasBottomPadding: false,
        shdValidate: false,
        suffix: Assets.logo,
        customOnChanged: customOnChanged);
  }
}
