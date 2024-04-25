import 'package:auto_route/auto_route.dart';
import 'package:courtside/app/router/tabs_wrapper_screen.dart';
import 'package:courtside/features/matches/view/matches_screen.dart';
import 'package:courtside/features/news/news.dart';
import 'package:courtside/features/news/news_screen.dart';
import 'package:courtside/features/news/news_single_screen.dart';
import 'package:courtside/features/news/news_wrapper_screen.dart';
import 'package:courtside/features/onboarding/onboarding_screen.dart';
import 'package:courtside/features/puzzles/puzzles.dart';
import 'package:courtside/features/puzzles/puzzles_screen.dart';
import 'package:courtside/features/puzzles/puzzles_solving_screen.dart';
import 'package:courtside/features/settings/privacy_policy_screen.dart';
import 'package:courtside/features/settings/settings_screen.dart';
import 'package:courtside/features/settings/support.dart';
import 'package:courtside/features/settings/terms_of_use_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes {
    final showPromotion = null;
    final isFirstTime = GetIt.I<SharedPreferences>().getBool('ft') ?? true;
    return [
      AutoRoute(page: OnboardingRoute.page, initial: isFirstTime),
      AutoRoute(page: TabWrapperRoute.page, initial: !isFirstTime, children: [
        AutoRoute(page: MatchesRoute.page),
        AutoRoute(page: PuzzlesRoute.page),
        AutoRoute(
          page: NewsWrapperRoute.page,
          children: [
            AutoRoute(page: NewsRoute.page),
            AutoRoute(page: NewsSingleRoute.page),
          ],
        ),
        AutoRoute(page: SettingsRoute.page),
      ]),
      AutoRoute(page: PuzzlesSolvingRoute.page),
      AutoRoute(page: SubscriptionInfoRoute.page),
      AutoRoute(page: PrivacyPolicyRoute.page),
      AutoRoute(page: TermsOfUseRoute.page),
    ];
  }
}
