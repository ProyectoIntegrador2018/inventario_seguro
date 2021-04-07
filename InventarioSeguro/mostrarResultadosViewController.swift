/**
 mostrarResultadosViewController.swift
 InventarioSeguro
  - Authors:
 Roger Vazquez, Jorge Ramos, Angel Treviño, Julia Jimenez
*/


import UIKit

class mostrarResultadosViewController: UIViewController {
    
   
    @IBOutlet weak var rolloCode: UITextField!
    var capturedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rolloCode.text = capturedText
        
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
