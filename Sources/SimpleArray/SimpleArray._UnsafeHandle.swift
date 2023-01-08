extension SimpleArray {
    
    /// An abstraction over buffer for unsafe mutations.
    ///
    /// Both storage and buffer don't have API for mutations.
    /// All mutations are performed using this "handle".
    struct _UnsafeHandle {
        let _header: UnsafeMutablePointer<_SimpleArrayBufferHeader>
        
        let _elements: UnsafeMutablePointer<Element>
        
        #if DEBUG
        /// Used only in debugging to check for undesired mutations.
        /// In reality, there is no difference between mutable and nonmutable storages.
        let _isMutable: Bool
        #endif
        
        init(
            header: UnsafeMutablePointer<_SimpleArrayBufferHeader>,
            elements: UnsafeMutablePointer<Element>,
            isMutable: Bool = false
        ) {
            self._header = header
            self._elements = elements
            #if DEBUG
            self._isMutable = isMutable
            #endif
        }
    }
    
}

extension SimpleArray._UnsafeHandle {
    
    typealias Slot = _SimpleArraySlot
    
    var header: _SimpleArrayBufferHeader {
        _header.pointee
    }
    
    var count: Int {
        get { _header.pointee.count }
        nonmutating set { _header.pointee.count = newValue }
    }
    
    var capacity: Int {
        _header.pointee.capacity
    }
    
    var startSlot: Slot {
        Slot(at: 0)
    }
    
    func ptr(at slot: Slot) -> UnsafeMutablePointer<Element> {
        assert(slot.position >= 0 && slot.position <= capacity)
        return _elements + slot.position
    }
    
    func slot(forOffset offset: Int) -> Slot {
      assert(offset >= 0)
      assert(offset <= capacity) // Not `count`!

      let position = startSlot.position &+ offset
      guard position < capacity else { return Slot(at: position &- capacity) }
      return Slot(at: position)
    }
    
}

extension SimpleArray._UnsafeHandle {
        
    @discardableResult
    func initialize(from source: UnsafeBufferPointer<Element>) -> Slot {
        ptr(at: startSlot).initialize(from: source.baseAddress!, count: source.count)
        return Slot(at: source.count)
    }
    
}

extension SimpleArray._UnsafeHandle {
    
    func copyElements() -> SimpleArray._Storage {
        let object = _SimpleArrayBuffer<Element>.create(
            minimumCapacity: capacity,
            makingHeaderWith: { _ in header })
        
        let result = SimpleArray._Storage(_buffer: ManagedBufferPointer(unsafeBufferObject: object))
        
        guard count > 0 else { return result }
        
        result.update { target in
            let startPtr = self.ptr(at: startSlot)
            target.initialize(from: UnsafeBufferPointer<Element>(start: startPtr, count: self.count))
        }
        
        return result
    }
    
}
