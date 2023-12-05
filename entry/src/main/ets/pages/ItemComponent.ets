@Component
export struct ItemComponent {
  private url: string = "https://img1.baidu.com/it/u=3302184040,3713353210&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"
  // 自定义组件可以使用变量(都是私有化的) 传递参数
  private content: string = '手机。'
  // 哪种情况可以驱动UI更新。@state
  @State private isDone: boolean = false

  build() {
    Row() {
      Image(this.url)
        .width(20)
        .height(20)
        .margin(15)
      Text(this.content)
        .decoration({ type: this.isDone ? TextDecorationType.LineThrough : TextDecorationType.None })
    }
    .backgroundColor(Color.Pink)
    .borderRadius(25)
    .margin(12)
    .padding(4)
    .onClick(() => {
      this.isDone = !this.isDone
    })
  }
}