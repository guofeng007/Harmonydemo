# 鸿蒙Harmony开发初探

## 一、背景

9月25日华为秋季全场景新品发布会，余承东宣布鸿蒙HarmonyOS NEXT蓄势待发，不再支持安卓应用。网易有道、同程旅行、美团、国航、阿里等公司先后宣布启动鸿蒙原生应用开发工作。

## 二、鸿蒙Next介绍

HarmonyOS是一款面向万物互联，全新的分布式操作系统。

**1**、鸿蒙**Next(5.0)*系统底座全栈自研，去掉了传统的***AOSP代码。

**2**、仅支持鸿蒙内核和鸿蒙系统的应用。

**3**、业内人士向证券时报公司记者表示：“华为内部确实有这计划，就是明年Q1推出不兼容安卓的鸿蒙版本，但目前内部还没有下发相关通知，所以具体何时推出暂不明确



## 三、鸿蒙系统开发

### 鸿蒙系统架构

![image-20231204210402419](https://p.ipic.vip/bfcc9t.png)

### 3.1 IDE

HUAWEI DevEco Studio  基于IntelliJ IDEA Community开源版本定制开发，支持HarmonyOS和OpenHarmony应用及服务开发。

下载地址：https://developer.harmonyos.com/cn/develop/deveco-studio/

### 3.2 示例讲解

github地址： https://github.com/guofeng007/Harmonydemo

界面效果：





![xxxxx](https://pic.imgdb.cn/item/656ec45ec458853aeff1fc9b.png)




#### 全局配置

![image-20231204211454946](https://p.ipic.vip/r8hbxy.png)





```
{
  "app": {
  // 最重要的是包名，版本号，图片和app名称
    "bundleName": "com.example.myapplication", 
    "vendor": "example",
    "versionCode": 1000000,
    "versionName": "1.0.0",
    "icon": "$media:app_icon",
    "label": "$string:app_name"
  }
}
```

#### 模块配置

```
{
  "module": {
    "name": "entry",
    "type": "entry",
    // 模块生命周期入口 
    "srcEntry": "./ets/MyAbilityStage.ts", 
    "description": "$string:module_desc",
    // 应用入口
    "mainElement": "EntryAbility",
    "deviceTypes": [
      "phone"
    ],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
      // 入口具体声明配置，参考android
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ts",
        "description": "$string:EntryAbility_desc",
        "icon": "$media:icon",
        "label": "$string:EntryAbility_label",
        "startWindowIcon": "$media:icon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": [
              "entity.system.home"
            ],
            "actions": [
              "action.system.home"
            ]
          }
        ]
      }
    ]
  }
}
```

#### APP模块全局声明周期



```
import AbilityStage from '@ohos.app.ability.AbilityStage';

export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    // 应用的HAP在首次加载的时，为该Module初始化操作
  }
  onAcceptWant(want) {
    // 仅specified模式下触发
    return "MyAbilityStage";
  }
}
```



#### 入口任务栈

这个比较重要，对从安卓转过来的同学来说，可以理解为一个TaskStack，在手机的多任务栏，显示为一个任务，是一个任务容器。


EntryAbility 继承自 UIAbility 并实现了其中的 onCreate 、onDestroy 、 onWindowStageCreate 、 onWindowStageDestroy 、 onForeground 、 onBackground 等方法，显然，这些方法就是这个 ability 的生命周期。
然后在 onWindowStageCreate 生命周期中通过 windowStage.loadContent 加载了 pages/Index 的内容，pages/Index就相当于我们的入口UI页面。

UIAbility介绍：
UIAbility是一种包含用户界面的应用组件，主要用于和用户进行交互。UIAbility也是系统调度的单元，为应用提供窗口在其中绘制界面。
每一个UIAbility实例，都对应于一个最近任务列表中的任务。
一个应用可以有一个UIAbility，也可以有多个UIAbility。
一个UIAbility可以对应于多个页面。

![img](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20231204103813.10599470521323982699022457348898:50001231000000:2800:A9DF4780F0C3E1BC1085A689441400880F1E6C52B818A7CDE88D12A699CF0E02.png?needInitFileName=true?needInitFileName=true)


- UIAbility&Window生命周期

  

  ![img](https://p.ipic.vip/vzmx7b.png)

- UIAbility的启动模式

  是指UIAbility实例在启动时的不同呈现状态。针对不同的业务场景，系统提供了三种启动模式：

  - [singleton（单实例模式）](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/uiability-launch-type-0000001428061476-V3#ZH-CN_TOPIC_0000001523489150__singleton启动模式)
  - [multiton（多实例模式）](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/uiability-launch-type-0000001428061476-V3#ZH-CN_TOPIC_0000001523489150__standard启动模式)
  - [specified（指定实例模式）](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/uiability-launch-type-0000001428061476-V3#ZH-CN_TOPIC_0000001523489150__specified启动模式)

```
import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
```

#### 路由配置

```
{
  "src": [
    "pages/Index",
    "pages/routes/FirstPage",
    "pages/routes/SecondPage",
    "pages/routes/WebComponent"
  ]
}
```



### 3.3 ArkUI

ArkUI的基本单元是组件，组件是一个独立子页面或者子模块。示例代码有注释，包含页面UI组件，状态，route跳转。

组件声明周期

![img](https://p.ipic.vip/9tpxsc.png)

```
import router from '@ohos.router'

@Entry //@Entry表示该自定义组件为入口组件
@Component //@Component表示自定义组件
struct Index {
  //@State表示组件中的状态变量，状态变量变化会触发UI刷新
  @State count: number = 1
  @State url: string = "https://img1.baidu.com/it/u=3302184040,3713353210&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"
  private product: string[] = ['PC。', "平板。", `手环。`]
  //UI描述：以声明式的方式来描述UI的结构，例如build()方法中的代码块。
  build() {
    //系统组件：ArkUI框架中默认内置的基础和容器组件,比如示例中的Row、Column、Text
    //不允许在UI描述里直接使用声明局部变量
    // let a = 1 ERROR
    Row() {
      Column() {
        Button("Page跳转")
          .onClick(()=>{
            router.pushUrl({ url: "pages/routes/FirstPage", params: {
              param: "第一个页面传来的值",
            } })
          })
        Button("Webview跳转")
          .onClick(()=>{
            router.pushUrl({ url: "pages/routes/WebComponent", params: {
              param: "第一个页面传来的值",
            } })
          })
        Text(this.count.toString())
          //属性方法：组件可以通过链式调用配置多项属性，如fontSize()、width()、height()、backgroundColor()等
          .fontWeight(FontWeight.Bold)
            //定义扩展原生组件样式
          .setCustomText(30)
          }
         }
       }
}
```

### 3.4 Webview

在原生APP组件开发过程中，很多活动页面都是h5实现，但是需要很多原生的能力，比如相机，这种情况下就需要类似JsBridge方式的WebView

```
import webView from '@ohos.web.webview';

@Entry
@Component
struct WebComponent {
  controller: webView.WebviewController = new webView.WebviewController();
  webUrl: string = 'https://www.baidu.com/'
  jsBridge = {
    callNaMethod() {
      console.log("H5调用Native方法")

    }
  }

  aboutToAppear(){
    webView.WebviewController.setWebDebuggingAccess(true)
  }

  build() {
    Stack() {
      //加载网络url
      // Web({ src: this.webUrl, controller: this.controller })
      //加载本地html
      Web({ src: $rawfile("demo.html"), controller: this.controller })
        //允许访问本地文件
        .fileAccess(true)
          //设置是否允许执行JavaScript脚本
        .javaScriptAccess(true)
          //注入JavaScript对象到window对象中，并在window对象中调用该对象的方法
        .javaScriptProxy({
          object: this.jsBridge,
          name: "jsBridge",
          methodList: ["callNaMethod"],
          controller: this.controller
        })
        .onPageEnd(event => {
          //异步执行JavaScript脚本 调用H5方法
          this.controller.runJavaScript("callH5Method()")
            .then(result => {
              console.log(`H5返回值=${result}`)
            })
            .catch(error => {
              console.error("error: " + error);
            })
        })
    }
  }
}
```

#### 测试html

```tsx
<!DOCTYPE html>

<html>

<body>




<!--调用原生方法-->
<button type="button" onclick="window.jsBridge.callNaMethod()">点击调用原生界面方法</button>
</body>

<script type="text/javascript">
  function callH5Method() {
     
      return "从H5返回"
  }
</script>
</html>
```

#### 3.5 Devtools调试webview

1. 代码中允许webview调试 web_webview.WebviewController.setWebDebuggingAccess(true);


```
// xxx.ets
import web_webview from '@ohos.web.webview';

@Entry
@Component
struct WebComponent {
  controller: web_webview.WebviewController = new web_webview.WebviewController();
  aboutToAppear() {
    // 配置web开启调试模式
    web_webview.WebviewController.setWebDebuggingAccess(true);
  }
  build() {
    Column() {
      Web({ src: 'www.example.com', controller: this.controller })
    }
  }
}
```



2. 用hdc命令行工具

（需要全局设置path  /Users/你的用户名/Library/Huawei/Sdk/hmscore/3.1.0/toolchains/）
```
// 添加映射 

hdc fport tcp:9222 tcp:9222 

// 查看映射 

hdc fport ls
```

3. 在PC端chrome浏览器地址栏中输入chrome://inspect/#devices，页面识别到设备后，就可以开始页面调试。调试效果如下：

![image-20231205135433565](https://pic.imgdb.cn/item/656ec48ec458853aeff29a55.png)

### 总结

鸿蒙整体上开发很像Kotlin Compose，也借鉴了很多大前端比如Vue的响应式编程理念，有以上经验的很容易上手。
