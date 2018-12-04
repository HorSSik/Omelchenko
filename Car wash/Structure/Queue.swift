
import Foundation

public struct Queue<T> {

    fileprivate let list = LinkedList<T>()
    fileprivate let lock = NSLock()

    public mutating func enqueue( _ element: T) {
        lock.lock()
        list.append(element)
        lock.unlock()
    }

    public mutating func dequeue() -> T? {
        lock.lock()
        guard !list.isEmpty, let element = list.first else { return nil }

        let result = list.remove(element)
        lock.unlock()
        
        return result
    }

    public var isEmpty: Bool {
        return list.isEmpty
    }
}
