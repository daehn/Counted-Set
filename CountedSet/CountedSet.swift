//
// The MIT License (MIT)
// Copyright 2016 Silvan Dähn
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


public struct CountedSet<Element : Hashable> : ExpressibleByArrayLiteral {

    public typealias ElementWithCount = (element: Element, count: UInt)
    public typealias Index = SetIndex<Element>

    fileprivate var backing = Set<Element>()
    fileprivate var countByHash = [Int: UInt]()

    public mutating func insert(_ member: Element) {
        backing.insert(member)
        let count = countByHash[member.hashValue] ?? 0
        countByHash[member.hashValue] = count + 1
    }

    @discardableResult public mutating func remove(_ member: Element) -> Element? {
        guard var count = countByHash[member.hashValue], count > 0 else { return nil }
        count -= 1
        countByHash[member.hashValue] = Swift.max(count, 0)
        if count <= 0 { backing.remove(member) }
        return member
    }

    public func count(for member: Element) -> UInt? {
        return countByHash[member.hashValue]
    }

    public init(arrayLiteral elements: Element...) {
        elements.forEach { insert($0) }
    }

    public subscript(member: Element) -> UInt? {
        return count(for: member)
    }

    public func mostFrequent() -> ElementWithCount? {
        guard !backing.isEmpty else { return nil }
        return reduce((backing[backing.startIndex], UInt(0))) { max, current in
            guard let count = count(for: current), count > max.1 else { return max }
            return (current, count)
        }
    }

}

// MARK: - Collection

extension CountedSet: Collection {

    public var startIndex: SetIndex<Element> {
        return backing.startIndex
    }

    public var endIndex: SetIndex<Element> {
        return backing.endIndex
    }

    public func index(after i: SetIndex<Element>) -> SetIndex<Element> {
        return backing.index(after: i)
    }

    public subscript(position: SetIndex<Element>) -> Element {
        return backing[position]
    }

    public func makeIterator() -> SetIterator<Element> {
        return backing.makeIterator()
    }

}

// MARK: - Hashable

extension CountedSet: Hashable {

    public var hashValue: Int {
        return backing.hashValue ^ Int(countByHash.values.reduce(0, ^))
    }

}

// MARK: - Equatable Operator

public func ==<Element>(lhs: CountedSet<Element>, rhs: CountedSet<Element>) -> Bool {
    return lhs.backing == rhs.backing && lhs.countByHash == rhs.countByHash
}

// MARK: - CustomStringConvertible

extension CountedSet: CustomStringConvertible {

    public var description: String {
        return backing.reduce("<CountedSet>:\n") { sum, element in
            sum + "\t- \(element) : \(count(for: element)!)x\n"
        }
    }
    
}
