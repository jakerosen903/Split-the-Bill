//
//  CaptureBillViewController.swift
//  FinalProj
//
//  Created by Blake Underwood on 4/13/21.
//

import UIKit
import Vision
import CoreML

public var observationStringLookup : [VNTextObservation : String] = [:]

class CaptureBillViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var foods: [Food] = []
    var currentImage : UIImage!
    var model: VNCoreMLModel!
    var textMetadata = [Int: [Int: String]]()
    
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var photoBillView: UIImageView!
    @IBOutlet weak var chooseImage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadModel()

    }
    
    private func loadModel() {
        guard let mlModel = try? Alphanum_28x28(configuration: .init()).model,
              let mlModelVN = try? VNCoreMLModel(for: mlModel) else {
            fatalError("Unable to load ML Model")
        }
        
        self.model = mlModelVN
    }
    
    
    override func viewDidLayoutSubviews() {
        
        // Create the border and the color for the process Button
        // Makes sure to pad the letters a bit as well
        processButton.layer.cornerRadius = 5
        processButton.layer.borderWidth = 1
        processButton.layer.borderColor = UIColor(red: 0.0, green: 139.0/255.0, blue: 139.0/255.0, alpha: 1.0).cgColor
        processButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
    
    // VISION/CORE ML BELOW
    func createVisionRequest(image: UIImage)
        {
            
            currentImage = image
            guard let cgImage = image.cgImage else {
                return
            }
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.cgImageOrientation, options: [:])
            let vnRequests = [vnTextDetectionRequest]
            
            DispatchQueue.global(qos: .background).async {
                do{
                    try requestHandler.perform(vnRequests)
                }catch let error as NSError {
                    print("Error in performing Image request: \(error)")
                }
            }
            
        }
        
        var vnTextDetectionRequest : VNDetectTextRectanglesRequest{
            let request = VNDetectTextRectanglesRequest { (request,error) in
                if let error = error as NSError? {
                    print("Error in detecting - \(error)")
                    return
                }
                else {
                    guard let observations = request.results as? [VNTextObservation]
                        else {
                            return
                    }
                    
                    var numberOfWords = 0
                    for textObservation in observations {
                        var numberOfCharacters = 0
                        for rectangleObservation in textObservation.characterBoxes! {
                            let croppedImage = crop(image: self.currentImage, rectangle: rectangleObservation)
                            if let croppedImage = croppedImage {
                                let processedImage = preProcess(image: croppedImage)
                                print("calling classifier")
                                self.imageClassifier(image: processedImage,
                                                   wordNumber: numberOfWords,
                                                   characterNumber: numberOfCharacters, currentObservation: textObservation)
                                numberOfCharacters += 1
                            }
                        }
                        numberOfWords += 1
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "priceSegue", sender: nil)
                    }
                }
            }
            
            request.reportCharacterBoxes = true
            print("finished request")
            return request
        }
        
        
        
        //COREML
        func imageClassifier(image: UIImage, wordNumber: Int, characterNumber: Int, currentObservation : VNTextObservation){
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first else {
                        fatalError("Unexpected result type from VNCoreMLRequest")
                }
                let result = topResult.identifier
                let classificationInfo: [String: Any] = ["wordNumber" : wordNumber,
                                                         "characterNumber" : characterNumber,
                                                         "class" : result]
                self?.handleResult(classificationInfo, currentObservation: currentObservation)
            }
            guard let ciImage = CIImage(image: image) else {
                fatalError("Could not convert UIImage to CIImage :(")
            }
            let handler = VNImageRequestHandler(ciImage: ciImage)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                }
                catch {
                    print(error)
                }
            }
        }
        
        func handleResult(_ result: [String: Any], currentObservation : VNTextObservation) {
            objc_sync_enter(self)
            guard let wordNumber = result["wordNumber"] as? Int else {
                return
            }
            guard let characterNumber = result["characterNumber"] as? Int else {
                return
            }
            guard let characterClass = result["class"] as? String else {
                return
            }
            if (textMetadata[wordNumber] == nil) {
                let tmp: [Int: String] = [characterNumber: characterClass]
                textMetadata[wordNumber] = tmp
            } else {
                var tmp = textMetadata[wordNumber]!
                tmp[characterNumber] = characterClass
                textMetadata[wordNumber] = tmp
            }
            objc_sync_exit(self)
            DispatchQueue.main.async {
                //self.doTextDetection(currentObservation: currentObservation)
                self.showDetectedText()
            }
        }
    
    func showDetectedText() {
        var result = ""
        if (textMetadata.isEmpty) {
            print("empty")
            return
        }
        let sortedKeys = textMetadata.keys.sorted()
        for sortedKey in sortedKeys {
            result += word(fromDictionary: textMetadata[sortedKey]!) + " "
        }
        makeFoodList(listOfFoods: result)
    }
    
    func makeFoodList(listOfFoods: String) {
        self.foods = []
        let foodString = listOfFoods.components(separatedBy: " ")
        for food in foodString {
            foods.append(Food(name: food, price: 0))
        }
        performSegue(withIdentifier: "priceSegue", sender: nil)
    }
        
        func doTextDetection(currentObservation : VNTextObservation) {
            var result: String = ""
            if (textMetadata.isEmpty) {
                print("The image does not contain any text.")
                return
            }
            let sortedKeys = textMetadata.keys.sorted()
            for sortedKey in sortedKeys {
                result +=  word(fromDictionary: textMetadata[sortedKey]!) + " "
                
            }
            
            observationStringLookup[currentObservation] = result
            
        }
        
        func word(fromDictionary dictionary: [Int : String]) -> String {
            let sortedKeys = dictionary.keys.sorted()
            var word: String = ""
            for sortedKey in sortedKeys {
                let char: String = dictionary[sortedKey]!
                word += char
            }
            return word
        }
        
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
        -Takes the selected image and displays it
    */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            photoBillView.image=selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Action
    /*
        -Opens user's photo library and allows them to choose the wanted photo
    */
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Segue
    /*
        -Checks if the correct segue is called
    */
    //connected the button - should this method signature  replace prepare for segue's signature or somehow combine differently
    @IBAction func processSegue(_ sender: UIButton) {
        createVisionRequest(image: photoBillView.image!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            
            if let priceVC = segue.destination as? PriceTableViewController {
                
                priceVC.foods = foods
                priceVC.passedImage = photoBillView.image
                //priceVC.processedImageView.image = photoImageView.image
                //processVC.passedImage = sender as? UIImage
            
        }
    }
    

}
