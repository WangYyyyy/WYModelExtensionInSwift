//
//  ViewController.swift
//  WYModelExtension
//
//  Created by wangyu on 2016/12/29.
//  Copyright © 2016年 Wangyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelsDict = [["containLabel":"包含的label", "containNumber":888], ["containLabel":"包含的label", "containNumber":888], ["containLabel":"包含的label", "containNumber":888]]
        let dict = ["label":"哈哈哈", "number":89, "double":1.22, "model":["containLabel":"包含的label", "containNumber":888], "models":modelsDict] as [String : Any]
        
        let model = TestModel(creatObjectByDictionary: dict)
        
        print(model)
        print(model.label)
        print(model.model?.containLabel)
        print(model.models)
        
        
        let modelsDict2 = [dict, dict, dict, dict, dict]
        let models = TestModel.creatObjectsByDictArray(dictArray: modelsDict2)
        print(models)
        let model2 = models.first as! TestModel
        print(model2)
        print(model2.label)
        print(model2.model?.containLabel)
        print(model2.models)

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

