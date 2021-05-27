/**
 mostrarResultadosViewController.swift
 InventarioSeguro
  - Authors:
 Roger Vazquez, Jorge Ramos, Angel Treviño, Julia Jimenez
*/


import UIKit

class mostrarResultadosViewController: UIViewController {
    
   
    var dbReg:DBRegistroHelper = DBRegistroHelper()
    var dbRollos: DBRolloHelper = DBRolloHelper()
    var registros: [Registro] = []
    
    @IBOutlet weak var rolloCode: UITextField!
    
    @IBOutlet weak var rolloCode2: UITextField!
    
    @IBOutlet weak var rolloCode3: UITextField!
    
    @IBOutlet weak var rolloCode4: UITextField!
    @IBOutlet weak var usuarioName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //TODO: change this into a picker!
    @IBOutlet weak var ubicacionRollo: UITextField!
    var capturedText: [String] = []
    var numDifferences: [Double] = []
    var dataFromImage = false; // do not affect accuracy if its manual
    var usuario: Usuario!

    
    override func viewWillAppear(_ animated: Bool) {
        rolloCode.text = ""
        rolloCode2.text = ""
        rolloCode3.text = ""
        rolloCode4.text = ""
        
        
        for _ in capturedText {
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
        // Cambia los primeros 2 valores del campo 1
        if capturedText[0].count >= 2 {
            let endIndex0 = capturedText[0].index(capturedText[0].startIndex, offsetBy: 1)
            capturedText[0].replaceSubrange(...endIndex0, with: "3B")
        }
        if capturedText[1].count >= 2 {
            let endIndex1 = capturedText[1].index(capturedText[1].startIndex, offsetBy: 1)
            capturedText[1].replaceSubrange(...endIndex1, with: "3B")
        }
        if capturedText[0].count >= 2 {
            let endIndex2 = capturedText[2].index(capturedText[2].startIndex, offsetBy: 1)
            capturedText[2].replaceSubrange(...endIndex2, with: "3B")
        }
        if capturedText[0].count >= 2 {
            let endIndex3 = capturedText[3].index(capturedText[3].startIndex, offsetBy: 1)
            capturedText[3].replaceSubrange(...endIndex3, with: "3B")
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
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        
        if (dataFromImage) {
            numDifferences.append(checkErrors(save: rolloCode.text!, original: capturedText[0]))
            numDifferences.append(checkErrors(save: rolloCode2.text!, original: capturedText[1]))
            numDifferences.append(checkErrors(save: rolloCode3.text!, original: capturedText[2]))
            numDifferences.append(checkErrors(save: rolloCode4.text!, original: capturedText[3]))
        }
        
        // TODO: add to database
        
        let rollos: [Rollo] = InsertRollos()
        InsertRegistros(rollos: rollos, date: strDate, location: ubicacionRollo.text!)
    }
    
    
    func InsertRollos() -> [Rollo] {
        var rollos: [Rollo] = []
        
        rollos.append(Rollo(id: UUID().uuidString, numeroIdent: rolloCode.text!))
        rollos.append(Rollo(id: UUID().uuidString, numeroIdent: rolloCode2.text!))
        rollos.append(Rollo(id: UUID().uuidString, numeroIdent: rolloCode3.text!))
        rollos.append(Rollo(id: UUID().uuidString, numeroIdent: rolloCode4.text!))
        
        for rollo in rollos {
            dbRollos.insert(id: rollo.id, numeroIdent: rollo.numeroIdent)
        }
        
        return rollos
    }
    
    
    func InsertRegistros(rollos: [Rollo], date: String, location: String) {
        var registros: [Registro] = []
        for (index, rollo) in rollos.enumerated() {
            registros.append(Registro(id: UUID().uuidString, idUsuario: usuario.id, idRollos: rollo.numeroIdent, ubicacion: location, fecha: date, accuracy: Int(numDifferences[index])))
        }
        
        for registro in registros {
            dbReg.insert(id: registro.id, idUsuario: registro.idUsuario, idRollos: registro.idRollos, ubicacion: registro.ubicacion, fecha: registro.fecha, accuracy: registro.accuracy)
        }
        
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
