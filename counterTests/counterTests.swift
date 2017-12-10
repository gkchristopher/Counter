import UIKit
import XCTest
@testable import counter

class counterTests: XCTestCase {

    var viewModel: CounterViewModel?
    

    override func setUp() {
        super.setUp()

        viewModel = CounterViewModel(nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        viewModel = nil
    }
}
