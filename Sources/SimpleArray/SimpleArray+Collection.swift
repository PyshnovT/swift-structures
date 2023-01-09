extension SimpleArray: Sequence {

    typealias Element = Element
    
    typealias Iterator = IndexingIterator<SimpleArray>

}

extension SimpleArray: RandomAccessCollection {
    
    typealias Index = Int
    
    typealias SubSequence = Slice<SimpleArray>
    
    typealias Indices = Range<Int>
    
    /// The position of the first element in a nonempty array, or `endIndex`
    /// if the array is empty.
    ///
    /// - Complexity: O(1)
    var startIndex: Int { 0 }
    
    /// The collection’s “past the end” position--that is, the position one step
    /// after the last valid subscript argument.
    ///
    /// - Complexity: O(1)
    var endIndex: Int { count }
    
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter `i`: A valid index of the deque. `i` must be less than
    ///    `endIndex`.
    ///
    /// - Returns: The next valid index immediately after `i`.
    ///
    /// - Complexity: O(1)
    func index(after i: Int) -> Int { i + 1 }
    
    /// Replaces the given index with its successor.
    ///
    /// - Parameter `i`: A valid index of the deque. `i` must be less than
    ///    `endIndex`.
    ///
    /// - Complexity: O(1)
    func index(before i: Int) -> Int { i - 1 }
    
    /// The number of elements in the deque.
    ///
    /// - Complexity: O(1)
    public var count: Int { _storage.count }
    
    // TODO: add `_modify` for CoW optimisations
    subscript(position: Int) -> Element {
        get {
            precondition(position >= 0 && position < count, "Index out of bounds")
            return _storage.read { $0.ptr(at: $0.slot(forOffset: position)).pointee }
        }
        set {
            precondition(position >= 0 && position < count, "Index out of bounds")
            // Apply CoW if needed
            _storage.ensureUnique()
            _storage.update { handle in
                let slot = handle.slot(forOffset: position)
                handle.ptr(at: slot).pointee = newValue
            }
        }
    }
    
}
