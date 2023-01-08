/// Contains index of an element
struct _SimpleArraySlot: Equatable {
    
    let position: Int
    
    init(at position: Int) {
        assert(position >= 0)
        self.position = position
    }
    
}

extension _SimpleArraySlot {
    
    static var zero: Self { Self(at: 0) }
    
    func advanced(by delta: Int) -> Self {
        Self(at: position &+ delta)
    }
    
}

extension _SimpleArraySlot: Comparable {
    
    static func < (lhs: _SimpleArraySlot, rhs: _SimpleArraySlot) -> Bool {
        lhs.position < rhs.position
    }
    
}

extension _SimpleArraySlot: CustomStringConvertible {
    
    var description: String {
        "@\(position)"
    }
    
}
