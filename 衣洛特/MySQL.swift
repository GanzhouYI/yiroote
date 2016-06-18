//
//  SQL.swift
//  getImage
//
//  Created by __________V|R__________ on 16/4/17.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation

//execute query区别 execute返回总行数，query返回一条执行语句的数据
class MySQL
{
    
    static var SQL:MySQL?
    static var predicate:dispatch_once_t = 0

    class func shareMySQL() -> MySQL {
        dispatch_once(&predicate) { () -> Void in
            SQL = MySQL()
            //获取数据库实例
        }
        return SQL!
    }
    
    
//从SQLite加载数据
    func initUser(user:[String:String]) {
    //如果数据库不存在则创建数据库
        var db:COpaquePointer = nil//这是swift里的一个c指针  如果不知道指针类型就可以这样定义
        
        let documentsPath:String = {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            return paths.first!
        }()

        let path:NSString = "\(documentsPath)/yiroote.sqlite.3"
        let filename = path.UTF8String//转换成c的字符串
        
        if sqlite3_open(filename,&db) != SQLITE_OK
        {
            print("create or open failed...\n")
            sqlite3_close(db)
        }
        else
        {
            print("open DB")
        }

        
    //如果表还不存在则创建表（其中uid为自增主键）
    SQLiteDB.sharedInstance().execute("create table if not exists yiroote_User(uid integer primary key,username varchar(30),pwd varchar(50),email varchar(30),phone varchar(20),gender varchar(4),intro text,diqu varchar(40),logo varchar(50))")
        
        let sqlString = "select * from yiroote_User where username ='"+user["username"]!+"'"
        let data = SQLiteDB.sharedInstance().query(sqlString)
        if data.count > 0 {
            //存在，更新数据
            print("init yiroote_User存在")
            updateUser(data[data.count-1]["username"]as!String, user: data[data.count-1])
        }
        else{
            //不存在，创建用户
            print("init yiroote_User不存在")
            let sql = "insert into yiroote_User(username,pwd,email,phone,gender,intro,diqu,logo) values('\(user["username"]!)','\(user["pwd"]!)','\(user["email"]!)','\(user["phone"]!)','\(user["gender"]!)','\(user["intro"]!)','\(user["diqu"]!)','\(user["logo"]!)')"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
            print(result)
        }
        
        let createStrDynamic = "create table if not exists yiroote_Dynamic(dynamic_id integer primary key,uid int,dynamic_image text,dynamic_text text,dynamic_num_people_watch int,dynamic_num_people_praise int,dynamic_date datetime,dynamic_title text,foreign key (uid) references yiroote_User(uid) on delete cascade)"
        //如果表还不存在则创建表（其中uid为自增主键）
        SQLiteDB.sharedInstance().execute(createStrDynamic)
}


    func searchUser(username:String)->Dictionary<String,AnyObject>
{
    let sqlString = "select * from yiroote_User where username ='"+username+"'"
    var data = SQLiteDB.sharedInstance().query(sqlString)
    var user:[String:AnyObject] = ["succeed":"false"]
    if data.count > 0 {
        //获取最后一行数据显示
        user = data[data.count - 1]
        user["succeed"] = "true"
    }
    print("searchUser")
    print(user)
    return user
}

    func updateUser(username:String,user:[String:AnyObject]){
        print("updateUser")
        let sql = "update yiroote_User set uid = '\(user["uid"]!)',username = '\(user["username"]!)',pwd = '\(user["pwd"]!)',email = '\(user["email"]!)',phone = '\(user["phone"]!)',gender = '\(user["gender"]!)',intro = '\(user["intro"]!)',diqu = '\(user["diqu"]!)',logo = '\(user["logo"]!)' where username = '\(username)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
}
        
    func deleteUser(username:String){
        let sql = "delete from yiroote_User where username = '\(username)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }
    
    func deleteOtherUser(username:String){
        //<>是!=的意思，<>通用，!=可能不通用
        let sql = "delete from yiroote_User where username <> '\(username)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }
    
//保存数据到SQLite
func saveUser() {
//    let uname = self.txtUname.text!
//    let mobile = self.txtMobile.text!
//    //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
//    let sql = "insert into t_user(uname,mobile) values('\(uname)','\(mobile)')"
//    print("sql: \(sql)")
//    //通过封装的方法执行sql
//    let result = SQLiteDB.sharedInstance().execute(sql)
//    print(result)
}

}
