// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Sessions)
final sessionsProvider = SessionsProvider._();

final class SessionsProvider
    extends $NotifierProvider<Sessions, List<Session>> {
  SessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionsHash();

  @$internal
  @override
  Sessions create() => Sessions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Session> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Session>>(value),
    );
  }
}

String _$sessionsHash() => r'edb5f0ba2cafe522d60b40000db070eb3e136153';

abstract class _$Sessions extends $Notifier<List<Session>> {
  List<Session> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Session>, List<Session>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Session>, List<Session>>,
              List<Session>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
