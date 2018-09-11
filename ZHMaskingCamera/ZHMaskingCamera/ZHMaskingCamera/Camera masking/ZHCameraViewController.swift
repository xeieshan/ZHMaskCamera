//
//  ZHCameraViewController.swift
//  Zeeshan Haider
//
//  Created by Zeeshan Haider on 02/12/2017.
//  Copyright © 2017 ZHMaskingCamera. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol ZHCameraViewDelegate  {
    @objc optional func didCaptureAndMaskedImage(_ image: UIImage, originalImage: UIImage)
}

@objc class ZHCameraViewController: UIViewController {
    private var isMaskedImageResized : Bool = false
    @IBOutlet weak var btnTorch : UIButton!
    public weak var delegate : ZHCameraViewDelegate?
    private var _maskingImage : UIImage!
    var maskingImage : UIImage{
        get{
            return _maskingImage
        }
        set{
            _maskingImage = newValue
        }
    }
    
    var cManager = ZHCameraManager()
  
    let maskLayer = CALayer()
    let rectLayer = CAShapeLayer()
    
    @IBOutlet weak var viewCamera: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maskingImage = #imageLiteral(resourceName: "Xbox360Mask.png")
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        cManager.runCaptureSession()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cManager.stopCaptureSession()
        
        cManager.torchModeOff()
        btnTorch.isSelected = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        cManager.transitionCamera()
    }
    
    override func viewDidLayoutSubviews() {
        self.cManager.updatePreviewFrame()
        drawMaskingView()
    }
    
    /**
     this func will draw a rect mask over the camera view
     */
    func drawMaskingView() {
        
        viewCamera.layer.mask = nil
        
        let cameraSize = self.viewCamera!.frame.size
        
        
        var frameHeight: CGFloat = 0.0
        
        var frameWidth: CGFloat =  0.0
        
        var originY: CGFloat = 0.0
        
        var originX: CGFloat = 0.0
        
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        switch (orientation) {
        case .landscapeRight, .landscapeLeft:
            frameWidth = cameraSize.width/CGFloat(ZHConstants.cameraRatio)
            frameHeight = frameWidth //(cameraSize.height)/1.4
            originY = ((cameraSize.height - frameHeight)/2)
            originX = (cameraSize.width - frameWidth)/2
            break
        default:
            
            frameWidth = cameraSize.width/CGFloat(ZHConstants.cameraRatio)
            frameHeight = frameWidth //(cameraSize.height)/1.5
            originY = ((cameraSize.height - frameHeight)/2)
            originX = (cameraSize.width - frameWidth)/2
            break
        }
        
        rectLayer.frame = CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight)
        
        if !isMaskedImageResized {
            isMaskedImageResized = true
            self.maskingImage = ZHUtility.resizeImage(image: self.maskingImage, targetSize: rectLayer.frame.size)
        }
        
        rectLayer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
        rectLayer.contents = self.maskingImage.cgImage
    
        maskLayer.frame = viewCamera.bounds
        maskLayer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
        maskLayer.addSublayer(rectLayer)
    
        viewCamera.layer.mask = maskLayer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ZHImagePreviewController" {
            (segue.destination as? ZHImagePreviewController)?.image = sender as? UIImage
            (segue.destination as? ZHImagePreviewController)?.maskingImage = self.maskingImage
            (segue.destination as? ZHImagePreviewController)?.delegate = self.delegate
        }
    }
    
    //MARK: - Actions
    @IBAction func changeCameraTouchedUpInside(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            cManager.captureSetup(in: self.viewCamera, withPosition: .front)
        }else{
            cManager.captureSetup(in: self.viewCamera, withPosition: .back)
        }
    }
    @IBAction func closeButtonTouchedUpInside(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    @IBAction func useFlashButtonTouchedUpInside(_ sender: UIButton) {
//        captureAndCropp()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            cManager.enableTorchMode(level: 1)
        }else{
            cManager.torchModeOff()
        }
    }
    
    @IBAction func tapGestureAction(_ sender: Any) {
        captureAndCropp()
    }
    
    func captureAndCropp() {
        self.cManager.getImage(croppWith: self.rectLayer.frame) { [unowned self]
            (croppedImage, error) -> Void in
            OperationQueue.main.addOperation({
                if croppedImage != nil {
                    self.performSegue(withIdentifier: "ZHImagePreviewController", sender: croppedImage)
                }
            })
        }
    }
}

// MARK: - InitView
extension ZHCameraViewController {
    func setupView() {
        if ZHConstants.kIS_IPAD {
            btnTorch.isHidden = true
        }
        cManager.captureSetup(in: self.viewCamera, withPosition: .back)
        
    }
}


