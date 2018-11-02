//
//  DQFiterTwoViewController.swift
//  PictureEdit
//
//  Created by wond on 2018/11/2.
//  Copyright © 2018 wond. All rights reserved.
//

import UIKit

class DQFiterTwoViewController: DQBaseViewController {
    
    var context: CIContext!
    var filter: CIFilter!
    var beginImage: CIImage!
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.contentMode = .scaleToFill
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var silder: UISlider = {
        let slider  = UISlider.init()
        slider.value = 0.0
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.imageView.image = UIImage.init(contentsOfFile: Bundle.main.path(forResource: "1", ofType: "jpg")!)
        self.view.backgroundColor = UIColor.white
        self.imageView.frame = CGRect.init(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
        self.view.addSubview(self.imageView)
        self.silder.frame = CGRect.init(x: 20, y: 60 + self.imageView.frame.maxY + 30, width: UIScreen.main.bounds.width - 40, height: 40)
        self.view.addSubview(self.silder)
        self.silder.addTarget(self, action: #selector(sliderValueChanged), for: UIControl.Event.valueChanged)
        
        self.imageView.image = UIImage.init(contentsOfFile: Bundle.main.path(forResource: "1", ofType: "jpg")!)
        beginImage = CIImage(contentsOf: Bundle.main.url(forResource: "1", withExtension: "jpg")!)
        context = CIContext(options:nil)
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {

        let intensity = sender.value
        //1 CISepiaTone 棕褐色调
        let img = self.beginImage
        let sepia = CIFilter(name: "CISepiaTone")
        sepia?.setValue(img, forKey: kCIInputImageKey)
        sepia?.setValue(intensity, forKey: "inputIntensity")
        
        //2 设置一个过滤器，创建一个随机噪声模式
        let random = CIFilter(name: "CIRandomGenerator")
        
        //3 改变随机噪声发生器的输出
        let lighten = CIFilter(name:"CIColorControls")
        lighten?.setValue(random?.outputImage, forKey:kCIInputImageKey)
        lighten?.setValue(1 - intensity, forKey:"inputBrightness")
        lighten?.setValue(0, forKey:"inputSaturation")
        
        //4 cropping(to rect: CGRect)输出CIImage并将其作用到所提供的rect
        let croppedImage = lighten?.outputImage?.cropped(to: beginImage.extent)
        
        //5 将棕褐色滤镜的输出与CIRandomGenerator滤镜的输出相结合。
        let composite = CIFilter(name:"CIHardLightBlendMode")
        composite?.setValue(sepia?.outputImage, forKey:kCIInputImageKey)
        composite?.setValue(croppedImage, forKey:kCIInputBackgroundImageKey)
        
        //6 合成输出上运行晕影滤镜(vignette filter)，使照片的边缘变暗
        let vignette = CIFilter(name:"CIVignette")
        vignette?.setValue(composite?.outputImage, forKey:kCIInputImageKey)
        vignette?.setValue(intensity * 2, forKey:"inputIntensity")
        vignette?.setValue(intensity * 30, forKey:"inputRadius")
        
        let cgimg = context.createCGImage(vignette!.outputImage!, from: vignette!.outputImage!.extent)
        let newImage = UIImage(cgImage: cgimg!)
        self.imageView.image = newImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
/*
解析以上代码：
1、像在简单的场景中所做的一样，设置棕褐色滤镜。您在方法中传入浮点值以设置深色效果的强度。该值将由滑块提供。
2、设置一个过滤器，创建一个如下所示的随机噪声模式：


#imageLiteral(resourceName: "1396454-044e9cba7f0355ea.gif")
 
CIRandomGenerator

它不需要任何参数。您将使用这种噪音模式将纹理添加到最终的“旧照片”外观。
3、改变随机噪声发生器的输出。你想把它改成灰度，并减轻一点点，所以效果不那么戏剧化。您会注意到，输入图像键被设置为随机过滤器的outputImage属性。这是一个方便的方式来传递一个过滤器的输出作为下一个的输入。
4、 cropping(to rect: CGRect)输出CIImage并将其作用到所提供的rect。在这种情况下，您需要裁剪CIRandomGenerator过滤器的输出，因为它无限制地打砖块。如果您在某些时候没有裁剪，就会出现一个错误，表示过滤器具有“无限长度”。CIImages实际上并不包含图像数据，它们描述了创建它的“配方”。直到你在CIContext上调用一个方法来实际处理数据。
5、将棕褐色滤镜的输出与CIRandomGenerator滤镜的输出相结合。该过滤器执行与Photoshop图层中的“硬光”设置完全相同的操作。使用Core Image可以实现Photoshop中的大多数滤镜选项。
6、在此合成输出上运行晕影滤镜，使照片的边缘变暗。您正在使用滑块的值来设置此效果的半径和强度。
7、返回最后一个过滤器的输出。

*/
