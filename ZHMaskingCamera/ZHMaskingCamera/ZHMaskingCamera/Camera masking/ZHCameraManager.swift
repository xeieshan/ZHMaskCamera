//
//  ZHCameraManager.swift
//  Zeeshan Haider
//
//  Created by Zeeshan Haider on 02/12/2017.
//  Copyright © 2017 ZHMaskingCamera. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

open class ZHCameraManager: NSObject {
    private enum CameraDevice {
        case back
        case front
    }
    
    private var cameraPosition : CameraDevice?
    private var viewCamera : UIView?
    weak private var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    fileprivate var imageOutput : AVCaptureStillImageOutput?
    
    fileprivate var captureSession: AVCaptureSession!
    
    
    open func captureSetup(in cameraView: UIView, withPosition cameraPosition: AVCaptureDevice.Position? = .back) {
        self.viewCamera = cameraView
        self.captureSession = AVCaptureSession()
        switch cameraPosition! {
        case .back:
            self.setupCapture(withDevicePosition: .back)
            self.cameraPosition = .back
        case .front:
            self.setupCapture(withDevicePosition: .front)
            self.cameraPosition = .front
        default:
            self.setupCapture(withDevicePosition: .back)
        }
    }
    
    open func runCaptureSession() {
        if (captureSession?.isRunning != true) {
            captureSession.startRunning()
        }
    }
    
    open func stopCaptureSession() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    open func updatePreviewFrame() {
        if viewCamera != nil {
            self.videoPreviewLayer?.frame = viewCamera!.bounds
        }
    }
    
    open func transitionCamera() {
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            if (previewLayerConnection.isVideoOrientationSupported)
            {
                switch (orientation)
                {
                case .portrait:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                    break
                case .landscapeRight:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    break
                case .landscapeLeft:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    break
                case .portraitUpsideDown:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                    break
                default:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                    break
                }
            }
        }
        
    }
    func torchModeOff() {
        for testedDevice in AVCaptureDevice.devices(for: AVMediaType.video){
            if ((testedDevice as AnyObject).position == AVCaptureDevice.Position.back && self.cameraPosition == .back) {
                let currentDevice = testedDevice as! AVCaptureDevice
                if currentDevice.isTorchAvailable && currentDevice.isTorchModeSupported(AVCaptureDevice.TorchMode.auto) {
                    do {
                        try currentDevice.lockForConfiguration()
                        if currentDevice.isTorchActive {
                            currentDevice.torchMode = AVCaptureDevice.TorchMode.off
                        } else {
//                            try currentDevice.setTorchModeOnWithLevel(0)
                        }
                        currentDevice.unlockForConfiguration()
                    } catch {
                        print("torch can not be enable")
                    }
                }
            }
        }
    }
    open func enableTorchMode(level: Float? = 1) {
        for testedDevice in AVCaptureDevice.devices(for: AVMediaType.video){
            if ((testedDevice as AnyObject).position == AVCaptureDevice.Position.back && self.cameraPosition == .back) {
                let currentDevice = testedDevice
                if currentDevice.isTorchAvailable && currentDevice.isTorchModeSupported(AVCaptureDevice.TorchMode.auto) {
                    do {
                        try currentDevice.lockForConfiguration()
                        if currentDevice.isTorchActive {
                            currentDevice.torchMode = AVCaptureDevice.TorchMode.off
                        } else {
                            try currentDevice.setTorchModeOn(level: level!)
                        }
                        currentDevice.unlockForConfiguration()
                    } catch {
                        print("torch can not be enable")
                    }
                }
            }
        }
    }
    
    open func getImage(croppWith rect: CGRect? = nil, completionHandler: @escaping (UIImage?, Error?) -> Void){
        
        var croppedImage : UIImage?
        if let videoConnection = imageOutput?.connection(with: AVMediaType.video) {
            imageOutput?.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                if imageDataSampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                    
                    let capturedImage : UIImage = UIImage(data: imageData!)!
                    
                    let originalSize : CGSize
                    let visibleLayerFrame = rect ?? self.viewCamera?.frame ?? CGRect.zero
                    
                    if let metaRect : CGRect = (self.videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: visibleLayerFrame)) {
                        if (capturedImage.imageOrientation == UIImageOrientation.left || capturedImage.imageOrientation == UIImageOrientation.right) {
                            
                            originalSize = CGSize(width: capturedImage.size.height, height: capturedImage.size.width)
                        }
                        else {
                            originalSize = capturedImage.size
                        }
                        
                        let x = metaRect.origin.x * originalSize.width
                        let y = metaRect.origin.y * originalSize.height
                        
                        let cropRect : CGRect = CGRect( x: x,
                                                        y: y,
                                                        width: metaRect.size.width * originalSize.width,
                                                        height: metaRect.size.height * originalSize.height).integral
                        
                        let imageOrientation : UIImageOrientation?
                        let currentDevice: UIDevice = UIDevice.current
                        let orientation: UIDeviceOrientation = currentDevice.orientation
                        if self.cameraPosition == .back {
                            switch (orientation) {
                            case .portrait:
                                imageOrientation = .right
                            case .portraitUpsideDown:
                                imageOrientation = .left
                            case .landscapeRight:
                                imageOrientation = .down
                            case .landscapeLeft:
                                imageOrientation = .up
                            default:
                                imageOrientation = .right
                                break
                            }
                        } else {
                            switch (orientation) {
                            case .portrait:
                                imageOrientation = .leftMirrored
                            case .portraitUpsideDown:
                                imageOrientation = .rightMirrored
                            case .landscapeRight:
                                imageOrientation = .upMirrored
                            case .landscapeLeft:
                                imageOrientation = .downMirrored
                            default:
                                imageOrientation = .leftMirrored
                                break
                            }
                        }
                        
                        croppedImage =
                            UIImage(cgImage: capturedImage.cgImage!.cropping(to: cropRect)!,
                                    scale:1,
                                    orientation: imageOrientation! )
                        
                        
                        //save the original and cropped image in gallery
                        //                        UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil)
                        //                        if croppedImage != nil {
                        //                            UIImageWriteToSavedPhotosAlbum(croppedImage!, nil, nil, nil)
                        //                        }
                    }
                }
                completionHandler(croppedImage, error)
            }
        }
        
    }
    
    fileprivate func setupCapture (withDevicePosition position : AVCaptureDevice.Position) {
        
        captureSession.stopRunning()
        captureSession = AVCaptureSession()
        videoPreviewLayer?.removeFromSuperlayer()
        
        var captureError : NSError?
        var captureDevice : AVCaptureDevice!
        
        //Device
        for testedDevice in AVCaptureDevice.devices(for: AVMediaType.video){
            if ((testedDevice as AnyObject).position == position) {
                captureDevice = testedDevice as! AVCaptureDevice
            }
        }
        if (captureDevice == nil) {
            captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        }
        
        //Input
        var deviceInput : AVCaptureDeviceInput?
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            captureError = error
            deviceInput = nil
            print("you dont have camera")
            return
        }
        
        //Output
        self.imageOutput = AVCaptureStillImageOutput()
        self.imageOutput?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        if (captureError == nil) {
            if (captureSession.canAddInput(deviceInput!)) {
                captureSession.addInput(deviceInput!)
            }
            
            
            if (captureSession.canAddOutput(self.imageOutput!)) {
                captureSession.addOutput(self.imageOutput!)
            }
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if viewCamera != nil {
            videoPreviewLayer?.frame = viewCamera!.bounds
        }
        
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        viewCamera?.layer.addSublayer(videoPreviewLayer!)
        
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        let previewLayerConnection =  self.videoPreviewLayer?.connection
        switch (orientation) {
        case .portrait:
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
            break
        case .landscapeRight:
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            break
        case .landscapeLeft:
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            break
        case .portraitUpsideDown:
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            break
        default:
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
            break
        }
        
        self.captureSession.startRunning()
        
    }
    
}
