//
//  DQPictureEditViewController.swift
//  PictureEdit
//
//  Created by wond on 2018/11/2.
//  Copyright © 2018 wond. All rights reserved.
//

import UIKit
import HXPhotoPicker
class DQPictureEditViewController: DQBaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var manager:HXPhotoManager = {
        let manager = HXPhotoManager.init(type: HXPhotoManagerSelectedType.photoAndVideo)
        manager!.configuration.singleSelected = true
        manager!.configuration.albumListTableView = { (tableView) in
            print("tableVeiw.....")
            return
        }
        manager!.configuration.singleJumpEdit = false
        manager!.configuration.movableCropBox = true
        manager!.configuration.movableCropBoxEditSize = true
        manager!.configuration.albumShowMode = HXPhotoAlbumShowMode.popup
        return manager!
    }()
    
    lazy var toolManager:HXDatePhotoToolManager = {
        let toolManager = HXDatePhotoToolManager.init()
        return toolManager
        
    }()
    
    lazy var originalImage: UIImage = {
        return UIImage(named: "Image")!
    }()
    
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    
    var filter: CIFilter!

    var dataSource:[DQFiterModel] = [DQFiterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem.init(title: "选择照片", style: UIBarButtonItem.Style.plain, target: self, action:#selector(didNavBtnClick))
        self.navigationItem.rightBarButtonItems = [rightBarButton]
        
        let names = ["原图","怀旧","色调","岁月","黑白","褪色","冲印","烙黄","单色","自动改善"]
        let keys = ["原图","CIPhotoEffectInstant","CIPhotoEffectTonal","CIPhotoEffectTransfer","CIPhotoEffectNoir","CIPhotoEffectFade","CIPhotoEffectProcess","CIPhotoEffectChrome","CIPhotoEffectMono",""]
        for i in 0..<names.count{
            let model = DQFiterModel.init()
            model.filterName = names[i]
            model.filterKey = keys[i]
            self.dataSource.append(model)
        }
        let flowLayOut = UICollectionViewFlowLayout.init()
        flowLayOut.sectionInset = UIEdgeInsets.init(top: 0, left: 50, bottom: 0, right: 50)
        flowLayOut.itemSize = CGSize.init(width: 80, height: 80)
        flowLayOut.minimumLineSpacing = 10
        flowLayOut.minimumInteritemSpacing = 10
        flowLayOut.scrollDirection = .horizontal
        
        self.collectionView.register(DQFilterNameCollectionCell.self, forCellWithReuseIdentifier: "DQFilterNameCollectionCell")
        self.collectionView.collectionViewLayout = flowLayOut
        self.collectionView.reloadData()
        
        self.imageView.layer.shadowOpacity = 0.8
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        self.imageView.image = originalImage
    }
    
    @objc override func didNavBtnClick(){
        self.manager.configuration.saveSystemAblum = true
        weak var weakSelf = self
        if self.manager.configuration.requestImageAfterFinishingSelection {
            self.hx_presentSelectPhotoController(with: weakSelf?.manager, didDone: { (allList, photoList, videoList, isOriginal, viewController, manager) in
                
            }, imageList: { (imageList, isOriginal) in
                weakSelf?.originalImage = imageList![0]
                weakSelf?.imageView.image = imageList![0]
            }) { (viewController, manager) in
                print("取消了")
            }
        }else{
            
            
        }
    }
    
    func outputImage() {
        print(filter)
        DispatchQueue.global().async {
            let inputImage = CIImage(image: self.originalImage)
            self.filter.setValue(inputImage, forKey: kCIInputImageKey)
            let outputImage =  self.filter.outputImage!
            if let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(cgImage: cgImage)
                }
            }
        }
    }

}

extension DQPictureEditViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DQFilterNameCollectionCell", for: indexPath) as! DQFilterNameCollectionCell
        let model = self.dataSource[indexPath.row]
        cell.titleLabel.text = model.filterName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.imageView.image = originalImage
        }else if indexPath.row == self.dataSource.count - 1 {
            var inputImage = CIImage(image: originalImage)!
            let filters = inputImage.autoAdjustmentFilters(options: nil)
            for filter: CIFilter in filters {
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                inputImage = filter.outputImage!
            }
            if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
                self.imageView.image = UIImage(cgImage: cgImage)
            }
        }else{
            let model = self.dataSource[indexPath.row]
            filter = CIFilter(name: model.filterKey!)
            outputImage()
        }
    }
}
class DQFilterNameCollectionCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        titleLabel.frame = self.bounds
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected == true{
                self.layer.borderColor = UIColor.red.cgColor
            }else{
                self.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
}
