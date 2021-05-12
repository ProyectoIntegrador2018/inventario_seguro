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
        dbU.insert(id: 2000, nombre: "Angel Treviño", correo: "angel@gmail.com", password: "ternium", cargo: "Project Admin")
        dbU.insert(id: 2001, nombre: "Maggie Jimenez", correo: "maggie@gmail.com", password: "ternium", cargo: "Product Owner Proxy")
        dbU.insert(id: 2002, nombre: "Roger Vazquez", correo: "roger@gmail.com", password: "ternium", cargo: "SCRUM master and Leader")
        dbU.insert(id: 2003, nombre: "Jorge Ramos", correo: "jorge@gmail.com", password: "ternium", cargo: "Configuration Admin")
    }
    
    func validateInput() -> Bool {
        return (userTField.text!.isEmpty && pwdTField.text!.isEmpty)
    }
    
    // TODO: - This needs to be a method from the db helper
    func getUserByEmail(_email: String) -> Usuario? {
        let usuarios: [Usuario] = dbU.read()
    
        for usuario in usuarios{
            if usuario.correo == _email {
                return usuario
            }
        }
        return nil
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
            usuario = getUserByEmail(_email: userTField.text!)
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
        let displayName = self.usuario!.nombre;
        let destinationVC = segue.destination as! ViewController
        destinationVC.displayName = displayName;
    }
    
    
    
    
    
    
}
