//
//  ViewController.swift
//  AR_Dictionary
//
//  Created by Miraj Brahmbhatt on 5/8/19.
//  Copyright © 2019 Miraj Brahmbhatt. All rights reserved.
//

import UIKit
import AVKit
import Vision



class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate
{
    //@IBOutlet weak var objectIdentity: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Start the camera
        let captureCamera = AVCaptureSession()
        
       // captureCamera.sessionPreset = .photo
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureCamera.addInput(cameraInput)
        
        captureCamera.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureCamera)
        
        view.layer.addSublayer(previewLayer)

        previewLayer.frame = view.frame

        //analyze video preview
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Dispatch Queue"))
        
        captureCamera.addOutput(videoDataOutput)
        
        
        
        
    }
    
    func cameraOutput(_ output: AVCaptureOutput, checkOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        guard let pixelBuffer: CVPixelBuffer =
            CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let mlModel = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        
        let mlRequest = VNCoreMLRequest(model: mlModel)
        { (endReqeust, err) in
            
            guard let results = endReqeust.results as? [VNClassificationObservation] else { return }
            guard let initialGuess = results.first else { return }
            
            print(initialGuess.identifier, initialGuess.confidence)
            print("hi")
            
            //objectIdentity.text = initialGuess.identitiy
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([mlRequest])
        
    }
    
    
    
}

