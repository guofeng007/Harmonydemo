import { ItemComponent } from './ItemComponent'
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
        //事件方法：点击事件响应
        // .onClick(() => {
        //   //...
        // })
        // .onClick(function (){
        //   //...
        // }.bind(this))

        this.buildButton()

        ItemComponent({ isDone: false })
        ForEach(this.product, (item) => {
          ItemComponent({ content: item })
        })
      }
      .width('100%')
    }
    .height('100%')
  }

  //组件内
  //必须用@Builder装饰的函数里创建组件 否则不能调用
  @Builder buildButton() {
    Button('add counter')
      .margin(10)
      .padding(15)
      .backgroundColor(Color.Pink)
      .fontWeight(FontWeight.Bold)
      .onClick(this.myClickHandler.bind(this))
  }

  myClickHandler(): void {
    this.count++;
    console.log(`点击了${this.count}次`)
  }
}

/*
 * 组件外：自定义构建函数
 * 需要function关键字
 * */
@Builder function buildButton() {
  Button('add counter')
    .margin(10)
    .onClick(this.myClickHandler.bind(this))
}

/**
 * @Extend仅支持定义在全局，不支持在组件内部定义相。可以添加参数
 * 支持私有事件
 * @param size
 */
@Extend(Text) function setCustomText(fontSize: number | string) {
  .fontColor(Color.Red)
  .fontSize(fontSize)
}

/**
 * @Styles封装的样式可以定义在全局也可以定义在组件内部
*   需要加function 不支持传参数 只支持通用属性和通用事件
 */
@Styles function globalFancy() {
  .width(150)
  .height(100)
  .backgroundColor(Color.Pink)
}



