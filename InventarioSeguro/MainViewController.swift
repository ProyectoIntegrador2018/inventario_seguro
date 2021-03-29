import UIKit
import VisionKit

/**
 The main section of the application, other storyboards will connect to this one.
 
 ---
 
 - Authors:
    Roger Vazquez, Angel Treviño

 - Date: 23/02/21
 */
class MainViewController: UIViewController, VNDocumentCameraViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /**
     Action that activates the camera to recognize text from images
     
     - parameters:
        - sender: The button who activated the action.
     */
    @IBAction func scanFromCamera(_ sender: UIButton) {
        
        // guard if Text recognizition is not posible in the device
        guard VNDocumentCameraViewController.isSupported else {
            print("El escaneo de texto no esta permitido en este dispositivo");
            return;
        }
        
        let documentCamera = VNDocumentCameraViewController();
        documentCamera.delegate = self;
        present(documentCamera, animated: true, completion: nil)
    }
    
    // TODO: Process text
    
    // TODO: Show result of processing the text
    
}
