import router from '@ohos.router'

@Entry
@Component
struct SecondPage {
  @State private param: string = router.getParams()?.["param"]

  build() {
    Column() {
      Text("第二个页面")
        .fontSize(20)

      Text(this.param).margin({ top: 10, bottom: 10 })
      Button("返回")
        .width("50%")
        .height(50)
        .backgroundColor(Color.Pink)
        .onClick(() => {
          router.back()
        })
    }
    .width("100%")
    .height("100%")
  }
}