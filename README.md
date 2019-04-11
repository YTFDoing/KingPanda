# KingPanda

[![CI Status](https://img.shields.io/travis/hsdoing@163.com/KingPanda.svg?style=flat)](https://travis-ci.org/hsdoing@163.com/KingPanda)
[![Version](https://img.shields.io/cocoapods/v/KingPanda.svg?style=flat)](https://cocoapods.org/pods/KingPanda)
[![License](https://img.shields.io/cocoapods/l/KingPanda.svg?style=flat)](https://cocoapods.org/pods/KingPanda)
[![Platform](https://img.shields.io/cocoapods/p/KingPanda.svg?style=flat)](https://cocoapods.org/pods/KingPanda)

# KingPanda介绍
###KingPanda基于Alamofire三方库进行封装,依赖ObjectMapper

#KingPanda安装
####通过[CocoaPods](https://cocoapods.org)安装, 在Podfile里添加如下代码：

```ruby
pod 'KingPanda'
```
#KingPanda使用
####配置网络请求的BaseUrl
####在Appdelegate里导入KingPanda模块，并配置baseUrl，如下:

> ###
>       import KingPanda
>       @UIApplicationMain
>       class AppDelegate: UIResponder, UIApplicationDelegate {

>              var window: UIWindow?

>       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
>         //配置URL
>               NetworkConfig.shared.baseUrl = "https://www.baidu.com"
>         
>               return true
>           }                 
>       }

###新建swift文件，创建类名，导入KingPanda, 并继承KingPanda和增加初始化方法，如：
> ####
>       import Watermelon
>       Class TestApi: KingPanda {
            override init() {
                super.init()
                configInfo = self
            }
>       }
> 

###配置请求所需参数

####实现网络配置协议

>       extension HomeApi: NetworkConfigInfo {
>           //该类型为请求成功后返回的数据类型，.model表示返回的是自定义model类型
>           var responseType: ResponseType? {
>               return .model
>           }
> 
>           var method: HttpMethod? {
>                return .POST
>           }
> 
>           var baseUrl: String? {
>                return NetworkConfig.shared.baseUrl
>           }
>     
>           var pathUrl: String? {
>               return "/init.do"
>           }
>     
>           var customRequestUrl: String? {
>               return nil
>           }
>     
>           var requestParams: [String : Any]? {
>               return nil
>           }
>     
>           var httpHeader: [String : String]? {
>               return nil
>           }
>       }

###配置自定义Model
>       import ObjectMapper
>       class TestModel: Mappable {
>           var code: Int?
>           var data: [TestDataModel]?
>           var ts: Double?

>           init() {}
>     
>           required init?(map: Map) {
>         
>           }
>     
>           func mapping(map: Map) {
>               code <- map["code"]
>               data <- map["data"]
>               ts   <- map["ts"]
>           }
>       }
> 
>       class TestDataModel: Mappable {
>           ......
>       }

###网络请求
####返回model的请求

>         let apiManager = TestApi()
>         apiManager?.requestSuccessed = { (result) in
>             
>         }
>         
>         apiManager?.requestFailed = { (result) in
>             
>         }

>         apiManage?.start(withModel: TestModel())


####返回Json的请求有两种：
#####第一种方式为：
>         let apiManager = TestApi()
>         apiManager.delegate = self
>         apiManager.start()
>         
>         extension HomeViewModel: ResponseProtocol {
>             public func requestSuccess(_ result: BaseRequest) {
>                 //请求成功
>             }
>     
>             public func requestFailure(_ result: BaseRequest) {
>                 //请求失败
>             }
>         }

#####第二种方式为：
>         let apiManager = TestApi()
>         apiManage?.startRequestWithClosure(successed: { (result) in
>             //请求成功
>         }, failed: { (resule) in
>             //请求成功
>         })
        








