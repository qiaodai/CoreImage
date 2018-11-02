//
//  DQFilterOneViewController.swift
//  PictureEdit
//
//  Created by wond on 2018/11/2.
//  Copyright © 2018 wond. All rights reserved.
//

import UIKit

class DQFilterOneViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    var context: CIContext!
    var filter: CIFilter!
    var beginImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage.init(contentsOfFile: Bundle.main.path(forResource: "1", ofType: "jpg")!)

        beginImage = CIImage(contentsOf: Bundle.main.url(forResource: "1", withExtension: "jpg")!)
        
        filter = CIFilter (name: "CISepiaTone")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputIntensityKey)
        context = CIContext(options:nil)

    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let intensity = sender.value
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        let outputImage = filter.outputImage
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
       
        let newImage = UIImage(cgImage: cgimg!)
        self.imageView.image = newImage
        
    }
//    
//    func outputImageWithFilterName(_ filterName: String) -> UIImage  {
//        
//        // 1. 将UIImage转换成CIImage
//        let ciImage = CIImage.init(image: self.imageView.image!)
//        
//        // 2. 创建滤镜
//        self.filter = CIFilter.init(name: filterName, withInputParameters: [kCIInputImageKey : ciImage as Any])
//        // 设置相关参数
//        self.filter.setValue(0.5, forKey: kCIInputIntensityKey)
//        
//        // 3. 渲染并输出CIImage
//        let outPutImage = self.filter.outputImage
//        
//        // 4. 获取绘制上下文
//        self.context = CIContext.init(options: nil)
//        
//        // 5. 创建输出CGImage
//        let cgImage = self.context.createCGImage(outPutImage!, from: outPutImage!.extent)
//        let image = UIImage.init(cgImage: cgImage!)
//        
//        return image;
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
