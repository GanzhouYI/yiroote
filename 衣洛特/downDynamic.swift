//
//  MyNet.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/4/7.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//
import Foundation
import Alamofire

class downDynamic:NSObject {
    static var Model:downDynamic?
    static var predicate:dispatch_once_t = 0
    class func sharedDownDynamic()->downDynamic?{
        
        dispatch_once(&predicate) { () -> Void in
            Model = downDynamic()
        }
        return Model
    }
    
    
    
    typealias NetworkBlock = (dataInfo:String,data:[[String]])->Void
    
    func conNet(dynamic_date:String,block:NetworkBlock?)
    {
        let urlString:String = "http://www.loveinbc.com/yiroote/downDynamic.php"
        let parameters = ["dynamic_date": dynamic_date]
        print("输出更新动态请求的lastDate")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "已经是最新的")
                    {
                        print("已经是最新的")
                        block!(dataInfo:"已经是最新的",data:[[""]])
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有更新数据多少条")
                        print(JSON.count)
                        print("输出更新的数据")
                        var infoData=[[String]]()
                        for i in 0..<JSON.count
                        {
                            MySQL.shareMySQL().insertDynamic(JSON[i] as! [String])
                            infoData.append(JSON[i] as! [String])
                        }
                        print(infoData)
                        print("以上输出更新的数据")
                        block!(dataInfo:"有更新数据",data: infoData)
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    block!(dataInfo:"网络错误",data:[[""]])
                    break
                }
        }
        
        
    }
    
    func downDynamicImage(url:String,dynamic_id:String){
        //按动态id命名图片
        var userDirForDynamic="/yiroote/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic"
        print("downkaishi ")
        print(userDirForDynamic)
        download.shareMyDownload().downImage(url,dir:userDirForDynamic,fileName:dynamic_id,fileType:".jpg")
    }
    
    
}

