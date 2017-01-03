//
//  SwiftModelExtension.swift
//  SwiftJSON
//
//  Created by wangyu on 2016/10/31.
//  Copyright © 2016年 Wangyu. All rights reserved.
//

import Foundation

let disabledKinds = [ImplicitlyUnwrappedOptional<Int>.self, Optional<Int>.self, ImplicitlyUnwrappedOptional<Double>.self, Optional<Double>.self, ImplicitlyUnwrappedOptional<Bool>.self, Optional<Bool>.self] as [Any.Type]

let transformAbleKinds = [ImplicitlyUnwrappedOptional<String>.self, Optional<String>.self, String.self, ImplicitlyUnwrappedOptional<Int>.self, Optional<Int>.self, Int.self, ImplicitlyUnwrappedOptional<Float>.self, Optional<Float>.self, Float.self, ImplicitlyUnwrappedOptional<Double>.self, Optional<Double>.self, Double.self, ImplicitlyUnwrappedOptional<Bool>.self, Optional<Bool>.self, Bool.self] as [Any.Type]

let bundleName = Bundle.main.infoDictionary![String(kCFBundleNameKey)]!

/// 是否开启日志打印
var logEnable_WYModelExt = true

func printDebug(_ item:Any) {
    
    if logEnable_WYModelExt {
        print(item)
    }
    
}

extension NSObject {
    
    class func creatObjectByDict(dict:Any) -> Any {
        let obj = self.init()
        
        let dictionary = dict as? Dictionary<String, Any>
        if dictionary == nil {
            printDebug("⛔️->> 参数数据不能转换成一个dictionary")
        }else {
            printDebug("✅->> 参数数据转换dictionary成功")
            let mir = Mirror.init(reflecting: obj)
            let mirChildren = mir.children
            printDebug("➡️当前类的属性总数为\(mirChildren.count)")
            for p in mirChildren {
                if p.label == nil {
                    printDebug("⚠️->> 属性名为空不处理")
                }else {
                    let value = dictionary![p.label!]
                    let vMir = Mirror.init(reflecting: p.value)
                    let secDict = value as? Dictionary<String, Any>
                    let secArray = value as? Array<Any>
                    let kindOfVariate = "\(vMir.subjectType)"
                    if secDict != nil {
                        //TODO:↩️当前数据的属性为一个对象, 进入处理对象属性函数操作
                        printDebug("↩️当前数据的属性:\(p.label!)为一个对象, 进入处理对象属性函数操作")
                        obj.setDataWithDict(dict: secDict!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: obj)
                    }else if secArray != nil {
                        //TODO:↩️当前数据的属性为一个数组, 进入处理数组函数操作
                        printDebug("↩️当前数据的属性:\(p.label!)为一个数组, 进入处理数组函数操作")
                        obj.setDataWithArray(array: secArray!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: obj)
                    }else if value == nil {
                        //TODO:⚠️当前数据的属性为空
                        printDebug("⚠️当前数据的属性:\(p.label!)为空")
                    }else {
                        //TODO:✅当前数据的属性正常处理
                        printDebug("✅\(p.label!)属性正常处理")
                        //TODO:检查属性
                        let isAble = obj.checkTypeIsAble(type: vMir.subjectType, variateName: p.label!)
                        if isAble {
                            obj.setValue(value, forKey: p.label!)
                        }
                        
                    }
                }
            }
        }
        
        return obj
    }
    
    convenience init(creatObjectByDictionary:Any) {
        self.init()
        
        let dictionary = creatObjectByDictionary as? Dictionary<String, Any>
        if dictionary == nil {
            printDebug("⛔️->> 参数数据不能转换成一个dictionary")
        }else {
            printDebug("✅->> 参数数据转换dictionary成功")
            let mir = Mirror.init(reflecting: self)
            let mirChildren = mir.children
            printDebug("➡️当前类的属性总数为\(mirChildren.count)")
            for p in mirChildren {
                if p.label == nil {
                    printDebug("⚠️->> 属性名为空不处理")
                }else {
                    let value = dictionary![p.label!]
                    let vMir = Mirror.init(reflecting: p.value)
                    let secDict = value as? Dictionary<String, Any>
                    let secArray = value as? Array<Any>
                    let kindOfVariate = "\(vMir.subjectType)"
                    if secDict != nil {
                        //TODO:↩️当前数据的属性为一个对象, 进入处理对象属性函数操作
                        printDebug("↩️当前数据的属性:\(p.label!)为一个对象, 进入处理对象属性函数操作")
                        self.setDataWithDict(dict: secDict!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: self)
                    }else if secArray != nil {
                        //TODO:↩️当前数据的属性为一个数组, 进入处理数组函数操作
                        printDebug("↩️当前数据的属性:\(p.label!)为一个数组, 进入处理数组函数操作")
                        self.setDataWithArray(array: secArray!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: self)
                    }else if value == nil {
                        //TODO:⚠️当前数据的属性为空
                        printDebug("⚠️当前数据的属性:\(p.label!)为空")
                    }else {
                        //TODO:✅当前数据的属性正常处理
                        printDebug("✅\(p.label!)属性正常处理")
                        //TODO:检查属性
                        let isAble = self.checkTypeIsAble(type: vMir.subjectType, variateName: p.label!)
                        if isAble {
                            self.setValue(value, forKey: p.label!)
                        }
                        
                    }
                }
            }
        }
    }
    
    class func creatObjectsByDictArray(dictArray:Any) -> Array<Any> {
        let totalArray = dictArray as? Array<Any>
        if totalArray == nil {
            printDebug("⛔️->> 参数数据不能转换成一个Array<Any>")
            return Array<Any>.init()
        }
        
        var result = Array<Any>.init()
        
        for i in totalArray! {
            let dict = i as? Dictionary<String, Any>
            if dict == nil {
                printDebug("⚠️当前数据的item转换dictionary为空 continue操作")
                continue
            }
            let obj = self.init()
            let mir = Mirror.init(reflecting: obj)
            let mirChildren = mir.children
            
            for p in mirChildren {
                if p.label == nil {
                    printDebug("⚠️->> 属性名为空不处理")
                }else {
                    let value = dict![p.label!]
                    let vMir = Mirror.init(reflecting: p.value)
                    let secDict = value as? Dictionary<String, Any>
                    let secArray = value as? Array<Any>
                    let kindOfVariate = "\(vMir.subjectType)"
                    if secDict != nil {
                        //TODO:↩️当前数据的属性为一个对象, 进入处理对象属性函数操作
                        printDebug("↩️当前数据的属性:\(p.label!)为一个对象, 进入处理对象属性函数操作")
                        obj.setDataWithDict(dict: secDict!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: obj)
                    }else if secArray != nil {
                        //TODO:↩️当前数据的属性为一个数组, 进入处理数组函数操作
                        printDebug("↩️当前数据的属性:\(p.label!)为一个数组, 进入处理数组函数操作")
                        obj.setDataWithArray(array: secArray!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: obj)
                    }else if value == nil {
                        //TODO:⚠️当前数据的属性为空
                        printDebug("⚠️当前数据的属性:\(p.label!)为空")
                    }else {
                        //TODO:✅当前数据的属性正常处理
                        printDebug("✅\(p.label!)属性正常处理")
                        //TODO:检查属性
                        let isAble = obj.checkTypeIsAble(type: vMir.subjectType, variateName: p.label!)
                        if isAble {
                            obj.setValue(value, forKey: p.label!)
                        }
                    }
                }
            }
            result.append(obj)
        }
        return result
    }
    
    //MARK: 递归set属性对象的各个值 包括实例化对象, set各个父子级的属性
    
    /// 递归set属性对象的各个值 包括实例化对象, set各个父子级的属性
    ///
    /// - Parameters:
    ///   - dict: 数据的字典
    ///   - kindOfVariate: 对象的类型名称
    ///   - variateName: 对象在父级的属性名称
    ///   - superClass: 对象的父级对象
    func setDataWithDict(dict:Dictionary<String, Any>, kindOfVariate:String, variateName:String, superClass:AnyObject) {
        var classType = kindOfVariate
        classType = classType.replacingOccurrences(of: "ImplicitlyUnwrappedOptional<", with: "")
        classType = classType.replacingOccurrences(of: ">", with: "")
        classType = classType.replacingOccurrences(of: "Optional<", with: "")
        classType = classType.replacingOccurrences(of: ">", with: "")
        let obj:AnyClass? = objc_lookUpClass("\(bundleName).\(classType)")
        let newobj = (obj as! NSObject.Type).init()
        let mir = Mirror.init(reflecting: newobj)
        let mirChildren = mir.children
        printDebug("➡️属性\(variateName)的对象类型是:\(classType)属性总数为\(mirChildren.count)")
        
        for p in mirChildren {
            if p.label == nil {
                printDebug("⚠️->> 属性名为空不处理")
            }else {
                let value = dict[p.label!]
                let vMir = Mirror.init(reflecting: p.value)
                let secDict = value as? Dictionary<String, Any>
                let secArray = value as? Array<Any>
                let kindOfVariate = "\(vMir.subjectType)"
                if secDict != nil {
                    //TODO:↩️当前数据的属性为一个对象, 进入处理对象属性函数操作
                    printDebug("↩️当前数据的属性:\(p.label!)为一个对象, 进入处理对象属性函数操作")
                    self.setDataWithDict(dict: secDict!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: newobj)
                }else if secArray != nil {
                    //TODO:↩️当前数据的属性为一个数组, 进入处理数组函数操作
                    printDebug("↩️当前数据的属性:\(p.label!)为一个数组, 进入处理数组函数操作")
                    self.setDataWithArray(array: secArray!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: newobj)
                }else if value == nil {
                    //TODO:⚠️当前数据的属性为空
                    printDebug("⚠️当前数据的属性:\(p.label!)为空")
                }else {
                    //TODO:✅当前数据的属性正常处理
                    printDebug("✅对象属性\(variateName)的\(p.label!)属性正常处理")
                    //TODO:检查属性
                    let isAble = self.checkTypeIsAble(type: vMir.subjectType, variateName: p.label!)
                    if isAble {
                        newobj.setValue(value, forKey: p.label!)
                    }
                }
            }
        }
        superClass.setValue(newobj, forKey: variateName)
    }
    
    //MARK:递归set属性对象的各个值 包括实例化对象.(数组处理)
    
    /// 递归set属性对象的各个值 包括实例化对象.(数组处理) 
    ///  Array<Array<Obj>> 嵌套 支持性未知
    ///  Array<obj>  obj中属性嵌套subObj对象 支持性未知
    ///
    /// - Parameters:
    ///   - array: 数据的数组
    ///   - kindOfVariate: 对象的类型名称
    ///   - variateName: 对象在父级的属性名称
    ///   - superClass: 对象的父级对象
    func setDataWithArray(array:Array<Any>, kindOfVariate:String, variateName:String, superClass:AnyObject) {
        
        if array.count <= 0 {
            printDebug("⚠️当前数据\(variateName)的数组为空")
            superClass.setValue([], forKey: variateName)
        }else {
            let item = array.first!
            let subDict = item as? Dictionary<String, Any>
            if subDict == nil {
                printDebug("✅当前数据\(variateName)的数组item为单个对象直接赋值")
                superClass.setValue(array, forKey: variateName)
            }else {
                printDebug("➡️当前数据\(variateName)的数组item为单对象属性, 进行对象赋值")
                var classType = kindOfVariate
                classType = classType.replacingOccurrences(of: "ImplicitlyUnwrappedOptional<", with: "")
                classType = classType.replacingOccurrences(of: ">", with: "")
                classType = classType.replacingOccurrences(of: "Optional<", with: "")
                classType = classType.replacingOccurrences(of: ">", with: "")
                classType = classType.replacingOccurrences(of: "Array<", with: "")
                classType = classType.replacingOccurrences(of: ">", with: "")
                let obj:AnyClass? = objc_lookUpClass("\(bundleName).\(classType)")
                var objArray = Array<Any>.init()
                for dict in array {
                    let newobj = (obj as! NSObject.Type).init()
                    let mir = Mirror.init(reflecting: newobj)
                    let mirChildren = mir.children
                    let objDict = dict as! Dictionary<String, Any>
                    
                    for p in mirChildren {
                        if p.label == nil {
                            printDebug("⚠️->> 属性名为空不处理")
                        }else {
                            let value = objDict[p.label!]
                            let vMir = Mirror.init(reflecting: p.value)
                            let secDict = value as? Dictionary<String, Any>
                            let secArray = value as? Array<Any>
//                            let kindOfVariate = "\(vMir.subjectType)"
                            if secDict != nil {
                                //TODO:↩️当前数据的属性为一个对象, 未知 EX: Array<obj>  obj中属性嵌套subObj对象
                                printDebug("↩️当前数据的属性:\(p.label!)为一个对象, 未知 EX: Array<obj>  obj中属性嵌套subObj对象")
                                self.setDataWithDict(dict: secDict!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: newobj)
                            }else if secArray != nil {
                                //TODO:↩️当前数据的属性为一个数组, 未知 EX: Array<Array<obj>>
                                printDebug("↩️当前数据的属性:\(p.label!)为一个数组, 未知 EX: Array<Array<obj>>")
                                self.setDataWithArray(array: secArray!, kindOfVariate: kindOfVariate, variateName: p.label!, superClass: newobj)
                            }else if value == nil {
                                //TODO:⚠️当前数据的属性为空
                                printDebug("⚠️当前数据的属性:\(p.label!)为空")
                            }else {
                                //TODO:检查属性
                                let isAble = self.checkTypeIsAble(type: vMir.subjectType, variateName: p.label!)
                                if isAble {
                                    newobj.setValue(value, forKey: p.label!)
                                }
                            }
                        }
                    }
                    objArray.append(newobj)
                }
                //TODO:✅当前数据的属性正常处理
                printDebug("✅对象属性\(variateName)数组总数:\(objArray.count)")
                superClass.setValue(objArray, forKey: variateName)
            }
        }
    }
    
    //MARK:检查属性是否可用
    
    /// 检查属性是否可用
    /// 由于不可描述的原因, swift有一些特定的类型, 不可以直接使用open func setValue(_ value: Any?, forKey key: String)方法进行直接赋值.
    ///
    /// - Parameters:
    ///   - type: 属性的类型
    ///   - variateName: 属性的名称
    /// - Returns: 是否可用
    func checkTypeIsAble(type:Any.Type, variateName:String) -> Bool {
        var isAble = true
        for kind in disabledKinds {
            if type == kind {
                printDebug("⚠️\(variateName)为不可直接赋值的属性, 例如 Int! Int? Double! Double? \n🙋‍♂️请在声明时指定其默认值 EX: var value:Int = 0")
                isAble = false
                break
            }
        }
        return isAble
    }
    
    //MARK: 将模型转换成dict结构体
    
    /// 将模型转换成dict结构体
    ///
    /// - Returns:
    func tranToDict() -> Dictionary<String, Any> {
        var mainDict = Dictionary<String, Any>.init()
        let mir = Mirror.init(reflecting: self)
        let mirChildren = mir.children
        printDebug("➡️当前类的属性总数为\(mirChildren.count)")
        for p in mirChildren {
            if p.label == nil {
                printDebug("⚠️->> 属性名为空不处理")
                continue
            }
            let vMir = Mirror.init(reflecting: p.value)
            let pType = vMir.subjectType
            let isDirect = checkTypeIsAbleForTransform(type: pType, veriateName: p.label!)
            if isDirect {
                printDebug("✅\(p.label!)的数据类型为\(pType), 无需处理直接赋值")
                mainDict.updateValue(p.value, forKey: p.label!)
            }else {
                //判断是否是Array
                let kindOfVariate = "\(vMir.subjectType)"
                let range = kindOfVariate.range(of: "Array")
                if range == nil {
                    printDebug("↩️\(p.label!)的数据类型为\(pType), 进行单个model处理")
                    let subDict = structureDictForModel(model: p.value, variateName: p.label!)
                    mainDict.updateValue(subDict, forKey: p.label!)
                }else {
                    printDebug("↩️\(p.label!)的数据类型为\(pType), 进行数组处理")
                    let subArray = structureDictsArrayForModelsArray(models: p.value, variateName: p.label!)
                    mainDict.updateValue(subArray, forKey: p.label!)
                }
            }
        }
        
        return mainDict
    }
    
    //MARK: 通过model构造dict
    func structureDictForModel(model:Any, variateName:String) -> Dictionary<String, Any> {
        var mainDict = Dictionary<String, Any>.init()
        let mir = Mirror.init(reflecting: model)
        let mirChildren = mir.children
        printDebug("➡️\(variateName)的属性总数为\(mirChildren.count)")
        for p in mirChildren {
            if p.label == nil {
                printDebug("⚠️->> 属性名为空不处理")
                continue
            }
            let vMir = Mirror.init(reflecting: p.value)
            let pType = vMir.subjectType
            let isDirect = checkTypeIsAbleForTransform(type: pType, veriateName: p.label!)
            if isDirect {
                printDebug("✅\(p.label!)的数据类型为\(pType), 无需处理直接赋值")
                mainDict.updateValue(p.value, forKey: p.label!)
            }else {
                //判断是否是Array
                let kindOfVariate = "\(vMir.subjectType)"
                let range = kindOfVariate.range(of: "Array")
                if range == nil {
                    printDebug("↩️\(p.label!)的数据类型为\(pType), 进行单个model处理")
                    let subDict = structureDictForModel(model: p.value, variateName: p.label!)
                    mainDict.updateValue(subDict, forKey: p.label!)
                }else {
                    printDebug("↩️\(p.label!)的数据类型为\(pType), 进行数组处理")
                    let subArray = structureDictsArrayForModelsArray(models: p.value, variateName: p.label!)
                    mainDict.updateValue(subArray, forKey: p.label!)
                }
            }
        }
        return mainDict
    }
    
    //MARK: 通过model的数组构造dict的数组
    func structureDictsArrayForModelsArray(models:Any, variateName:String) -> Array<Dictionary<String, Any>> {
        var mainArray = Array<Dictionary<String, Any>>.init()
        let modelsArray = models as? Array<Any>
        if modelsArray == nil {
            printDebug("⚠️\(variateName)的数组转换失败!")
            return mainArray
        }
        printDebug("➡️\(variateName)的数组总数为\(modelsArray!.count)")
        for model in modelsArray! {
            let dict = structureDictForModel(model: model, variateName: variateName)
            mainArray.append(dict)
        }
        return mainArray
    }
    
    //MARK: 检查类型是否可以直接转换
    func checkTypeIsAbleForTransform(type:Any.Type, veriateName:String) -> Bool {
        for kind in transformAbleKinds {
            if type == kind {
                return true
            }
        }
        return false
    }
}

