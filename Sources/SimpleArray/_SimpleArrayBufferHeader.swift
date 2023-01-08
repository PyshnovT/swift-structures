/// Buffer metadata, stored in memory right before the first element
struct _SimpleArrayBufferHeader {
    
    /// Maximum number of elements in the current buffer
    var capacity: Int
    
    /// Length of an array
    var count: Int
    
    init(capacity: Int, count: Int) {
        precondition(capacity >= 0)
        precondition(count >= 0 && count <= capacity)
        self.capacity = capacity
        self.count = count
    }
    
}
