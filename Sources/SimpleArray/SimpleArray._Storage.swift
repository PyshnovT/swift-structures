extension SimpleArray {
    
    /// A class whose instance contains a reference to `ManagedBuffer`
    struct _Storage {
        
        typealias _Buffer = ManagedBufferPointer<_SimpleArrayBufferHeader, Element>
        
        var _buffer: _Buffer
        
        init(_buffer: _Buffer) {
            self._buffer = _buffer
        }
        
    }
    
}

extension SimpleArray._Storage: CustomStringConvertible {
    
    var description: String {
        "SimpleArray<\(Element.self)>._Storage\(_buffer.header)"
    }
    
}

extension SimpleArray._Storage {
    
    init(minimumCapacity: Int) {
        let object = _SimpleArrayBuffer<Element>.create(
            minimumCapacity: minimumCapacity,
            makingHeaderWith: {
                _SimpleArrayBufferHeader(capacity: $0.capacity, count: 0)
            })
        self.init(_buffer: _Buffer(unsafeBufferObject: object))
    }
    
}

extension SimpleArray._Storage {
    
    typealias _UnsafeHandle = SimpleArray._UnsafeHandle
    
    func read<R>(_ body: (_UnsafeHandle) throws -> R) rethrows -> R {
        try _buffer.withUnsafeMutablePointers({ header, elements in
            let handle = _UnsafeHandle(header: header,
                                       elements: elements,
                                       isMutable: false)
            return try body(handle)
        })
    }
    
    func update<R>(_ body: (_UnsafeHandle) throws -> R) rethrows -> R {
        try _buffer.withUnsafeMutablePointers({ header, elements in
            let handle = _UnsafeHandle(header: header,
                                       elements: elements,
                                       isMutable: true)
            return try body(handle)
        })
    }
    
}

extension SimpleArray._Storage {
    
    /// Return a boolean indicating whether this storage instance is known to have
    /// a single unique reference. If this method returns true, then it is safe to
    /// perform in-place mutations on the array.
    mutating func isUnique() -> Bool {
        _buffer.isUniqueReference()
    }
    
    /// Ensure that this storage refers to a uniquely held buffer by copying
    /// elements if necessary.
    mutating func ensureUnique() {
        guard !isUnique() else { return }
        _makeUniqueCopy()
    }
    
    mutating func _makeUniqueCopy() {
        self = read { $0.copyElements() }
    }
    
    /// The growth factor to use to increase storage size to make place for an
    /// insertion.
    static var growthFactor: Double { 1.5 }
    
}
