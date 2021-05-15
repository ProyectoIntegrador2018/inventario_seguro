/**
 mostrarResultadosViewController.swift
 InventarioSeguro
  - Authors:
 Roger Vazquez, Jorge Ramos, Angel Treviño, Julia Jimenez
*/


import UIKit

class mostrarResultadosViewController: UIViewController {
    
   
    var dbR:DBRegistroHelper = DBRegistroHelper()
    var registros: [Registro] = []
    
    @IBOutlet weak var rolloCode: UITextField!
    
    @IBOutlet weak var rolloCode2: UITextField!
    
    @IBOutlet weak var rolloCode3: UITextField!
    
    @IBOutlet weak var rolloCode4: UITextField!
    @IBOutlet weak var usuarioName: UITextField!
    
    var capturedText: [String] = []
    var numDifferences: [Double] = []
    var dataFromImage = false; // do not affect accuracy if its manual
    var usuario: Usuario!
  
    override func viewWillAppear(_ animated: Bool) {
        rolloCode.text = ""
        rolloCode2.text = ""
        rolloCode3.text = ""
        rolloCode4.text = ""
        
        
        for input in capturedText {
            numDifferences.append(100)
        }
        
        usuarioName.text = usuario.nombre
        
        if ( // ignore manual entry
            capturedText[0] == "" &&
            capturedText[1] == "" &&
            capturedText[2] == "" &&
            capturedText[3] == ""
        ) {
            dataFromImage = true;
        }
        
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
    
    
    @IBAction func saveInfo(_ sender: Any) {
        if (dataFromImage) {
            numDifferences.append(checkErrors(save: rolloCode.text!, original: capturedText[0]))
            numDifferences.append(checkErrors(save: rolloCode2.text!, original: capturedText[1]))
            numDifferences.append(checkErrors(save: rolloCode3.text!, original: capturedText[2]))
            numDifferences.append(checkErrors(save: rolloCode4.text!, original: capturedText[3]))
        }
        
        // TODO: add to database
        dbR.insert(id: 3004, idUsuario: usuario.id, idRollos: "1003", ubicacion: "Mty", fecha: "14/05/21", accuracy: Int(numDifferences[0]))
        dbR.insert(id: 3003, idUsuario: usuario.id, idRollos: "1003", ubicacion: "Mty", fecha: "14/05/21", accuracy: Int(numDifferences[1]))
        dbR.insert(id: 3004, idUsuario: usuario.id, idRollos: "1003", ubicacion: "Mty", fecha: "14/05/21", accuracy: Int(numDifferences[2]))
        dbR.insert(id: 3005, idUsuario: usuario.id, idRollos: "1003", ubicacion: "Mty", fecha: "14/05/21", accuracy: Int(numDifferences[3]))
        
    }
    
    /// Get the percentage of number of errors from original to save
    /// - Parameters:
    ///   - save: The string to save
    ///   - original: The original string we recieved from the image
    /// - Returns: The percentage
    func checkErrors(save: String, original: String) -> Double {
        var diff: Double = 0.0
        diff = Double(abs(save.count - original.count)) // if someone has more letters than the other

        for (index, char) in original.enumerated() {
            if char != save[save.index(save.startIndex, offsetBy: index)] {
                diff = diff + 0.0;
            }
        }
        
        return (diff / Double(save.count)) * 100 // get percentage
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
