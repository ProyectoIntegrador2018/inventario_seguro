/**
 InventarioSeguroUITests.swift
 InventarioSeguroUITests
 
  - Authors:
 Roger Vazquez, Angel Treviño
*/


import XCTest

class InventarioSeguroUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    /// Method that tests if the ui elements for scanning exist and perform well
    /// - Throws: Success or error on test
    func testActivateCamera() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // given
        let escanearButton = app/*@START_MENU_TOKEN@*/.staticTexts["Escanear "]/*[[".buttons[\"Escanear \"].staticTexts[\"Escanear \"]",".staticTexts[\"Escanear \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let takePictureBtn = app.buttons["Take picture"]
        let keepScanBtn = app.buttons["Keep Scan"]
        let saveBtn = app/*@START_MENU_TOKEN@*/.staticTexts["Save"]/*[[".buttons[\"Save, 1 scan\"].staticTexts[\"Save\"]",".staticTexts[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        // then
        if escanearButton.isSelected {
            XCTAssertTrue(escanearButton.exists)
            XCTAssertFalse(escanearButton.exists)
            
            escanearButton.tap()
            
            XCTAssertTrue(takePictureBtn.exists)
            XCTAssertFalse(takePictureBtn.exists)
            
            takePictureBtn.tap()
            
            XCTAssertTrue(keepScanBtn.exists)
            XCTAssertFalse(keepScanBtn.exists)
            
            keepScanBtn.tap()
            
            XCTAssertTrue(keepScanBtn.exists)
            XCTAssertFalse(keepScanBtn.exists)
            
            keepScanBtn.tap()
            
            XCTAssertTrue(saveBtn.exists)
            XCTAssertFalse(saveBtn.exists)
            
            saveBtn.tap()
        }
    }
    
    
    /// Method that test the editing of the result of the analysis of the image
    /// - Throws: Success or fail on test 
    func testEditOutput() throws {
        
        let editTextView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards",".keys[\"suprimir\"]",".keys[\"delete\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        
        let doneBtn = app.toolbars["Toolbar"].buttons["Done"]
        let guardarBtn = app/*@START_MENU_TOKEN@*/.staticTexts["Save"]/*[[".buttons[\"Save, 1 scan\"].staticTexts[\"Save\"]",".staticTexts[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        if editTextView.isSelected {
            
            XCTAssertTrue(editTextView.exists)
            XCTAssertFalse(editTextView.exists)
            editTextView.tap()
            
            XCTAssertTrue(deleteKey.exists)
            XCTAssertFalse(deleteKey.exists)
            deleteKey.tap()
            
            XCTAssertTrue(doneBtn.exists)
            XCTAssertFalse(doneBtn.exists)
            doneBtn.tap()
            
            XCTAssertTrue(guardarBtn.exists)
            XCTAssertFalse(guardarBtn.exists)
            guardarBtn.tap()
        }
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
