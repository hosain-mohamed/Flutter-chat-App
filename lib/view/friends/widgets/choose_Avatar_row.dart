import 'package:chat/models/user.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/friends/widgets/choose_avatar_icon.dart';
import 'package:flutter/material.dart';

typedef void OnAvatarSelected(String avatarPath);

class ChooseAvatarRow extends StatefulWidget {
  final User user;
  final OnAvatarSelected onAvatarSelected;
  ChooseAvatarRow({
    Key key,
    @required this.user,
    @required this.onAvatarSelected,
  }) : super(key: key);
  @override
  _ChooseAvatarRowState createState() => _ChooseAvatarRowState();
}

class _ChooseAvatarRowState extends State<ChooseAvatarRow> {
  int selectedIndex = -1;
  List<String> imagesPaths;

  @override
  void didUpdateWidget(ChooseAvatarRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _generateAvatarIcons(selectedIndex),
    );
  }

  List<Widget> _generateAvatarIcons(int selectedIndexParameter) {
    if (imagesPaths == null) {
      imagesPaths = Functions.getAvatarsPaths();
      imagesPaths.shuffle();
    }
    List<String> modifiedImagesPaths;
    if (widget.user.imageType == ImageType.assets) {
      modifiedImagesPaths = imagesPaths
          .where((element) => element != widget.user.imgUrl)
          .toList();
    } else {
      modifiedImagesPaths = imagesPaths;
    }
    int maxAvatarCount = 3;
    if (modifiedImagesPaths.length <= 3) {
      maxAvatarCount = modifiedImagesPaths.length;
    }
    modifiedImagesPaths =
        modifiedImagesPaths.getRange(0, maxAvatarCount).toList();

    List<Widget> icons = [];
    for (int i = 0; i < modifiedImagesPaths.length; i++) {
      icons.add(ChooseAvatarIcon(
        imagePath: modifiedImagesPaths[i],
        avatarIndex: i,
        onSelect: () {
          setState(() {
            if (selectedIndex == i) {
              selectedIndex = -1;
            } else {
              selectedIndex = i;
            }
          });
          if (selectedIndex == -1) {
            widget.onAvatarSelected(null);
          } else {
            widget.onAvatarSelected(modifiedImagesPaths[i]);
          }
        },
        selectedIndex: selectedIndexParameter,
      ));
    }
    return icons;
  }
}
