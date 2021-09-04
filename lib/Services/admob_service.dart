
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{

  Future<InitializationStatus> initialization;
  AdHelper(this.initialization);

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // this is a test ad id
     //  return "ca-app-pub-3940256099942544/6300978111";
      // this is the real one
      return "ca-app-pub-9969110115171102/3091650667";

    } else if (Platform.isIOS) {
      return "<>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }


  AdListener get adListener => _adListener;

  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print ('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAppEvent: (ad, name,data) =>
        print('App event : ${ad.adUnitId}, $name,$data.'),
    onApplicationExit:  (ad) => print('App Exit: ${ad.adUnitId}.'),
    onNativeAdClicked: (nativeAd) =>
        print('Native ad clicked: ${nativeAd.adUnitId}.'),
    onNativeAdImpression: (nativeAd) =>
        print('Native ad impression: ${nativeAd.adUnitId}.'),
    onRewardedAdUserEarnedReward: (ad, reward) =>
        print(
            'user rewarded: ${ad.adUnitId},${reward.amount} ${reward.type}.'),
  );


}
