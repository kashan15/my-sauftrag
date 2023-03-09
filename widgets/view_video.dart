import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:stacked/stacked.dart';

import '../app/locator.dart';
import '../utils/color_utils.dart';
import '../utils/dimensions.dart';
import '../utils/font_utils.dart';
import '../utils/image_utils.dart';
import '../viewModels/main_view_model.dart';

class ViewVideo extends StatefulWidget {
  final String? url;
  const ViewVideo({Key? key,this.url}) : super(key: key);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {

      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                    child: BetterPlayer.network(
                      widget.url!,
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        autoDetectFullscreenAspectRatio: true,
                        fit: BoxFit.contain,
                        aspectRatio: 9/16,
                        autoPlay: true,
                      ),
                    )
                ),
              ),
              Positioned(
                left: 0,
                right: 43.h,
                top: 0,
                bottom: 80.h,
                child: IconButton(
                    onPressed: () {
                      model.navigateBack();
                      model.channelMetaDataDetails = null;
                    },
                    iconSize: 18.0,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: ColorUtils.white,
                      size: 4.5.i,
                    )),
              ),

            ],
          ),
        )
        ;
      },
    );
  }
}
