import 'dart:collection';

class CacheEntry<V> {
  final V value;
  final DateTime expiresAt;
  CacheEntry(this.value, this.expiresAt);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

abstract class Cache<K, V> {
  V? get(K key);
  void set(K key, V value, {Duration? ttl});
  void invalidate(K key);
  void clear();
}

class MemoryCache<K, V> implements Cache<K, V> {
  final Map<K, CacheEntry<V>> _store = HashMap();
  final Duration defaultTtl;

  MemoryCache({this.defaultTtl = const Duration(minutes: 30)});

  @override
  V? get(K key) {
    final e = _store[key];
    if (e == null) return null;
    if (e.isExpired) {
      _store.remove(key);
      return null;
    }
    return e.value;
  }

  @override
  void set(K key, V value, {Duration? ttl}) {
    final t = ttl ?? defaultTtl;
    _store[key] = CacheEntry(value, DateTime.now().add(t));
  }

  @override
  void invalidate(K key) => _store.remove(key);

  @override
  void clear() => _store.clear();
}
