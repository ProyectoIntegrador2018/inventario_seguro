/**
 ViewController.swift
 InventarioSeguro
  - Authors:
 Roger Vazquez, Jorge Ramos, Angel Treviño, Julia Jimenez
*/

import UIKit
// Librerias para el reconocimiento de imagen
import Vision
import VisionKit
import ImageSlideshow

class ViewController: UIViewController {
    // MARK: - Variables y Outlets
    var db:DBRolloHelper = DBRolloHelper()
    var rollos: [Rollo] = []
    var dbR:DBRegistroHelper = DBRegistroHelper()
    var registros: [Registro] = []
    
    @IBOutlet weak var botonGuardar: UIButton!
    @IBOutlet weak var botonScan: UIButton!
    //Resultado del recononocimiento de la imagen
    @IBOutlet weak var textViewResultado: UITextView!
    //Imagen tomada con la camra
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var imageViewImagen: ImageSlideshow!
    
    @IBOutlet weak var imageViewSlide: ImageSlideshow!
    // Variable para el manejo del reconocimiento del texto
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    var ocrText = ""
    var ocrTexts = Array(repeating:"", count: 4)
    var counter = 0;
    var displayUser: Usuario!
    var imagesListArray = [ImageSource]()
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated);
        imagesListArray.removeAll()
    }
    
    // MARK: - ViewDidLoad 
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNameLabel.text = "Bienvenido "+displayUser.nombre+", empieza a registrar";
        // Agrega el boton de done al teclado cuando se quiere editar el resultado
        addDoneBtn()
        // Configuración del reconocimiento de imagen
        configureOCR()
        
        objetoDummy()
                
        
    }
    
    // MARK: - Funcionalidad y settings
    // Función para el procesamiento de la imagen
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        textViewResultado.text = ""
        botonScan.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }

    /// Settings para el reconocimiento de imagen
    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
           // Escoge la palabra que mas se acerque a la palabra de la imagen
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                //self.ocrText += topCandidate.string + "\n"
                self.ocrTexts[self.counter] = topCandidate.string
                self.counter += 1
            }
            
            
            DispatchQueue.main.async {
                //self.textViewResultado.text = self.ocrText
                self.botonScan.isEnabled = true
            }
        }
        /// Accurate es mas lenta pero mas precisa
        ocrRequest.recognitionLevel = .accurate
        /// Idiomas a detectar
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        /// Correcion de palabras
        ocrRequest.usesLanguageCorrection = true
        
    }
    // MARK: - Botones
    /// Accion que se toma al presionar el boton de escanear
    @IBAction func escanarButtonPressed(_ sender: UIButton) {
        // View predeterminada de ios de la camara
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: prevenir que este segue se realize si scannedOCR esta vacio
        //let scannedOCR = self.textViewResultado?.text ?? ""
        let scannedOCR = self.ocrTexts
        resetVariables()
        let destinationVC = segue.destination as! mostrarResultadosViewController
        destinationVC.capturedText = scannedOCR
        destinationVC.usuario = self.displayUser
        
    }
    
    

    // Agrega el boton de done al teclado cuando se quiere editar el resultado
    func addDoneBtn()
    {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
                let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
                let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
                toolbar.setItems([flexSpace, doneBtn], animated: false)
                toolbar.sizeToFit()
                self.textViewResultado.inputAccessoryView = toolbar
    }
    
    // Función para terminar el uso del teclado
    @objc func dismissMyKeyboard()
    {
        view.endEditing(true)
    }
    
    func resetVariables()
    {
        
        var j = 0
        while(j<=3)
        {
            self.ocrTexts[j] = ""
           j += 1
        }
        self.counter = 0
    }
    
    //Funcion para crear objeto dummy
    func objetoDummy() {
        db.insert(id: 1000, numeroIdent: "WASD38")
        db.insert(id: 1001, numeroIdent: "QERF55")
        rollos = db.read()
        
        for rollo in rollos {
            print("id: ", rollo.id, "|| numeroIdent: ", rollo.numeroIdent)
        }
        
        dbR.insert(id: 3000, idUsuario: 2000, idRollos: "1001", ubicacion: "Mty", fecha: "27/04/20")
        dbR.insert(id: 3001, idUsuario: 2001, idRollos: "1000", ubicacion: "CDMX", fecha: "27/04/20")
        registros = dbR.read()
        
        for registro in registros {
            print("id: ", registro.id, "|| idUsuario: ", registro.idUsuario, "|| idRollo: ", registro.idRollos, "|| ubicacion: ", registro.ubicacion, "|| fecha: ", registro.fecha)
        }
    }
}
// MARK: - Controller de la camara
/// Controller para la camara
extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Manejo para varias imagenes a la vez
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        var i = 0
        
        while(i < scan.pageCount)
        {
            processImage(scan.imageOfPage(at: i))
            let image = ImageSource(image:scan.imageOfPage(at: i))
            imagesListArray.append(image)
            i+=1
        }
        imageViewSlide.setImageInputs(imagesListArray)
        //imageViewImagen.image = scan.imageOfPage(at: 0)
       
        /// Se termino de tomar fotos
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        // Se le dio al botón de cancelar
        controller.dismiss(animated: true)
    }
    
}




