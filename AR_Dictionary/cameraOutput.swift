//
//  cameraOutput.swift
//  AR_Dictionary
//
//  Created by Miraj Brahmbhatt on 5/13/19.
//  Copyright © 2019 Miraj Brahmbhatt. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision

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
    }
    
    try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([mlRequest])
    
}
