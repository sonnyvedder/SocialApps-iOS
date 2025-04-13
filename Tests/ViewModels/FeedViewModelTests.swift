import XCTest
@testable import SocialApp

class FeedViewModelTests: XCTestCase {
    var sut: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        sut = FeedViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchPosts() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        // When
        await sut.fetchPosts()
        
        // Then
        XCTAssertFalse(sut.posts.isEmpty)
        XCTAssertNil(sut.error)
        expectation.fulfill()
    }
}