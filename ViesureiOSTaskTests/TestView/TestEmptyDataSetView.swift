//
//  TestEmptyDataSetView.swift
//
//  Created by Mohamed El-Shawarby on 20.05.22.
//

import XCTest
import ViewInspector
@testable import ViesureiOSTask

class TestEmptyDataSetView: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
    }

    func testEmptyDataSet() throws {
        var n = 1
        let titleText = "Title"
        let descriptionText = "Description"
        let buttonTitle = "Button"
        let view = EmptyDataSetView(viewData: EmptyDataSetData(tryAgainHandler: {
            n+=1
        }, title: titleText, descriptionText: descriptionText, buttonTitle: buttonTitle ))
        let titleViewText = try view.inspect().zStack().vStack(0).text(0).string()
        let descriptionViewText = try view.inspect().zStack().vStack(0).text(1).string()
        let button = try view.inspect().zStack().vStack(0).find(button: buttonTitle)
        try button.tap()
        XCTAssertEqual(titleViewText, titleText)
        XCTAssertEqual(descriptionViewText, descriptionText)
        XCTAssertNotNil(button)
        XCTAssertEqual(n, 2)
    }

    func testEmptyDataSetWithOnlyTitle() throws {
        let titleText = "No Vip Articles To Show"
        let view = EmptyDataSetView(viewData: EmptyDataSetData(title: titleText))
        let titleViewText = try view.inspect().zStack().vStack(0).text(0).string()
        let descriptionViewText = try? view.inspect().zStack().vStack(0).text(1).string()
        XCTAssertEqual(titleViewText, titleText)
        XCTAssertNil(descriptionViewText)
    }
}

extension EmptyDataSetView: Inspectable { }
