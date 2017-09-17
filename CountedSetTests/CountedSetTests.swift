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


import XCTest
@testable import CountedSet

class CountedSetTests: XCTestCase {

    var sut: CountedSet<String>!

    override func setUp() {
        super.setUp()
        sut = CountedSet<String>()
    }

    func testThatItAddsElementsToTheSetAndSetsTheCorrectCount() {
        // when
        sut.insert("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 1)
    }

    func testThatItIncreasesTheCountWhenAddingAnElementMultipleTimes() {
        // when
        sut.insert("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 1)
        // when
        sut.insert("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 2)
        // when
        sut.insert("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 3)
    }

    func testThatItReturnsZeroAsElementCountForElementsNotInTheSet() {
        XCTAssertEqual(sut.count(for: "Hello"), 0)
    }

    func testThatItDecreasesTheCountWhenAddingAnElementMultipleTimes() {
        // given
        sut = CountedSet(arrayLiteral: "Hello", "Hello")
        XCTAssertEqual(sut.count(for: "Hello"), 2)

        // when
        sut.remove("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 1)
        // when
        sut.remove("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 0)
    }

    func testThatItDoesNotDecreaseTheCountIfAlreadyZero() {
        // given
        sut = CountedSet(arrayLiteral: "Hello")
        XCTAssertEqual(sut.count(for: "Hello"), 1)

        // when
        sut.remove("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 0)
        // when
        sut.remove("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 0)
    }

    func testThatItMultipleElementsCanbeAddedWithoutAffectingEachOther() {
        // given
        sut = CountedSet(arrayLiteral: "Hello", "World", "Hello")
        XCTAssertEqual(sut.count(for: "Hello"), 2)
        XCTAssertEqual(sut.count(for: "World"), 1)

        // when
        sut.remove("Hello")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 1)
        XCTAssertEqual(sut.count(for: "World"), 1)
        // when
        sut.insert("World")
        // then
        XCTAssertEqual(sut.count(for: "Hello"), 1)
        XCTAssertEqual(sut.count(for: "World"), 2)
    }

    func testThatItReturnsNilIfThereIsTheElementToRemoveIsNotInTheSet() {
        // when
        let element = "Test"
        sut.insert(element)

        // then
        XCTAssertEqual(element, sut.remove(element))
        XCTAssertNil(sut.remove(element))
    }

    func testThatItReturnsTheElementWithTheMostOccurences() {
        // given
        sut = CountedSet(arrayLiteral: "Hello", "World", "Hello")

        // when
        let mostOccuring = sut.mostFrequent()
        // then
        XCTAssertEqual(mostOccuring?.element, "Hello")
        XCTAssertEqual(mostOccuring?.count, 2)
    }

    func testThatItReturnsTheElementWithTheMostOccurencesWhenThereIsOnlyOneElement() {
        // given
        sut = CountedSet(arrayLiteral: "Hello")

        let mostOccuring = sut.mostFrequent()
        XCTAssertEqual(mostOccuring?.element, "Hello")
        XCTAssertEqual(mostOccuring?.count, 1)
    }

    func testThatItReturnsNilIfThereIsNoMostOccuringElement() {
        // when
        let mostOccuring = sut.mostFrequent()
        // then
        XCTAssertNil(mostOccuring)
    }

    func testThatToEqualCountedSetsAreReportedEqual() {
        // when
        sut = CountedSet(arrayLiteral: "Hello", "World", "Hello")
        let other = CountedSet(arrayLiteral: "Hello", "Hello", "World")

        // then
        XCTAssertEqual(sut, other)
    }

    func testThatToNotEqualCountedSetsAreNotReportedEqual() {
        // when
        sut = CountedSet(arrayLiteral: "Hello", "World", "Hello", "World")
        let other = CountedSet(arrayLiteral: "Hello", "Hello", "World")

        // then
        XCTAssertNotEqual(sut, other)
    }

    func testThatToReturnsTheCorrectElementWhenSubscipted() {
        // when
        sut = CountedSet(arrayLiteral: "Hello", "Tiny", "World", "Hello", "Tiny", "Tiny")
        guard let worldIndex = sut.index(of: "World") else { return XCTFail() }
        guard let tinyIndex = sut.index(of: "Tiny") else { return XCTFail() }
        guard let helloIndex = sut.index(of: "Hello") else { return XCTFail() }

        // then
        XCTAssertEqual("World", sut[worldIndex])
        XCTAssertEqual("Tiny", sut[tinyIndex])
        XCTAssertEqual("Hello", sut[helloIndex])
    }

    func testThatItCreatesACorrectGenerator() {
        // given
        sut = CountedSet(arrayLiteral: "Hello", "World", "Hello")
        var generator = sut.makeIterator()
        var generatedElements = [String]()

        // when
        while let element = generator.next() {
            generatedElements.append(element)
        }

        // then
        let expected = Set<String>(arrayLiteral: "Hello", "World")
        XCTAssertEqual(Set(generatedElements), expected)
    }

    func testThatItReturnsTheCountWhenSubsciptedWithElement() {
        // given
        sut = CountedSet(arrayLiteral: "Foo", "Bar", "Baz", "Foo", "Foo", "Bar")

        // then
        XCTAssertEqual(sut["Foo"], 3)
        XCTAssertEqual(sut["Bar"], 2)
        XCTAssertEqual(sut["Baz"], 1)
    }

    func testThatItDoesNotAddTheCountsForElementsWithTheSameHash() {
        // given
        let first = HashHelper(hashValue: 1, name: "first")
        let second = HashHelper(hashValue: 2, name: "second")

        var sut = CountedSet(arrayLiteral: first, second)

        // then
        XCTAssertEqual(sut.count(for: first), 1)
        XCTAssertEqual(sut.count(for: second), 1)

        // when
        let third = HashHelper(hashValue: 1, name: "third")
        sut.insert(third)

        // then
        XCTAssertEqual(sut.count(for: first), 1)
        XCTAssertEqual(sut.count(for: second), 1)
        XCTAssertEqual(sut.count(for: third), 1)
    }

    func testThatItDoesAddTheCountsForElementsWithTheSameIdentity() {
        // given
        let first = HashHelper(hashValue: 1, name: "first")

        var sut = CountedSet(arrayLiteral: first)

        // then
        XCTAssertEqual(sut.count(for: first), 1)

        // when
        let second = HashHelper(hashValue: 1, name: "first")
        sut.insert(second)

        // then
        XCTAssertEqual(sut.count(for: first), 2)
        XCTAssertEqual(sut.count(for: second), 2)
    }

    func testThatItReturnsZeroIfTheElementIsNotInTheSetWhenSubscipted() {
        // given
        sut = ["Foo", "Bar"]
        // then
        XCTAssertEqual(sut["Baz"], 0)
    }
    
    func testThatItAddsANonExistentElementWhenSettingCount() {
        // given
        sut = ["Foo", "Bar"]
        // when
        sut.setCount(2, for: "Baz")
        // then
        XCTAssert(sut.contains("Baz"))
        XCTAssertEqual(sut.count(for: "Baz"), 2)
    }
    
    func testThatItSetsTheNewCountWhenSettingCountForContainedElement() {
        // given
        sut = ["Foo", "Bar"]
        // when
        XCTAssert(sut.setCount(3, for: "Foo"))
        // then
        XCTAssertEqual(sut.count(for: "Foo"), 3)
    }

    func testThatItReturnsFalseWhenSettingExistingCount() {
        // given
        sut = ["Foo", "Bar", "Foo"]
        // then
        XCTAssertFalse(sut.setCount(2, for: "Foo"))
    }

    func testThatItReturnsTrueWhenSettingCountForElementWithDifferentExistingCount() {
        // given
        sut = ["Foo", "Bar"]
        // then
        XCTAssert(sut.setCount(2, for: "Foo"))
    }
    
    func testThatItRemovesElementFrombackingStoreWhenSettingCountForContainedElementToZero() {
        // given
        sut = ["Foo", "Bar"]
        // when
        XCTAssert(sut.setCount(0, for: "Foo"))
        // then
        XCTAssertFalse(sut.contains("Foo"))
        XCTAssertEqual(sut.count(for: "Foo"), 0)
    }

    func testThePerformanceOfAdding_10000_ElementsToTheCountedSet() {
        var sut = CountedSet<Int>()
        let range = 0..<100
        measure {
            range.forEach { _ in
                range.forEach {
                    // when
                    sut.insert($0)
                }
            }
        }

        // then
        XCTAssertEqual(sut.count, 100)
        range.forEach {
            XCTAssertEqual(sut.count(for: $0), 1000)
        }
    }

    func testThatItReturnsAValidDescription() {
        // given
        sut = CountedSet(arrayLiteral: "Foo", "Bar", "Foo")
        let expected = "<CountedSet>:\n\t- Foo: 2\n\t- Bar: 1\n"

        // then
        XCTAssertEqual(sut.description, expected)
    }

    func testThatItReturnsDistinctHashValues() {
        // given
        let sut1 = CountedSet(arrayLiteral: "Foo", "Bar", "Foo")
        let sut2 = CountedSet(arrayLiteral: "Foo", "Foo", "Bar")
        let sut3 = CountedSet(arrayLiteral: "Foo", "Bar")

        // then
        XCTAssertEqual(sut1.hashValue, sut2.hashValue)
        XCTAssertNotEqual(sut2.hashValue, sut3.hashValue)
    }
    
}
