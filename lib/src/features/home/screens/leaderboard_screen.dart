import 'package:cached_network_image/cached_network_image.dart';
import 'package:extreme_chess_v2/src/features/home/repos/app_repo.dart';
import 'package:extreme_chess_v2/src/global/model/barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../src_barrel.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  bool isLoading = true;
  final appRepo = Get.find<AppRepo>();
  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    setLeaderBoard();
    super.initState();
  }

  setLeaderBoard() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    users = await appRepo.getLeaderboard();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "LeaderBoard",
      child: isLoading
          ? Center(child: CircularProgress(48))
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 24),
              itemBuilder: (_, i) {
                final user = users[i];
                final isUser =
                    user.id == appRepo.appService.currentUser.value.id;
                return Row(
                  children: [
                    Ui.boxWidth(24),
                    SizedBox(
                      width: Ui.width(context) / 7,
                      child: AppText.bold((i + 1).toString(),
                          // fontFamily: "Roboto",
                          fontSize: 24,
                          color: isUser
                              ? AppColors.primaryColor
                              : AppColors.darkTextColor.withOpacity(0.5)),
                    ),
                    Ui.boxWidth(24),
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: CachedNetworkImageProvider(user.image),
                    ),
                    Ui.boxWidth(24),
                    AppText.thin(user.username.capitalizeFirst!,
                        color: isUser
                            ? AppColors.primaryColor
                            : AppColors.darkTextColor),
                    Spacer(),
                    AppText.bold(user.elo.toString(),
                        // fontFamily: "Roboto",
                        fontSize: 20,
                        color: isUser
                            ? AppColors.primaryColor
                            : AppColors.darkTextColor.withOpacity(0.5)),
                    Ui.boxWidth(24),
                  ],
                );
              },
              separatorBuilder: (_, i) {
                return AppDivider();
              },
              itemCount: users.length),
    );
  }
}
