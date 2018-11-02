//
//  ViewController.swift
//  PictureEdit
//
//  Created by wond on 2018/10/31.
//  Copyright © 2018年 wond. All rights reserved.
//

import UIKit
import CoreImage
import HXPhotoPicker
class DQMainViewController: DQBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var dataSource:[String] = [String]()
    
    var filter: CIFilter!
    
    var context:CIContext!
    
    lazy var manager:HXPhotoManager = {

        let manager = HXPhotoManager.init(type: HXPhotoManagerSelectedType.photoAndVideo)
        manager!.configuration.openCamera = false
        manager!.configuration.lookLivePhoto = true
        manager!.configuration.photoMaxNum = 1
        manager!.configuration.videoMaxNum = 1
        manager!.configuration.maxNum = 1
        manager!.configuration.videoMaxDuration = 500
        manager!.configuration.saveSystemAblum = true
        manager!.configuration.showDateSectionHeader = false
        manager!.configuration.selectTogether = false
        manager!.configuration.requestImageAfterFinishingSelection = true
        manager!.configuration.albumShowMode = HXPhotoAlbumShowMode.popup;
        return manager!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let flowLayOut = UICollectionViewFlowLayout.init()
        flowLayOut.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayOut.minimumLineSpacing = 10
        flowLayOut.minimumInteritemSpacing = 10
        
        self.collectionView.register(DQFilterCollectionCell.self, forCellWithReuseIdentifier: "DQFilterCollectionCell")
        self.collectionView.collectionViewLayout = flowLayOut
        
    }
    
    func outputImageWithFilterName(_ filterName: String) -> UIImage  {
        
        // 1. 将UIImage转换成CIImage
        let ciImage = CIImage.init(image: self.imageView.image!)

        // 2. 创建滤镜
        self.filter = CIFilter.init(name: filterName, parameters: [kCIInputImageKey : ciImage as Any])
        // 设置相关参数
        self.filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        // 3. 渲染并输出CIImage
        let outPutImage = self.filter.outputImage
        
        // 4. 获取绘制上下文
        self.context = CIContext.init(options: nil)
        
        // 5. 创建输出CGImage
        let cgImage = self.context.createCGImage(outPutImage!, from: outPutImage!.extent)
        let image = UIImage.init(cgImage: cgImage!)

        return image;
    }
    
    @objc override func didNavBtnClick(){

        self.imageView.image =  outputImageWithFilterName("CISepiaTone")
    }
    
    
    @IBAction func chooseMediaObject(_ sender: Any) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
    }
    
    deinit {
        print("deinit.......")
    }

}

extension DQMainViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DQFilterCollectionCell", for: indexPath) as! DQFilterCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class DQFilterCollectionCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clear
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
}
