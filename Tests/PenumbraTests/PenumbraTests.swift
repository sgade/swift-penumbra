import XCTest
import SwiftUI
@testable import Penumbra

final class PenumbraTests: XCTestCase {

    func testPenumbraBalancedBaseSunPlus() {
        XCTAssertEqual(Color.Penumbra.Balanced.Base.sunPlus, Color(red: 1.0, green: 0.9921568627450981, blue: 0.984313725490196))
    }

}
