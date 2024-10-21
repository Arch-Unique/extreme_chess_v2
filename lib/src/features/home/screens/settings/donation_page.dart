import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Donate",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
          child: Column(
        children: [
          ListTile(
                    dense: true,
                    onTap: () {
                      launchUrl(Uri.parse("https://buymeacoffee.com/ikennaidigo"));
                    },
                    contentPadding: EdgeInsets.only(left: 32),
                    leading: AppIcon(Iconsax.coffee_outline),
                    title: AppText.thin("Buy Me A Coffe",
                        color: AppColors.darkTextColor.withOpacity(0.5)),
                   
                  ),
                 AppDivider(),
                 AppText.thin("Sponsors will show here")
        ],
      )),
    );
  }
}
