import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoWebViewPage extends StatefulWidget {
  final String url;

  const VideoWebViewPage({super.key, required this.url});

  @override
  State<VideoWebViewPage> createState() => _VideoWebViewPageState();
}

class _VideoWebViewPageState extends State<VideoWebViewPage> {
  late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;  
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _progress = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _progress = 1.0;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final showProgress = _progress < 1.0;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appBGColor),
        forceMaterialTransparency: true,
        title: Text(
          'Video Preview',
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.appBGColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: _controller)),

          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: showProgress ? 0 : -5,
            left: 0,
            right: 0,
            height: showProgress ? 3 : 0,

            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: showProgress ? 1 : 0,
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 3,
                color: AppColors.whiteColor,
                backgroundColor: Colors.black12,
              ),
            ),
          ),

          // WebView itself
        ],
      ),
    );
  }
}
