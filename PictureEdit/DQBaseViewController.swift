//
//  DQBaseViewController.swift
//  PictureEdit
//
//  Created by wond on 2018/11/2.
//  Copyright © 2018 wond. All rights reserved.
//

import UIKit

class DQBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem.init(title: "滤镜应用", style: UIBarButtonItem.Style.plain, target: self, action:#selector(didNavBtnClick))
        self.navigationItem.rightBarButtonItems = [rightBarButton]
    }
    
    @objc func didNavBtnClick(){

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
