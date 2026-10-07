enum SubscriptionPlan {
  free,
  trial,
  premium,
}

class SubscriptionService {
  SubscriptionPlan _plan = SubscriptionPlan.free;
  DateTime? _expiryDate;

  SubscriptionPlan get plan => _plan;
  DateTime? get expiryDate => _expiryDate;

  bool get isPremium =>
      _plan == SubscriptionPlan.premium ||
      _plan == SubscriptionPlan.trial;

  void setPlan(
    SubscriptionPlan plan, {
    DateTime? expiryDate,
  }) {
    _plan = plan;
    _expiryDate = expiryDate;
  }

  void clear() {
    _plan = SubscriptionPlan.free;
    _expiryDate = null;
  }
}
