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

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // Start the camera
       let captureCamera = AVCaptureSession()
        captureCamera.sessionPreset = .photo
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        captureCamera.addInput(cameraInput)
        
        captureCamera.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureCamera)
        
        view.layer.addSublayer(previewLayer)
        
        previewLayer.frame = view.frame
        
    }


}

