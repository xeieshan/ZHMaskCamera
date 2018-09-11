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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupView()
    }
    
    @IBAction func finishedTouchedUpInside(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
//        if self.delegate != nil {
//            let image = ZHUtility.maskImage(image: self.image!, maskImage: self.maskingImage)
//            self.delegate?.didCaptureAndMaskedImage!(image!,originalImage: self.image!)
//        }
    }
}

// MARK: - InitView
extension ZHImagePreviewController {
    func setupView() {
        self.view.backgroundColor = UIColor.black
        constraintWidthImageView.constant = self.maskingImage.size.width
        self.view.layoutSubviews()
        let image = ZHUtility.maskImage(image: self.image!, maskImage: self.maskingImage)
        self.caprturesImageView.image = image
        
    }
}

                                                                                                                                                                                                                                                                                                                        
