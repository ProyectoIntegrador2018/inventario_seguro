/**
 mostrarResultadosViewController.swift
 InventarioSeguro
  - Authors:
 Roger Vazquez, Jorge Ramos, Angel Treviño, Julia Jimenez
*/


import UIKit

class mostrarResultadosViewController: UIViewController {
    
   
    @IBOutlet weak var rolloCode: UITextField!
    
    @IBOutlet weak var rolloCode2: UITextField!
    
    @IBOutlet weak var rolloCode3: UITextField!
    
    @IBOutlet weak var rolloCode4: UITextField!
    
    var capturedText: [String] = []
  
    override func viewWillAppear(_ animated: Bool) {
        rolloCode.text = ""
        rolloCode2.text = ""
        rolloCode3.text = ""
        rolloCode4.text = ""
        
        rolloCode.text = capturedText[0]
        rolloCode2.text = capturedText[1]
        rolloCode3.text = capturedText[2]
        rolloCode4.text = capturedText[3]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing));
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    /**
     dismiss, eliminar en futuras versiones.
     
     TODO: Deberíamos ejecutar dismiss hasta que el registro esté guardado en la DB (u ocurra una excepción)
     */
    @IBAction func dismissBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
