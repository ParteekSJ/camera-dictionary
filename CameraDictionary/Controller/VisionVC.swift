//
//  VisionVC.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/5/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class VisionVC: UIViewController {
    var captureSession : AVCaptureSession! //Control the real time capture
    var cameraOutput : AVCapturePhotoOutput! //Interface for capturing photos
    var previewLayer : AVCaptureVideoPreviewLayer! //Visual Output
    
    var correctWords : [Word] = []
    var photoData : Data?
    
    var welcomemessage : Bool = UserDefaults.standard.bool(forKey: "welcomemessage")
    
    
    @IBOutlet var captureImageView: RoundedShadowImageView!
    @IBOutlet var cameraView: UIView! //Main View
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Disabling all the camera animations (genie effect)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        previewLayer.frame = cameraView.bounds
        CATransaction.commit()
        
        if welcomemessage {
            //The alert has been shown. No need to show again.
        } else {
            //Alert hasn't been shown yet. Show it now and save it in the userdefaults.
            let alertController = UIAlertController(title: "How-to-Use", message: "1. Point the Camera at the word you don't understand \n 2. Take a picture. \n Camera Dictionary will show you the meaning or meanings.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true)
            
            //After showing the alert
//            UserDefaults.standard.set(true, forKey: "welcomemessage")
        }

        
    }
    
    @IBAction func unwindFromScannedWord(unwindSegue : UIStoryboardSegue){
    }
    
    @IBAction func unwindFromNoText(unwindSegue : UIStoryboardSegue){
       }
    
    //Hiding the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //Initailising the capture session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(cameraOutput) == true {
                captureSession.addOutput(cameraOutput!)
    
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                captureSession.startRunning()                
            }
        } catch {
            debugPrint(error)
        }
        
    }
    
    @IBAction func cameraBtnWasPressed(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String : 160, kCVPixelBufferHeightKey as String: 160]
        
        //Format for the delivery of preview sized images
        settings.previewPhotoFormat = previewFormat
        
        cameraOutput.capturePhoto(with: settings, delegate: self)
        
        
    }
    
    lazy var textDetectionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_GB"]
        request.usesLanguageCorrection = true
        //request.revision = VNRecognizeTextRequestRevision1
        return request
    }()
    
    
    
    func processImage(inputimage : UIImage!) {
        guard let image = inputimage, let cgImage = image.cgImage else { return }
        
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if let error = error {
            print("ERROR: \(error)")
            return
        }
        
        guard let results = request?.results, results.count > 0 else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toNoTextFound", sender: nil)
                print("No text found")
            }
            return}
    
        
        var recognizedText = [RecognisedText]()
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                for text in observation.topCandidates(1) {
                    let txt = RecognisedText()
                    txt.x = observation.boundingBox.origin.x
                    txt.y = observation.boundingBox.origin.y
                    txt.text = text.string
                    
                    recognizedText.append(txt)
                    print(text.string)
                    print(text.confidence)
                    print(observation.boundingBox)
                    print("\n")
                }
            }
        }
        
        guard let textObject = recognizedText.first else { return }
    
        var finalText = textObject
        for txt in recognizedText {
            if txt.x < finalText.x && txt.y > finalText.y {
                finalText = txt
            }
        }

        DispatchQueue.main.async {
            print(finalText.text)
            var recWord = Word(word: finalText.text)
            self.correctWords = self.spellCheck(x: finalText.text)
            if self.correctWords.isEmpty {
                self.performSegue(withIdentifier: "ScannedWordSegue", sender: finalText.text)
            } else {
                self.correctWords.append(recWord)
                self.performSegue(withIdentifier: "WrongScannedWord", sender: self.correctWords)
                print(self.correctWords.count)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("1")
        if segue.identifier == "ScannedWordSegue"{
            if let destVC = segue.destination as? ScannedWordVC {
                destVC.scannedword = sender as! String
                print("2")
            }
        }
            else if segue.identifier == "WrongScannedWord" {
                if let destVC = segue.destination as? WrongScannedWord {
                    destVC.wordsArr = sender as! [Word]
                    print("3")
                    
                }
            }
    }
    
    
        // Method to check spelling.
        func spellCheck(x : String) -> [Word] {
            
            var tempWords : [Word] = []
            
            // Declaration of UITextChecker.
            let checker : UITextChecker = UITextChecker()
            
            // Get the number of characters in text.
            let length = x.count
            
            // Specify the spelling range (0 ~ number of entered characters).
            let checkRange: NSRange = NSMakeRange(0, x.count)
            
            // Look for things with wrong spelling from the range.
            let misspelledRange: NSRange = checker.rangeOfMisspelledWord(
                
                // Specify the character to check.
                in: x,
                
                // Specify the range to check.
                range: checkRange,
                
                // Specify the start position as the beginning of the range.
                startingAt: checkRange.location,
                
                // Even if no mistakes are found within the specified range start searching from the range start position (false hold the end position where no mistakes were found)
                wrap: true,
                
                // Specify language as English.
                language: "en_US")
            
            // If a misspelling is found.
            if misspelledRange.location != NSNotFound {
                
                // Obtain correct spelling candidates.
                let candidateArray: [String] = checker.guesses(
                    
                    // The range where there is a misspelling.
                    forWordRange: misspelledRange,
                    
                    // Characters containing misspellings (in range).
                    in: x,
                    
                    // Specify the language.
                    language: "en_US")!
                
                var str = "By any chance:\n"
                
                if candidateArray.isEmpty {
                    print("Correct Word")
                } else {
                    // Retrieve the candidates one by one from the array.
                    for text in candidateArray {
                        str += text.description
                        str += ", "
                        let temp = Word(word: text.description)
                        tempWords.append(temp)
                    }
                    print(str)
                }
            }
            return tempWords
        }

    }

func handleDetectedText(request: VNRequest?, error: Error?) {
    if let error = error {
        print("ERROR: \(error)")
        return
    }
    guard let results = request?.results, results.count > 0 else {
        print("No text found")
        return
    }

    for result in results {
        if let observation = result as? VNRecognizedTextObservation {
            for text in observation.topCandidates(1) {
                print(text.string)
                print(text.confidence)
                print(observation.boundingBox)
                print("\n")
            }
        }
    }
}


extension VisionVC : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            //Getting the photodata
            photoData = photo.fileDataRepresentation()
            //Creating a UIImage from that data
            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
            
            processImage(inputimage: image)

        }
    }
    
    
}












//Camera Check
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            print("No camera avaiable.")
//            return
//        }
