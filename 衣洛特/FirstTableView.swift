import UIKit

class FirstTableView:UITableView,UITableViewDelegate, UITableViewDataSource,
First_ScrollView_Protocol{
    //用于保存所有消息
    var bubbleSection:Array<FirstTableMessageItem>!
    //数据源，用于与 ViewController 交换数据
    var imageArray :[String!] = ["衣洛特iOS图标/beautiful1.png","衣洛特iOS图标/beautiful2.png","衣洛特iOS图标/beautiful3.png","衣洛特iOS图标/beautiful4.png"]
    var First_Scroll_Title :[String!] = ["beautiful1.png","iOS图标/beautiful2.png","衣洛特iOS图标/beautiful3.png","衣洛特iOS图标/beautiful4.png"]
    weak var didSelectDelegate : First_Table_Delegate?
    //拉刷新控制器
    var refreshControl = UIRefreshControl()
    var timer:NSTimer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame:CGRect)
    {
        self.bubbleSection = Array<FirstTableMessageItem>()
        
        super.init(frame:frame,  style:UITableViewStyle.Plain)

        var First_Scroll = First_ScrollView()
        First_Scroll = First_ScrollView(frame: CGRectMake(0, 0, self.frame.width, 200*高比例),defaultTimeInterval: 3)
        First_Scroll.backgroundColor = UIColor.clearColor()
        First_Scroll.delegate = self
        self.backgroundColor = UIColor.grayColor()
        self.tableHeaderView = First_Scroll
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        //添加刷新
        refreshControl.addTarget(self, action: "refreshData",
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.addSubview(refreshControl)
        
        
        MySQL.shareMySQL().removeAllDynamic()
        refreshData()
    }
 
    // 刷新数据
    func refreshData() {
        //移除老数据

        //导入本地数据
        searchDynamicToFirstTable()
        //刷新远程数据
        updateNewDynamic()
        
    }
    
    func searchDynamicToFirstTable(){
        //self.bubbleSection
        self.bubbleSection=MySQL.shareMySQL().searchDynamic()
    }
    
    func updateNewDynamic(){
        var ind:Int=1
        let str:String = MySQL.shareMySQL().lastDateDynamic()
        downDynamic.sharedDownDynamic()?.conNet(str,block:{(dataInfo,data) -> Void in
            if dataInfo == "已经是最新的"
            {
                print("updateDynamicFirst() 已经是最新的")
            }
            else if dataInfo == "有更新数据"
            {
                print("有更新数据，开始往table和本地数据库导入")
                for i in 0..<data.count
                {
                    var tempdata = data[i]
                    let temp = FirstTableMessageItem(dynamic_id:data[i][0],FirstTableImage: data[i][2],FirstTableTitle: data[i][7],FirstTableDetail: data[i][3],FirstTable_yanjin_Num: Int(data[i][4])!,FirstTable_pinglun_Num: Int(data[i][5])!)
                    self.bubbleSection.append(temp)
                    MySQL.shareMySQL().insertDynamic(data[i])
                    downDynamic.sharedDownDynamic()?.downDynamicImage(data[i][2],dynamic_id: data[i][0])
                }
            }
            else if dataInfo == "网络连接错误"
            {
                print("FirstTable网络错误")
                MBProgressHUD.showDelayHUDToView(self, message: "网络连接错误")
            }
            //获取数据完毕
            super.reloadData()
            self.reloadData()
            self.refreshControl.endRefreshing()
        })
        
    }
    
    
    override func reloadData()
    {
        
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = true//滚动的提示条
        
        super.reloadData()
    }
    //第一个方法返回分区数，在本例中，就是1
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {
        return 1
    }
    
    /** First_ScrollViewDelegate*/
    func First_numberOfPages() -> Int {
        
        return imageArray.count;
    }
    func First_currentPageViewIndex(index: Int) -> String {
        
        return imageArray[index]
    }
    func First_didSelectCurrentPage(index: Int) {
        
        
    }
    func First_currentPageLabel_Title(index: Int) -> String {
        return First_Scroll_Title[index]
    }

    
    //返回指定分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bubbleSection.count
    }
        
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        
        return 140
    }

    
    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
          
            let cellId = "MsgCell"
            let data =  self.bubbleSection[indexPath.row]
            let image_frame = CGRectMake(0, 0, self.frame.width, 120)
            let cell =  FirstTableViewCell(frame:image_frame,data:data, reuseIdentifier:cellId)
            return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        self.didSelectDelegate?.First_Table_DidSelect(indexPath.row,bubbleSection: self.bubbleSection[indexPath.row])
    }
}
