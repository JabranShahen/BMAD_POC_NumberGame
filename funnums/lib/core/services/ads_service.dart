/// No-op ads service (ads removed from project).
class AdsService {
  Future<void> initialize() async {
    // No ads implementation
  }

  Future<bool> loadInterstitial() async {
    return false;
  }

  Future<void> showInterstitialIfReady() async {
    // No-op
  }
}
