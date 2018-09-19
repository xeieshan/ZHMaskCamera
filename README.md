# ZHMaskCamera
It will show overlay as per masked image in camera preview, When You capture image, it show the overlay as is and it returns u a masked image removing the part you didn’t want to capture.

*Works with iPad, iPhoneX, iPhone 8Plus, iPhone 8, iPhone SE*
*Works with latest iOS and Xcode*

This app requires to access your camera to capture image with mask layer and then afterwards masks image.

Assign maskingImage in ZHCameraViewController.swift class.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        self.maskingImage = #imageLiteral(resourceName: "Xbox360Mask.png")
        // Image Xbox360Mask.png is added in assets
        setupView()
}
```

The `maskingImage` I am using is this : 
![Masking Image Xbox Controller](https://github.com/xeieshan/ZHMaskCamera/blob/master/ZHMaskingCamera/ZHMaskingCamera/ZHMaskingCamera/Xbox360Mask.png)
**So you can see the results below using just masking image I can capture a masked image**

## Screenshots
### Splash screen
![Splash screen](https://github.com/xeieshan/ZHMaskCamera/blob/master/ZHMaskingCamera/ZHMaskingCamera/Screenshots/SplashScreen.jpg)

### Camera layer
![Camera](https://github.com/xeieshan/ZHMaskCamera/blob/master/ZHMaskingCamera/ZHMaskingCamera/Screenshots/Camera.jpg)

### While capturing try to center the object in mask
![Capturing](https://github.com/xeieshan/ZHMaskCamera/blob/master/ZHMaskingCamera/ZHMaskingCamera/Screenshots/Capturing.jpg)

### Masked image after capturing
![Masked after capturing](https://github.com/xeieshan/ZHMaskCamera/blob/master/ZHMaskingCamera/ZHMaskingCamera/Screenshots/CapturedMasked.jpg)

`Feel free to use`


