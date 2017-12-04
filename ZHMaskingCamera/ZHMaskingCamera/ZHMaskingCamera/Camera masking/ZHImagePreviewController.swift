//
//  ZHImagePreviewController.swift
//  Zeeshan Haider
//
//  Created by Zeeshan Haider on 02/12/2017.
//  Copyright © 2017 ZHMaskingCamera. All rights reserved.
//

import UIKit

class ZHImagePreviewController: UIViewController {
    
    @IBOutlet weak var constraintWidthImageView : NSLayoutConstraint!
    public weak var delegate : ZHCameraViewDelegate?
    let rectLayer = CAShapeLayer()
    let maskLayer = CALayer()
    private var _maskingImage : UIImage!
    var maskingImage : UIImage{
        
        get{
            return _maskingImage
        }
        set{
            _maskingImage = newValue
            
            
        }
    }
    private var _image : UIImage?
    var image : UIImage?{
        
        get{
            return _image!
        }
        set{
            _image = newValue
        }
    }
    @IBOutlet weak var caprturesImageView: UIImageView!
    
    override func viewWillDisappear(_ animated: Bool) {
//        let image = ZHUtility.maskImage(image: self.image!, maskImage: self.maskingImage)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupView()
    }
    
    @IBAction func finishedTouchedUpInside(_ sender : UIButton){
        self.navigationController?.dismiss(animated: true, completion: {
            if self.delegate != nil {
                let image = ZHUtility.maskImage(image: self.image!, maskImage: self.maskingImage)
                self.delegate?.didCaptureAndMaskedImage!(image!,originalImage: self.image!)
            }
        })
    }
}

// MARK: - InitView
extension ZHImagePreviewController {
    func setupView() {
        self.view.backgroundColor = UIColor.black
        self.view.layer.mask = nil
        constraintWidthImageView.constant = self.maskingImage.size.width
        self.view.layoutSubviews()
        if let img = self.image {
            self.caprturesImageView.image = img
            rectLayer.frame = CGRect(x: self.view.center.x - constraintWidthImageView.constant/2, y: self.view.center.y - constraintWidthImageView.constant/2, width: constraintWidthImageView.constant, height: constraintWidthImageView.constant)

            rectLayer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
            rectLayer.contents = ZHUtility.resizeImage(image: self.maskingImage, targetSize: rectLayer.frame.size).cgImage

            maskLayer.frame = self.view.bounds
            maskLayer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
            maskLayer.addSublayer(rectLayer)

            self.view.layer.mask = maskLayer
        }
        
    }
}

                                                                                                                                                                                                                                                                                                                        
