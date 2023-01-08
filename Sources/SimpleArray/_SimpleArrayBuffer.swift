/// A class whose instances contains a `Header` and raw
/// storage for an array of `Element`
///
/// `ManagedBuffer` handles all allocations and deallocations of memory automatically
class _SimpleArrayBuffer<Element>: ManagedBuffer<_SimpleArrayBufferHeader, Element> {
    deinit {
        _ = withUnsafeMutablePointers { header, elements in
            elements.deinitialize(count: header.pointee.count)
        }
    }
}

let _emptyArrayStorage = _SimpleArrayBuffer<Void>.create(
    minimumCapacity: 0,
    makingHeaderWith: { _ in
        _SimpleArrayBufferHeader(capacity: 0, count: 0)
    })
