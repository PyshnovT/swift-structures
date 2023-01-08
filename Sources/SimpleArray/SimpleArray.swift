/// Possible implementation of the `Array` struct in Swift.
///
/// Reversed-engineered from the `Deque` struct in open sourced Swift Collections
struct SimpleArray<Element> {
    
    typealias _Slot = _SimpleArraySlot
    
    var _storage: _Storage
    
    init(_storage: _Storage) {
        self._storage = _storage
    }
    
    /// Creates and empty array with preallocated space for at least the specified
    /// number of elements.
    public init(minimumCapacity: Int) {
        self._storage = _Storage(minimumCapacity: minimumCapacity)
    }
    
}
