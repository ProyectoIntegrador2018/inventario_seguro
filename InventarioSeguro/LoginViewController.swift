//
//  LoginViewController.swift
//  InventarioSeguro
//
//  Created by Roger Eduardo Vazquez Tuz on 28/04/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Variables y OutletsS
    var dbU: DBUsuarioHelper = DBUsuarioHelper()
    var usuario: Usuario? = nil
    
    @IBOutlet weak var userTField: UITextField!
    @IBOutlet weak var pwdTField: UITextField!

    // MARK: - viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        createDummyUsers()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing));
        view.addGestureRecognizer(tap);
    }
    
    // MARK: - Dummy user
    func createDummyUsers() {
        
        // Insert into database
        dbU.insert(id: UUID().uuidString, nombre: "Angel Treviño", correo: "angel@gmail.com", password: "ternium", cargo: "Project Admin")
        dbU.insert(id: UUID().uuidString, nombre: "Maggie Jimenez", correo: "maggie@gmail.com", password: "ternium", cargo: "Product Owner Proxy")
        dbU.insert(id: UUID().uuidString, nombre: "Roger Vazquez", correo: "roger@gmail.com", password: "ternium", cargo: "SCRUM master and Leader")
        dbU.insert(id: UUID().uuidString, nombre: "Jorge Ramos", correo: "jorge@gmail.com", password: "ternium", cargo: "Configuration Admin")
        dbU.insert(id: UUID().uuidString, nombre: "Luis Valdez", correo: "luis@gmail.com", password: "ternium", cargo: "Product Owner")
    }
    
    func validateInput() -> Bool {
        return (userTField.text!.isEmpty && pwdTField.text!.isEmpty)
    }
    
func displayErrorMessage() {
        let alertController = UIAlertController(title: "Error", message: "Credenciales inválidas, ingrese de nuevo", preferredStyle: .alert);
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);
        
        alertController.addAction(defaultAction);
        self.present(alertController, animated: true, completion: nil);
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
            usuario = dbU.getUsuarioByEmail(_email: userTField.text!)
            if let retrieveUsuario = usuario {
                if pwdTField.text! == retrieveUsuario.password {
                    self.performSegue(withIdentifier: "toHome", sender: self);
                } else {
                    displayErrorMessage()
                }
            } else {
                displayErrorMessage()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        destinationVC.displayUser = self.usuario;
    }
    
    
    
    
    
    
}
