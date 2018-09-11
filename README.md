# ZHMaskCamera
It will show overlay as per masked image in camera preview, When You capture image, it show the overlay as is and it returns u a masked image removing the part you didn’t want to capture.

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


