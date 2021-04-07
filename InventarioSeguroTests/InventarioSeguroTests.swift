//
//  InventarioSeguroTests.swift
//  InventarioSeguroTests
//
//  Created by Roger Eduardo Vazquez Tuz on 23/03/21.
//

import XCTest
@testable import InventarioSeguro

class InventarioSeguroTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var callingViewController: ViewController!
    var targetViewController: mostrarResultadosViewController!
    var targetSegue: UIStoryboardSegue!

    override func setUpWithError() throws {
        // declare the storyboard, source view controller, and target view controller
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        callingViewController = storyboard.instantiateViewController(identifier: "ViewController") as! ViewController
        targetViewController = storyboard.instantiateViewController(identifier: "mostrarResultadosVC") as! mostrarResultadosViewController
        
        // fetch the segue from story board
        targetSegue = UIStoryboardSegue(identifier: "mostrarResultadoSegue", source: callingViewController, destination: targetViewController)
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSUT_PassesRecognitionToMostrarResultadoViewController() throws {
        
        
        // simulate when user taps a cell - we get the associated model object and send its id (of type Int) as the sender parameter of prepareForSegue()
        let tappedModelId = callingViewController.botonGuardar
        callingViewController.prepare(for: self.targetSegue, sender: tappedModelId)
        
        let sendText = callingViewController.textViewResultado?.text ?? ""
                
        // confirm that prepareForSegue() properly sets the 'placeId' property of the destination view controller
        XCTAssertEqual(sendText, targetViewController.capturedText)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
