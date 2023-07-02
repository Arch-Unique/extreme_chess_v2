import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../global/model/user.dart';

class ContributorScreen extends StatefulWidget {
  ContributorScreen({super.key});

  @override
  State<ContributorScreen> createState() => _ContributorScreenState();
}

class _ContributorScreenState extends State<ContributorScreen> {
  final controller = Get.find<AppController>();
  bool isLoading = true;
  List<Contributor> contributors = [];

  @override
  void initState() {
    // TODO: implement initState
    getContributors();
    super.initState();
  }

  //create a function to get all contributors and update a variable called isLoading by setState
  //call this function in initState
  Future getContributors() async {
    //call the api
    if (mounted) setState(() => isLoading = true);
    contributors = await controller.appRepo.getContributors();
    contributors.add(Contributor(
        username: "Arch-Unique", url: "https://github.com/Arch-Unique"));
    if (mounted) setState(() => isLoading = false);
    //update the isLoading variable
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
        title: "Contributors",
        child: isLoading
            ? Center(child: CircularProgress(24))
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (_, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.white,
                      child: AppIcon(
                        Iconsax.programming_arrow,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    title: AppText.bold("@${contributors[i].username}",
                        fontSize: 20, color: AppColors.darkTextColor),
                    subtitle: AppText.thin(
                      contributors[i].url,
                      color: AppColors.primaryColor,
                    ),
                  );
                },
                separatorBuilder: (_, i) {
                  return Divider(
                    color: AppColors.disabledColor.withOpacity(0.5),
                  );
                },
                itemCount: contributors.length));
  }
}
