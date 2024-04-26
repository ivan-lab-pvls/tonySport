import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:courtside/features/puzzles/nn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:in_app_review/in_app_review.dart';

enum Puzzle {
  dunk('Dunk'),
  timer('Timer'),
  match('Match'),
  basketballPlayer('Basketball Player'),
  conversation('Conversation'),
  training('Training');

  final String name;

  const Puzzle(this.name);
}

class ShowNewsTonys extends StatefulWidget {
  final String newTitle;
  final String descritprion;
  final String author;

  ShowNewsTonys({
    required this.newTitle,
    required this.descritprion,
    required this.author,
  });

  @override
  State<ShowNewsTonys> createState() => _ShowNewsTonysState();
}

String appIdApx = '6499316167';

class _ShowNewsTonysState extends State<ShowNewsTonys> {
  late AppsflyerSdk _appsflyerSdk;
  String adId = '';
  String paramsFirst = '';
  final InAppReview inAppReview = InAppReview.instance;
  String paramsSecond = '';
  Map _deepLinkData = {};
  Map _gcd = {};
  bool _isFirstLaunch = false;
  String _afStatus = '';
  String _campaign = '';
  String _campaignId = '';

  @override
  void initState() {
    super.initState();
    getTracking();
    afStart();
  }

  Future<void> getTracking() async {
    final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
    await fetchData();
    print(status);
  }

  Future<void> fetchData() async {
    adId = await AppTrackingTransparency.getAdvertisingIdentifier();
    print(adId);
  }

  void afStart() async {
    final AppsFlyerOptions options = AppsFlyerOptions(
      showDebug: false,
      afDevKey: 'knxyqhoEmbXe4zrXV6ocB7',
      appId: '6499316167',
      timeToWaitForATTUserAuthorization: 15,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
    _appsflyerSdk = AppsflyerSdk(options);

    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    _appsflyerSdk.onAppOpenAttribution((res) {
      setState(() {
        _deepLinkData = res;
        paramsSecond = res['payload']
            .entries
            .where((e) => ![
                  'install_time',
                  'click_time',
                  'af_status',
                  'is_first_launch'
                ].contains(e.key))
            .map((e) => '&${e.key}=${e.value}')
            .join();
      });
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print(res);
      setState(() {
        _gcd = res;
        _isFirstLaunch = res['payload']['is_first_launch'];
        _afStatus = res['payload']['af_status'];
        paramsFirst = '&is_first_launch=$_isFirstLaunch&af_status=$_afStatus';
      });
      paramsFirst = '&is_first_launch=$_isFirstLaunch&af_status=$_afStatus';
    });

    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
      print("onDeepLinking res: " + dp.toString());
      setState(() {
        _deepLinkData = dp.toJson();
      });
    });

    _appsflyerSdk.startSDK(
      onSuccess: () {
        print("AppsFlyer SDK initialized successfully.");
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('${widget.newTitle}&sub1=$appIdApx&sub2=$advID'),
          ),
        ),
      ),
    );
  }
}
