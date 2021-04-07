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

class ViewController: UIViewController {
    // MARK: - Variables y Outlets
   
    @IBOutlet weak var botonGuardar: UIButton!
    @IBOutlet weak var botonScan: UIButton!
    //Resultado del recononocimiento de la imagen
    @IBOutlet weak var textViewResultado: UITextView!
    //Imagen tomada con la camra
    @IBOutlet weak var imageViewImagen: UIImageView!
    // Variable para el manejo del reconocimiento del texto
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    // MARK: - ViewDidLoad 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Agrega el boton de done al teclado cuando se quiere editar el resultado
        addDoneBtn()
        // Configuración del reconocimiento de imagen
        configureOCR()
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
            
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText += topCandidate.string + "\n"
            }
            
            
            DispatchQueue.main.async {
                self.textViewResultado.text = ocrText
                self.botonScan.isEnabled = true
            }
        }
        /// Accurate es mas lenta pero mas precisa
        ocrRequest.recognitionLevel = .accurate
        /// Idiomas a detetar
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: prevenir que este segue se realize si scannedOCR esta vacio
        let scannedOCR = self.textViewResultado.text ?? ""
        let destinationVC = segue.destination as! mostrarResultadosViewController
        
        destinationVC.capturedText = scannedOCR
        
        
        
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
        
        imageViewImagen.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
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



