//
//  LoginViewController.swift
//  InventarioSeguro
//
//  Created by Roger Eduardo Vazquez Tuz on 28/04/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTField: UITextField!
    @IBOutlet weak var pwdTField: UITextField!
    var usuario: Usuario = Usuario.init(id: 4001, nombre:  "Juan Pérez", correo: "jperez@ternium.mx", cargo: "Tester");
    var pwd:String = "loremipsum";
    // MARK: - viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing));
        view.addGestureRecognizer(tap);
    }
    
    func validateInput() -> Bool {
        return (userTField.text!.isEmpty && pwdTField.text!.isEmpty)
    }
    
    
    
    // MARK: - LoginButton
    @IBAction func doLogin(_ sender: Any) {
        //Recuperar pwd para el username userTField
        
        if validateInput() {
            let alertController = UIAlertController(title: "Error", message: "Campos vacíos!", preferredStyle: .alert);
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);
            
            alertController.addAction(defaultAction);
            self.present(alertController, animated: true, completion: nil);
            
        } else {
            if pwdTField.text! == pwd {
                self.performSegue(withIdentifier: "toHome", sender: self);
            } else {
                let alertController = UIAlertController(title: "Error", message: "Credenciales inválidas, ingrese de nuevo", preferredStyle: .alert);
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);
                
                alertController.addAction(defaultAction);
                self.present(alertController, animated: true, completion: nil);
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let displayName = self.usuario.nombre;
        let destinationVC = segue.destination as! ViewController
        destinationVC.displayName = displayName;
    }
    
    
    
    
    
    
}
